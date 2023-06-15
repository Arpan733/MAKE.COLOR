// ignore_for_file: file_names, use_build_context_synchronously

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
  final TextEditingController _rcontroller =
      TextEditingController(text: Random().nextInt(256).toString());
  final TextEditingController _gcontroller =
      TextEditingController(text: Random().nextInt(256).toString());
  final TextEditingController _bcontroller =
      TextEditingController(text: Random().nextInt(256).toString());
  Color _ic = Color.fromRGBO(
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);

  bool isdark = true;

  Color borderandtext = Colors.black;
  Color shade = Colors.white;

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
    String hexColor =
        rgbColor.value.toRadixString(16).substring(2).toUpperCase();

    _hexcontroller.text = hexColor;
  }

  void random() {
    setState(() {
      _rcontroller.text = Random().nextInt(256).toString();
      _gcontroller.text = Random().nextInt(256).toString();
      _bcontroller.text = Random().nextInt(256).toString();

      rgbtohex(_rcontroller.text, _gcontroller.text, _bcontroller.text);
      _ic = Color.fromRGBO(int.parse(_rcontroller.text),
          int.parse(_gcontroller.text), int.parse(_bcontroller.text), 1);
    });
  }

  void start() async {
    WidgetsFlutterBinding.ensureInitialized();
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  }

  void isColorDark() {
    Color color = Color(
        int.parse(_hexcontroller.text, radix: 16) + 0xFF000000);
    double luminance =
        (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue) / 255;

    setState(() {
      if (luminance < 0.75 && luminance != 0) {
        borderandtext = Colors.black87;
        shade = Colors.white54;
      } else {
        borderandtext = Colors.white;
        shade = Colors.black54;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    start();
    rgbtohex(_rcontroller.text, _gcontroller.text, _bcontroller.text);
    isColorDark();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height - 74),
      width: MediaQuery.of(context).size.width,
      color: _ic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.79,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLefts,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, left: 5),
                  child: Text(
                    'MAKE.COLOR',
                    style: TextStyle(
                      fontFamily: 'Bungee',
                      fontSize: 34,
                      color: borderandtext,
                      shadows: [Shadow(color: shade, blurRadius: 5)],
                    ),
                  ),
                ),
                SizedBox(
                  height: 536,
                  child: Center(
                    child: Container(
                      height: 189,
                      width: MediaQuery.of(context).size.width - 60,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderandtext, width: 5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Hex',
                              labelStyle: TextStyle(
                                fontFamily: 'Bungee',
                                fontSize: 20,
                                color: borderandtext,
                              ),
                              prefixText: '#',
                              prefixStyle: TextStyle(
                                fontFamily: 'Bungee',
                                fontSize: 20,
                                color: borderandtext,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: borderandtext,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: borderandtext,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: borderandtext,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            controller: _hexcontroller,
                            cursorColor: borderandtext,
                            style: TextStyle(
                              fontFamily: 'Bungee',
                              fontSize: 20,
                              color: borderandtext,
                            ),
                            onChanged: (value) {
                              isColorDark();

                              if (_hexcontroller.text.length > 6) {
                                _hexcontroller.text =
                                    _hexcontroller.text.substring(0, 6);
                              }

                              if (!'0123456789ABCDEFabcdef'.contains(_hexcontroller
                                  .text
                                  .substring(_hexcontroller.text.length - 1))) {
                                _hexcontroller.text = _hexcontroller.text
                                    .substring(0, _hexcontroller.text.length - 1);
                              }

                              if (value.isNotEmpty) {
                                if (value.length == 6) {
                                  try {
                                    setState(() {
                                      _ic = Color(
                                          int.parse(value, radix: 16) + 0xFF000000);
                                      hextorgb(value);
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                                if (value.length == 3) {
                                  try {
                                    setState(() {
                                      _ic = Color(int.parse(value * 2, radix: 16) +
                                          0xFF000000);
                                      hextorgb(value * 2);
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                                if (value.length == 2) {
                                  try {
                                    setState(() {
                                      _ic = Color(int.parse(value * 3, radix: 16) +
                                          0xFF000000);
                                      hextorgb(value * 3);
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              }

                              _hexcontroller.selection = TextSelection.collapsed(
                                  offset: _hexcontroller.text.length);
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
                                Icon(
                                  Icons.format_color_fill,
                                  color: borderandtext,
                                ),
                                SizedBox(
                                  width: 70,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'R',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Bungee',
                                        fontSize: 20,
                                        color: borderandtext,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    controller: _rcontroller,
                                    cursorColor: borderandtext,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontFamily: 'Bungee',
                                      fontSize: 20,
                                      color: borderandtext,
                                    ),
                                    onChanged: (value) {
                                      isColorDark();

                                      setState(() {
                                        if (int.parse(_rcontroller.text) > 255) {
                                          _rcontroller.text = _rcontroller.text
                                              .substring(
                                              0, _rcontroller.text.length - 1);
                                          _rcontroller.selection =
                                              TextSelection.collapsed(
                                                  offset: _rcontroller.text.length);
                                        }

                                        _ic = Color.fromRGBO(
                                            int.parse(value),
                                            int.parse(_gcontroller.text),
                                            int.parse(_bcontroller.text),
                                            1);
                                        rgbtohex(value, _gcontroller.text,
                                            _bcontroller.text);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'G',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Bungee',
                                        fontSize: 20,
                                        color: borderandtext,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    controller: _gcontroller,
                                    cursorColor: borderandtext,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontFamily: 'Bungee',
                                      fontSize: 20,
                                      color: borderandtext,
                                    ),
                                    onChanged: (value) {
                                      isColorDark();

                                      setState(() {
                                        if (int.parse(_rcontroller.text) > 255) {
                                          _rcontroller.text = _rcontroller.text
                                              .substring(
                                              0, _rcontroller.text.length - 1);
                                          _rcontroller.selection =
                                              TextSelection.collapsed(
                                                  offset: _rcontroller.text.length);
                                        }

                                        _ic = Color.fromRGBO(
                                            int.parse(_rcontroller.text),
                                            int.parse(value),
                                            int.parse(_bcontroller.text),
                                            1);
                                        rgbtohex(_rcontroller.text, value,
                                            _bcontroller.text);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'B',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Bungee',
                                        fontSize: 20,
                                        color: borderandtext,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: borderandtext,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    controller: _bcontroller,
                                    cursorColor: borderandtext,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontFamily: 'Bungee',
                                      fontSize: 20,
                                      color: borderandtext,
                                    ),
                                    onChanged: (value) {
                                      isColorDark();

                                      setState(() {
                                        if (int.parse(_rcontroller.text) > 255) {
                                          _rcontroller.text = _rcontroller.text
                                              .substring(
                                              0, _rcontroller.text.length - 1);
                                          _rcontroller.selection =
                                              TextSelection.collapsed(
                                                  offset: _rcontroller.text.length);
                                        }

                                        _ic = Color.fromRGBO(
                                            int.parse(_rcontroller.text),
                                            int.parse(_gcontroller.text),
                                            int.parse(value),
                                            1);
                                        rgbtohex(_rcontroller.text, _gcontroller.text,
                                            value);
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
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 25.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var box = await Hive.openBox('Single-Color');
                    List<String>? singlecolorlist = box.get('SingleColorList');

                    if (singlecolorlist == null || singlecolorlist.isEmpty) {
                      singlecolorlist = [_hexcontroller.text];
                    } else {
                      int i = 0;

                      for (var element in singlecolorlist) {
                        if (element == _hexcontroller.text) {
                          i = 1;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'This color is already saved.',
                                style: TextStyle(
                                  fontFamily: 'Degular',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      if (i == 0) {
                        singlecolorlist.add(_hexcontroller.text);
                      }
                    }

                    print(_hexcontroller.text);
                    print(singlecolorlist);

                    box.put('SingleColorList', singlecolorlist);
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(color: borderandtext, width: 3),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(_ic),
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(150, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: borderandtext,
                      fontFamily: 'Degular',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isColorDark();
                      random();
                    });
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(color: borderandtext, width: 3),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(_ic),
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(150, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: Text(
                    'Random',
                    style: TextStyle(
                      color: borderandtext,
                      fontFamily: 'Degular',
                      fontSize: 22,
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
