import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jeogongtong_front/constants/api.dart';
import 'package:http/http.dart' as http;

final user = FirebaseAuth.instance.currentUser;

class PointPage extends StatefulWidget {
  final int po;
  final int usi;
  const PointPage({Key? key, required this.po, required this.usi})
      : super(key: key);
  //const PointPage({super.key});
  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  Color _buttonColor = const Color(0xff131214);
  List<List<dynamic>> listEx = [
    ["Weekly Study", 200],
    ["Weekly Study", 250],
    ["Question", 100],
    ["Answer", 100],
    ["Weekly study", 300],
    ["Question", 100]
  ];
  List<String> dateEx = [
    "2024-02-20",
    "2024-02-13",
    "2024-02-11",
    "2024-02-09",
    "2024-02-06",
    "2024-02-06",
  ];

  //백엔드 연결
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final Uri uri = Uri(
      scheme: 'http',
      port: apiPort,
      host: apiHost,
      path: '/point/all/${widget.usi}',
    );
    final String? idToken = await user?.getIdToken();
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${idToken}'
    });
    try {
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Point piggy bank",
              style: TextStyle(fontSize: 18),
            ),
            leadingWidth: 30,
            leading: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _buttonColor = const Color(0xffFC9AB8);
                });
              },
              onTapUp: (_) {
                setState(() {
                  _buttonColor = const Color(0xff131214);
                });
              },
              child: Transform.translate(
                offset: const Offset(7, 0),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: SvgPicture.asset(
                    "assets/images/chevron-left.svg",
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      _buttonColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 28),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    //widget.score.toString() + " p",
                    "My point : 1100 p", //${widget.key} p",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Divider(color: Color(0xffE3E5E5), thickness: 1.0),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: listEx.length,
                itemBuilder: (context, index) {
                  final item = listEx[index];
                  final date = dateEx[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item[0],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              item[1].toString(),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(
                          color: Color(0xffE3E5E5),
                          thickness: 1.0,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
