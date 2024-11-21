import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'order_detail_screen.dart';
import '../utils/currency_converter.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;

  const CategoryMealsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  List<Map<String, dynamic>> _meals = [];
  bool _isLoading = true;
  final Map<String, int> _quantities = {};
  final Map<String, String> _selectedCurrencies = {};
  final Map<String, double> _convertedPrices = {};

  @override
  void initState() {
    super.initState();
    _fetchMealsByCategory(widget.category);
  }

  Future<void> _fetchMealsByCategory(String category) async {
    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] ?? [];

        setState(() {
          _meals = meals.map<Map<String, dynamic>>((meal) {
            final price = 10.0 + _meals.length * 2.0; // Harga default
            return {
              'idMeal': meal['idMeal'],
              'strMeal': meal['strMeal'],
              'strMealThumb': meal['strMealThumb'],
              'price': price,
            };
          }).toList();

          for (var meal in _meals) {
            _quantities[meal['idMeal']] = 0; // Default quantity
            _selectedCurrencies[meal['idMeal']] = 'USD'; // Default currency
            _convertedPrices[meal['idMeal']] = meal['price']; // Default price
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat makanan');
      }
    } catch (e) {
      debugPrint('Error fetching meals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _convertPrice(String mealId, String newCurrency) {
    final originalPrice =
        _meals.firstWhere((meal) => meal['idMeal'] == mealId)['price'];
    final convertedPrice =
        CurrencyConverter.convert(originalPrice, newCurrency);

    setState(() {
      _selectedCurrencies[mealId] = newCurrency;
      _convertedPrices[mealId] = convertedPrice;
    });
  }

  void _placeOrder() {
    final List<Map<String, dynamic>> orderDetails =
        _meals.where((meal) => _quantities[meal['idMeal']]! > 0).map((meal) {
      final mealId = meal['idMeal'];
      return {
        'name': meal['strMeal'],
        'thumbnail': meal['strMealThumb'],
        'quantity': _quantities[mealId],
        'price': _convertedPrices[mealId],
      };
    }).toList();

    final totalPrice = orderDetails.fold<double>(
      0.0,
      (sum, item) => sum + (item['quantity'] * (item['price'] ?? 0.0)),
    );

    final selectedCurrency = _selectedCurrencies.values.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(
          orderDetails: orderDetails,
          totalPrice: totalPrice,
          selectedCurrency: selectedCurrency,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.white,
          child: AppBar(
            title: Text(
              'Makanan Kategori: ${widget.category}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 39, 64, 102), // Transparent to show gradient
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0, // Remove shadow
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _meals.length,
                      itemBuilder: (context, index) {
                        final meal = _meals[index];
                        final mealId = meal['idMeal'];
                        final quantity = _quantities[mealId] ?? 0;

                        return Card(
                          color: const Color.fromARGB(255, 58, 90, 130),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        meal['strMealThumb'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.error),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        meal['strMeal'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Harga Asli: \$${meal['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton<String>(
                                      value: _selectedCurrencies[mealId],
                                      onChanged: (String? newCurrency) {
                                        if (newCurrency != null) {
                                          _convertPrice(mealId, newCurrency);
                                        }
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'USD',
                                          child: Text('USD'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'IDR',
                                          child: Text('IDR'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'SAR',
                                          child: Text('SAR'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'CNY',
                                          child: Text('CNY'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'JPY',
                                          child: Text('JPY'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'KRW',
                                          child: Text('KRW'),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Harga: ${_convertedPrices[mealId]?.toStringAsFixed(2)} ${_selectedCurrencies[mealId]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      icon: const Icon(Icons.remove),
                                      onPressed: quantity > 0
                                          ? () {
                                              setState(() {
                                                _quantities[mealId] =
                                                    (_quantities[mealId] ?? 0) -
                                                        1;
                                              });
                                            }
                                          : null,
                                    ),
                                    Text('$quantity'),
                                    IconButton(
                                      color: Colors.white,
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _quantities[mealId] =
                                              (_quantities[mealId] ?? 0) + 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _quantities.values.any((qty) => qty > 0)
                        ? _placeOrder
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Set to transparent to show gradient
                      elevation: 10,
                    ).copyWith(
                      shadowColor: WidgetStateProperty.all(Colors.black45),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0A1E4A), // Dark Blue
                            Color(0xFF1E3C72), // Medium Blue
                            Color(0xFF2A5D9D), // Light Blue
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 19.0, horizontal: 40.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Lihat Pesanan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
