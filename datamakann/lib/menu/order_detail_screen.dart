import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pesanmakan/notification_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class OrderDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  final double totalPrice;
  final String selectedCurrency;

  const OrderDetailScreen({
    Key? key,
    required this.orderDetails,
    required this.totalPrice,
    required this.selectedCurrency,
  }) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final GlobalKey _qrKey = GlobalKey();
  QRViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A1E4A), // Dark Blue
                Color(0xFF1E3C72), // Medium Blue
                Color(0xFF2A5D9D), // Light Blue
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: const Text('Detail Pesanan',
                style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 39, 64, 102), // Transparent to show gradient
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan Anda:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.orderDetails.length,
                itemBuilder: (context, index) {
                  final item = widget.orderDetails[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: const Color.fromARGB(255, 58, 90, 130),
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
                                  item['thumbnail'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Jumlah: ${item['quantity']}',
                                      style: const TextStyle(fontSize: 16, color: Colors.white,),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Harga: ${item['price'].toStringAsFixed(2)} ${widget.selectedCurrency}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
            const SizedBox(height: 16),
            Text(
              'Total Harga: ${widget.totalPrice.toStringAsFixed(2)} ${widget.selectedCurrency}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 16),
            // "Bayar Sekarang" Button with Gradient Blue to Black
            Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0A1E4A), // Dark Blue
                    Color(0xFF000000), // Black
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 0, 29, 176), // Transparent for gradient
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                child: const Text('Bayar Sekarang'),
              ),
            ),
            const SizedBox(height: 16),
            // QR Scan Button with Gradient Blue to Black
            Center(
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0A1E4A), // Dark Blue
                      Color(0xFF000000), // Black
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: ElevatedButton(
                  onPressed: _startQrScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 0, 29, 176), // Transparent for gradient
                    elevation: 3,
                    minimumSize: const Size(60, 60),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembayaran'),
        content: const Text('Pesanan Anda berhasil diproses. Terima kasih!'),
        actions: [
          TextButton(
            onPressed: () {
              NotificationService.showNotification(
                id: 1,
                title: 'Pesanan Diproses',
                body: 'Pesanan Anda telah berhasil diproses. Terima kasih!',
              );
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startQrScan() {
    if (Platform.isAndroid || Platform.isIOS) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Pindai Kode QR',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xFF1E3C72),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Simulasi QR Scan'),
          content: TextField(
            onSubmitted: (value) {
              Navigator.of(context).pop();
              _processSimulatedQrCode(value);
            },
            decoration: const InputDecoration(
              hintText: 'Masukkan teks QR manual',
            ),
          ),
        ),
      );
    }
  }

  void _processSimulatedQrCode(String qrCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Terdeteksi'),
        content: Text('Kode QR yang dimasukkan: $qrCode'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    _controller!.scannedDataStream.listen((scanData) {
      _controller!.pauseCamera();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('QR Terdeteksi'),
          content: Text('Kode QR yang dipindai: ${scanData.code}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
