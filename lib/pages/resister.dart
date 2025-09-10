import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,

        child: Column(
          children: [
            //GestureDetector
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Text(
                    "ชื่อ-นามสกุล",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
                  child: Text(
                    "หมายเลขโทรศัพท์",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 20),
              child: TextField(
                controller: null,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
                  child: Text(
                    "อีเมล",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
                  child: Text(
                    "รหัสผ่าน",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 20),
              child: TextField(
                controller: null,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
                child: Text(
                  "ยืนยันรหัสผ่าน",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
            ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 20),
              child: TextField(
                controller: null,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 TextButton(
                  onPressed: () {},
                  child: const Text(
                    'หากมีบัญชีอยู่แล้ว',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));

  }
}
