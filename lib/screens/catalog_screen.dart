import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/store_service.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_modal.dart';
import '../widgets/app_image.dart';
import '../widgets/footer.dart';

class CatalogScreen extends StatefulWidget {
  final String? initialCategory;

  const CatalogScreen({super.key, this.initialCategory});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  String _selectedBadge = 'الكل';
  String _selectedSize = 'الكل';
  String _sortBy = 'default'; // 'default', 'price_asc', 'price_desc', 'discount'
  bool _inStockOnly = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'الكل';
      _selectedBadge = 'الكل';
      _selectedSize = 'الكل';
      _sortBy = 'default';
      _inStockOnly = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoreService>(context);
    final allProducts = storeService.products;
    final categories = storeService.categories;
    final mobile = MediaQuery.sizeOf(context).width < 720;

    // Collect all unique badges and sizes for filter options
    final Set<String> badges = {'الكل', 'جديد', 'الأكثر مبيعاً', 'عرض', 'محدود'};
    for (var p in allProducts) {
      if (p.badge != null && p.badge!.trim().isNotEmpty) {
        badges.add(p.badge!.trim());
      }
    }

    final Set<String> sizes = {'الكل', 'S', 'M', 'L', 'XL', 'XXL'};

    // Apply Filters
    List<Product> filteredProducts = allProducts.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.nameAr.contains(_searchQuery) ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.categoryName.contains(_searchQuery);

      final matchesCategory = _selectedCategory == 'الكل' || p.categoryName == _selectedCategory;

      final matchesBadge = _selectedBadge == 'الكل' || (p.badge != null && p.badge == _selectedBadge);

      final matchesSize = _selectedSize == 'الكل' || p.sizes.contains(_selectedSize);

      final matchesStock = !_inStockOnly || p.isAvailable;

      return matchesSearch && matchesCategory && matchesBadge && matchesSize && matchesStock;
    }).toList();

    // Apply Sorting
    if (_sortBy == 'price_asc') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price_desc') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'discount') {
      filteredProducts = filteredProducts.where((p) => p.oldPrice != null && p.oldPrice! > p.price).toList();
      filteredProducts.sort((a, b) => (b.oldPrice! - b.price).compareTo(a.oldPrice! - a.price));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: paper,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: ink, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'كتالوج جميع المنتجات والمجموعات',
            style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: ink),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 16 : MediaQuery.sizeOf(context).width > 1500 ? 100 : 56,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              const Text(
                'تصفح الكتالوج الكامل',
                style: TextStyle(
                  fontSize: 10,
                  color: olive,
                  letterSpacing: 1.5,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'جميع المقاسات والألوان والتصاميم المتاحة',
                style: TextStyle(
                  fontSize: mobile ? 20 : 28,
                  fontWeight: FontWeight.w700,
                  color: ink,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 16),

              // Categories Cards Carousel
              SizedBox(
                height: 58,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = _selectedCategory == cat.nameAr;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: () => setState(() => _selectedCategory = cat.nameAr),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? ink : paper,
                            border: Border.all(color: isSelected ? ink : line),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 30,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
                                clipBehavior: Clip.antiAlias,
                                child: AppImage(imageUrl: cat.imageUrl, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat.nameAr,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? Colors.white : ink,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Search Input & Filter Actions Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: ink, fontFamily: 'Cairo', fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن قطعة، هوديز، تيشيرت...',
                        hintStyle: const TextStyle(color: muted, fontSize: 12, fontFamily: 'Cairo'),
                        prefixIcon: const Icon(Icons.search, color: ink, size: 18),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 16, color: ink),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: const BorderSide(color: line),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: const BorderSide(color: line),
                        ),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 14, color: ink),
                    label: const Text('إعادة ضبط', style: TextStyle(fontSize: 11, color: ink, fontFamily: 'Cairo')),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: line),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      shape: const RoundedRectangleBorder(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Professional Filter Pills Row (Sort + Badges + In Stock)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Sort Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: line),
                      ),
                      child: DropdownButton<String>(
                        value: _sortBy,
                        underline: const SizedBox.shrink(),
                        icon: const Icon(Icons.sort, size: 16, color: ink),
                        style: const TextStyle(fontSize: 11, color: ink, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                        items: const [
                          DropdownMenuItem(value: 'default', child: Text('الترتيب الافتراضي')),
                          DropdownMenuItem(value: 'price_asc', child: Text('السعر: الأقل للأعلى')),
                          DropdownMenuItem(value: 'price_desc', child: Text('السعر: الأعلى للأقل')),
                          DropdownMenuItem(value: 'discount', child: Text('التخفيضات فقط 🔥')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _sortBy = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Stock Toggle Chip
                    FilterChip(
                      selected: _inStockOnly,
                      label: const Text('المتوفر فقط', style: TextStyle(fontSize: 11, fontFamily: 'Cairo')),
                      selectedColor: ink,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _inStockOnly ? Colors.white : ink,
                        fontWeight: _inStockOnly ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: paper,
                      shape: RoundedRectangleBorder(side: BorderSide(color: _inStockOnly ? ink : line)),
                      onSelected: (val) => setState(() => _inStockOnly = val),
                    ),
                    const SizedBox(width: 8),

                    // Badge Filter Chips
                    ...badges.map((b) {
                      final isSel = _selectedBadge == b;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: ChoiceChip(
                          selected: isSel,
                          label: Text(b, style: const TextStyle(fontSize: 11, fontFamily: 'Cairo')),
                          selectedColor: ink,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : ink,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: paper,
                          shape: RoundedRectangleBorder(side: BorderSide(color: isSel ? ink : line)),
                          onSelected: (val) => setState(() => _selectedBadge = val ? b : 'الكل'),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Sizes Quick Filter Row
              Row(
                children: [
                  const Text('المقاس: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ink, fontFamily: 'Cairo')),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sizes.map((s) {
                          final isSel = _selectedSize == s;
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: InkWell(
                              onTap: () => setState(() => _selectedSize = s),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? ink : paper,
                                  border: Border.all(color: isSel ? ink : line),
                                ),
                                child: Text(
                                  s,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSel ? Colors.white : ink,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Results Count Bar
              Row(
                children: [
                  Text(
                    'تم العثور على ${filteredProducts.length} قطعة',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: olive, fontFamily: 'Cairo'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Products Grid or Empty State
              filteredProducts.isEmpty
                  ? Container(
                      height: 260,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_outlined, size: 40, color: muted),
                          const SizedBox(height: 12),
                          const Text(
                            'لا توجد منتجات مطابقة للفلاتر المحددة',
                            style: TextStyle(fontSize: 14, color: muted, fontFamily: 'Cairo'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: _resetFilters,
                            child: const Text('إعادة ضبط جميع الفلاتر', style: TextStyle(fontFamily: 'Cairo')),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: mobile ? 2 : MediaQuery.sizeOf(context).width < 1100 ? 3 : 4,
                        childAspectRatio: mobile ? .61 : .69,
                        crossAxisSpacing: mobile ? 12 : 22,
                        mainAxisSpacing: mobile ? 26 : 38,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: paper,
                              barrierColor: ink.withValues(alpha: .55),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                              builder: (ctx) => ProductDetailModal(
                                product: filteredProducts[index],
                                store: storeService.settings,
                              ),
                            );
                          },
                        );
                      },
                    ),

              const SizedBox(height: 60),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
