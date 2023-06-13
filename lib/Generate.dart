// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'dart:math';

class Generate extends StatefulWidget {
  Generate({Key? key}) : super(key: key);

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  int _total = 7;
  Map<Color, List<int>> _hexlist = {};

  void makelist(int n) {
    for (var i = 0; i < n; i++) {
      if (_hexlist.length < _total) {
        _hexlist[random()] = [i, 0];
      }
    }
  }

  void makelist1(int n) {
    Map<Color, List<int>> updatedhexlist = {};

    for(var i = 0; i < n; i++) {
      if(_hexlist[_hexlist.keys.elementAt(i)]?[1] == 0){
        updatedhexlist[random()] = [i, 0];
      } else {
        updatedhexlist[_hexlist.keys.elementAt(i)] = [i, 1];
      }
    }

    _hexlist = updatedhexlist;
  }

  void add(int i) {
    if (_total >= 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can add up to 7 colors per pallete.',
            style: TextStyle(
              fontFamily: 'Degular',
              fontSize: 18,
            ),
          ),
        ),
      );
    } else {
      print("hello");
      if (i == _hexlist.length - 1) {
        _hexlist[random()] = [i + 1, 0];
      } else {
        Map<Color, List<int>> updatedhexlist = {};
        int c = 0;
        i++;

        _hexlist.forEach((key, value) {
          if (key == _hexlist.keys.elementAt(i)) {
            updatedhexlist[random()] = [value[0], 0];
            c = 1;
          }

          if (c == 0) {
            updatedhexlist[key] = value;
          } else {
            updatedhexlist[key] = [value[0] + 1, value[1]];
          }
        });

        _hexlist = updatedhexlist;
      }

      _total++;
    }
  }

  void remove(int i) {
    if (_total > 4) {
      Map<Color, List<int>> updatedhexlist = {};
      int j = 0;
      _hexlist.forEach((key, value) {
        if (i > j) {
          updatedhexlist[key] = value;
        }

        if (i < j) {
          updatedhexlist[key] = [value[0] - 1, value[1]];
        }

        j++;
      });

      _hexlist = updatedhexlist;
      _total--;
    } else {
      print(1);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Not be less than 4 colors per pallete.',
            style: TextStyle(
              fontFamily: 'Degular',
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }

  Color random() {
    int red = Random().nextInt(256);
    int green = Random().nextInt(256);
    int blue = Random().nextInt(256);

    Color rgbColor = Color.fromRGBO(red, green, blue, 1);
    String hexColor = rgbColor.value.toRadixString(16).substring(2).toUpperCase();

    return Color(int.parse(hexColor, radix: 16) + 0xFF000000);
  }

  void start() async {
    WidgetsFlutterBinding.ensureInitialized();
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  }

  @override
  void initState() {
    super.initState();
    start();
    makelist(_total);
  }

  @override
  Widget build(BuildContext context) {
    print(_hexlist);
    print(_total);

    return Container(
      height: MediaQuery.of(context).size.height - 74,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 150,
            child: ListView.builder(
              itemCount: _hexlist.length,
              itemBuilder: (ctx, index) {
                return Container(
                  color: _hexlist.keys.elementAt(index),
                  height: 570 / _hexlist.length,
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.only(
                          top: 570 / (_hexlist.length * 2) - 24),
                      child: IconButton(
                          onPressed: () {
                            print(_hexlist[_hexlist.keys.elementAt(index)]);

                            setState(() {
                              var a = _hexlist[_hexlist.keys.elementAt(index)]?[1];
                              a == 0? a = 1: a = 0;
                              _hexlist[_hexlist.keys.elementAt(index)]?[1] = a;
                            });

                            print(_hexlist[_hexlist.keys.elementAt(index)]);
                          },
                          icon: Icon(
                            _hexlist[_hexlist.keys.elementAt(index)]?[1] == 1
                                ? Icons.lock_outline_rounded
                                : Icons.lock_open_rounded,
                            color: Colors.black87,
                          )
                      ),
                    ),
                    title: Container(
                      padding: EdgeInsets.only(
                          top: 570 / (_hexlist.length * 2) - 24),
                      child: Text(
                        '#${_hexlist.keys.elementAt(index).toString().substring(10, 16)}'
                            .toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Degular',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    trailing: Container(
                      width: 100,
                      padding: EdgeInsets.only(
                          top: 570 / (_hexlist.length * 2) - 24),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  add(index);
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black87,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  remove(index);
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.black87,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  List<String> p = [];
                  _hexlist.forEach((key, value) {
                    p.add(key.toString().substring(10, 16));
                  });

                  var box = await Hive.openBox('ColorPallet');
                  List<dynamic> dynamiclist = await box.get('ColorPalletList');
                  List<List<String>> colorpalletlist =
                      dynamiclist.cast<List<String>>();

                  if (colorpalletlist == null || colorpalletlist.isEmpty) {
                    colorpalletlist = [p];
                  } else {
                    colorpalletlist.add(p);
                  }

                  print(p);
                  print(colorpalletlist);

                  box.put('ColorPalletList', colorpalletlist);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
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
                  setState(() {
                    makelist1(_total);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
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
        ],
      ),
    );
  }
}
