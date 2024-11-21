import 'package:flutter/material.dart';

class PesanDanKesanScreen extends StatefulWidget {
  const PesanDanKesanScreen({Key? key}) : super(key: key);

  @override
  _PesanDanKesanScreenState createState() => _PesanDanKesanScreenState();
}

class _PesanDanKesanScreenState extends State<PesanDanKesanScreen> {
  // List untuk menyimpan pesan dan kesan dengan data yang sudah ada
  List<Map<String, String>> pesanDanKesan = [
    {
      'type': 'Pesan',
      'content':
          'Tugasnya sepertinya kurang banyak, saya dan teman-teman masih bisa bermain dengan santai, jadi mungkin bisa ditambah lagi tugasnya'
    },
    {
      'type': 'Kesan',
      'content':
          'Pemrogaman mobile ini satu-satunya mata kuliah yang menyenangkan dan santai sekali, bisa membuat tubuh vit dan sehat, apalagi yang mengajar Bapak Bagus'
    }
  ];

  // Controller untuk mengedit pesan/ kesan
  final TextEditingController _controller = TextEditingController();

  // Fungsi untuk mengedit pesan atau kesan
  void _editPesan(int index) {
    _controller.text = pesanDanKesan[index]['content'] ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${pesanDanKesan[index]['type']}'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Isi ${pesanDanKesan[index]['type']}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  pesanDanKesan[index]['content'] = _controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus pesan atau kesan
  void _deletePesan(int index) {
    setState(() {
      pesanDanKesan.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: pesanDanKesan.length,
        itemBuilder: (context, index) {
          final item = pesanDanKesan[index];
          return Dismissible(
            key: Key(item['content'] ?? ''),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deletePesan(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              color: const Color.fromARGB(255, 58, 90, 130),
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(item['type'] ?? '',style: const TextStyle(color: Colors.white),),
                subtitle: Text(item['content'] ?? '',style: const TextStyle(color: Colors.white),),
                trailing: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editPesan(index), // Edit pesan atau kesan
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
