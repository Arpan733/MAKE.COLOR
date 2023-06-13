// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _hexcontroller = TextEditingController();
  final TextEditingController _rcontroller = TextEditingController(text: Random().nextInt(256).toString());
  final TextEditingController _gcontroller = TextEditingController(text: Random().nextInt(256).toString());
  final TextEditingController _bcontroller = TextEditingController(text: Random().nextInt(256).toString());
  Color _ic = Color.fromRGBO(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);

  void hextorgb(String hex) {
    _rcontroller.text = int.parse(hex.substring(0, 2), radix: 16).toString();
    _gcontroller.text = int.parse(hex.substring(2, 4), radix: 16).toString();
    _bcontroller.text = int.parse(hex.substring(4, 6), radix: 16).toString();
  }

  void rgbtohex(String r, String g, String b) {
    int red = int.parse(r);
    int green = int.parse(g);
    int blue = int.parse(b);

    Color rgbColor = Color.fromRGBO(red, green, blue, 1);
    String hexColor = rgbColor.value.toRadixString(16).substring(2).toUpperCase();

    _hexcontroller.text = hexColor;
  }

  void random(){
    setState(() {
      _rcontroller.text = Random().nextInt(256).toString();
      _gcontroller.text = Random().nextInt(256).toString();
      _bcontroller.text = Random().nextInt(256).toString();

      rgbtohex(_rcontroller.text, _gcontroller.text, _bcontroller.text);
    });
  }

  void start()  async {
    WidgetsFlutterBinding.ensureInitialized();
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  }

  @override
  Widget build(BuildContext context) {
    _ic = Color.fromRGBO(int.parse(_rcontroller.text), int.parse(_gcontroller.text), int.parse(_bcontroller.text), 1);
    rgbtohex(_rcontroller.text, _gcontroller.text, _bcontroller.text);

    start();

    return Container(
      height: MediaQuery.of(context).size.height - 74,
      width: MediaQuery.of(context).size.width,
      color: _ic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: const Text(
              'MAKE.COLOR',
              style: TextStyle(
                fontFamily: 'Bungee',
                fontSize: 34,
                shadows: [
                  Shadow(
                    color: Colors.white54,
                    blurRadius: 5
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 230,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height - 570,
                width: MediaQuery.of(context).size.width - 60,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 5
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Hex',
                        labelStyle: const TextStyle(
                          fontFamily: 'Bungee',
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                        prefixText: '#',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      controller: _hexcontroller,
                      cursorColor: Colors.black54,
                      style: const TextStyle(
                        fontFamily: 'Bungee',
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                      onChanged: (value) {
                        _hexcontroller.selection = TextSelection.collapsed(offset: _hexcontroller.text.length);

                        if(value.isNotEmpty) {
                          if(value.length == 6){
                            try {
                              setState(() {
                                _ic = Color(int.parse(value, radix: 16) + 0xFF000000);
                                hextorgb(value);
                              });
                            } catch (e) {
                              print(e);
                            }
                          }
                          if(value.length == 3) {
                            try {
                              setState(() {
                                _ic = Color(int.parse(value * 2, radix: 16) + 0xFF000000);
                                hextorgb(value * 2);
                              });
                            } catch (e) {
                              print(e);
                            }
                          }
                          if(value.length == 2) {
                            try {
                              setState(() {
                                _ic = Color(int.parse(value * 3, radix: 16) + 0xFF000000);
                                hextorgb(value * 3);
                              });
                            } catch (e) {
                              print(e);
                            }
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.format_color_fill,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'R',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Bungee',
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              controller: _rcontroller,
                              cursorColor: Colors.black54,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: 'Bungee',
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _ic = Color.fromRGBO(int.parse(value), int.parse(_gcontroller.text), int.parse(_bcontroller.text), 1);
                                  rgbtohex(value, _gcontroller.text, _bcontroller.text);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'G',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Bungee',
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              controller: _gcontroller,
                              cursorColor: Colors.black54,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: 'Bungee',
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _ic = Color.fromRGBO(int.parse(_rcontroller.text), int.parse(value), int.parse(_bcontroller.text), 1);
                                  rgbtohex(_rcontroller.text, value, _bcontroller.text);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'B',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Bungee',
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              controller: _bcontroller,
                              cursorColor: Colors.black54,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: 'Bungee',
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _ic = Color.fromRGBO(int.parse(_rcontroller.text), int.parse(_gcontroller.text), int.parse(value), 1);
                                  rgbtohex(_rcontroller.text, _gcontroller.text, value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var box = await Hive.openBox('Single-Color');
                    List<String>? singlecolorlist = box.get('SingleColorList');

                    if(singlecolorlist == null || singlecolorlist.isEmpty) {
                      singlecolorlist = [_hexcontroller.text];
                    } else {
                      singlecolorlist.add(_hexcontroller.text);
                    }

                    print(_hexcontroller.text);
                    print(singlecolorlist);

                    box.put('SingleColorList', singlecolorlist);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ic,
                    fixedSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Degular',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    random();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ic,
                    fixedSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Random',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Degular',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
