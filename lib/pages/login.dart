import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/pages/resister.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/config/internal_config.dart';
import 'package:my_first_app/pages/showtrip.dart';

// controller เก็บค่าเบอร์โทรศัพท์และรหัสผ่าน
TextEditingController phoneNoCtl = TextEditingController();
TextEditingController passwordCtl = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String url = '';
  int number = 0;
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // โลโก้ + tap event
            InkWell(child: Image.asset('assets/images/11111.jpg')),

            // label เบอร์โทรศัพท์
            const Padding(
              padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
              child: Row(
                children: [
                  Text(
                    "หมายเลขโทรศัพท์",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // input เบอร์โทรศัพท์
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
              child: TextField(
                controller: phoneNoCtl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            // label รหัสผ่าน
            const Padding(
              padding: EdgeInsets.fromLTRB(25, 18, 0, 0),
              child: Row(
                children: [
                  Text(
                    "รหัสผ่าน",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // input รหัสผ่าน
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 20),
              child: TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            // ปุ่ม
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => resister(),
                  child: const Text(
                    'ลงทะเบียนใหม่',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    login(phoneNoCtl.text, passwordCtl.text);
                  },
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void resister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void login(String phone, String password) async {
    // 0817399999
    // 1111
    if (url.isEmpty) {
      log("Config ยังไม่โหลดเสร็จ");
      return;
    }

    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );

    try {
      final response = await http.post(
        Uri.parse("$API_ENDPOINT/customers/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: customerLoginPostRequestToJson(req),
      );
      log("$url");
      log("Response body: ${response.body}");

      final customerLoginPostResponse = customerLoginPostResponseFromJson(
        response.body,
      );

      if (customerLoginPostResponse.message.toLowerCase() ==
          "login successful") {
        log("Customer idx: ${customerLoginPostResponse.customer.idx}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ShowTripPage(cid: customerLoginPostResponse.customer.idx),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("เบอร์โทรศัพท์หรือรหัสผ่านไม่ถูกต้อง")),
        );
      }
    } catch (error) {
      log("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เกิดข้อผิดพลาด กรุณาลองใหม่")),
      );
    }
  }
}
