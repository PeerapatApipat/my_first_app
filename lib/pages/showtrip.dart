import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/config/internal_config.dart';
import 'package:my_first_app/model/response/customer_idx_get_res.dart';
import 'package:my_first_app/model/response/trip_get_res.dart';
import 'package:my_first_app/pages/profile.dart';
import 'package:my_first_app/pages/trip.dart';

class ShowTripPage extends StatefulWidget {
  final int cid;
  const ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];
  String selectedRegion = 'ทั้งหมด';
  late Future<void> loadData;
  late CustomerIdxGetResponse customerIdxGetResponse;

  final List<String> regions = [
    'ทั้งหมด',
    'ภาคเหนือ',
    'ภาคใต้',
    'ภาคกลาง',
    'ภาคอีสาน',
  ];

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ปลายทาง",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // ปุ่ม filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: FilledButton(
                          onPressed: () => getTrips(),
                          child: const Text('ทั้งหมด'),
                        ),
                      ),
                      ...regions.skip(1).map((region) {
                        final isSelected = region == selectedRegion;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              region,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedRegion = region;
                              });
                              // TODO: filter trips ตาม region
                            },
                            selectedColor: Colors.deepPurple,
                            backgroundColor: Colors.deepPurple.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: tripGetResponses.isEmpty
                      ? const Center(child: Text("ไม่มีข้อมูลทริป"))
                      : ListView.builder(
                          itemCount: tripGetResponses.length,
                          itemBuilder: (context, index) {
                            final trip = tripGetResponses[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        trip.coverimage,
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 100,
                                                height: 80,
                                                color: Colors.grey.shade300,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Cannot load image',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black54,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            },
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trip.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text('ประเทศ ${trip.country}'),
                                          Text('ระยะเวลา ${trip.duration} วัน'),
                                          Text('ราคา ${trip.price} บาท'),
                                          const SizedBox(height: 6),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: FilledButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TripPage(idx: trip.idx),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'รายละเอียดเพิ่มเติม',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> getTrips() async {
    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.toString());
  }

 Future<void> loadDataAsync() async {
  var config = await Configuration.getConfig();
  url = config['apiEndpoint']; 
  var res = await http.get(Uri.parse('$url/customers/${widget.cid}'));
  log("CID: ${widget.cid}");  
  log(res.body);
  customerIdxGetResponse = customerIdxGetResponseFromJson(res.body);
  await getTrips();
}
}
