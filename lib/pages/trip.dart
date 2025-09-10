import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_first_app/model/response/trip_idx_get_res.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class TripPage extends StatefulWidget {
  final int idx;
  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late TripIdxGetResponse tripIdxGetResponse;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียดทริป")),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อทริป
                Text(
                  tripIdxGetResponse.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // ประเทศ
                Text(
                  "ประเทศ ${tripIdxGetResponse.country}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 12),

                // รูปภาพ
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    tripIdxGetResponse.coverimage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image,
                            size: 40, color: Colors.black45),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ราคา + ประเทศ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ราคา ${tripIdxGetResponse.price} บาท",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tripIdxGetResponse.country,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // รายละเอียด
                Text(
                  tripIdxGetResponse.detail,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),

                const SizedBox(height: 20),

                // ปุ่ม
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: action เช่นไปหน้า booking
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "จองเลย!!!",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
