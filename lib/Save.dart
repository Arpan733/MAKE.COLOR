import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

class Save extends StatefulWidget {
  const Save({Key? key}) : super(key: key);

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> with SingleTickerProviderStateMixin{
  List<String> singlecolorlist = [];
  List<List<String>> colorpalletlist = [];
  List<Color> cl = [];
  bool _isLoading = true;
  bool _isLoading1 = true;
  TabController? _tabController;

  Future<void> start() async {
    WidgetsFlutterBinding.ensureInitialized();
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  }

  Future<void> pri() async {
    var box = await Hive.openBox('Single-Color');
    List<String> list = await box.get('SingleColorList');

    setState(() {
      singlecolorlist = list;
      _isLoading = false;
    });
  }

  Future<void> pri1() async {
    var box = await Hive.openBox('Color-Pallet');
    List<dynamic> dynamiclist = await box.get('ColorPalletList');
    List<List<String>> list = dynamiclist.cast<List<String>>();

    setState(() {
      colorpalletlist = list;
      _isLoading1 = false;
    });
  }

  void delete(int i) async {
    var box = await Hive.openBox('Single-Color');
    singlecolorlist.removeAt(i);
    box.put('SingleColorList', singlecolorlist);
    setState(() {});
  }

  void delete1(int i) async {
    var box = await Hive.openBox('Color-Pallet');
    colorpalletlist.removeAt(i);
    box.put('ColorPalletList', colorpalletlist);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    start();
    pri();
    pri1();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(singlecolorlist);
    print(colorpalletlist);

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.034),
      height: MediaQuery.of(context).size.height - 74,
      color: Colors.grey,
      child: Column(
        children: [
          DefaultTabController(
            length: 2,
            child: TabBar(
              controller: _tabController,
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontFamily: 'Degular',
              ),
              labelStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'Degular',
              ),
              indicatorColor: Colors.black54,
              tabs: const <Tab> [
                Tab(text: 'Single Color',),
                Tab(text: 'Color Pallete',),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 145,
            color: Colors.white60,
            child: TabBarView(
              controller: _tabController,
              children: <Widget> [
                _isLoading ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ) : singlecolorlist.isEmpty ? const Center(
                  child: Text(
                    'You have not saved any color yet.',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Degular',
                    ),
                  ),
                ) : ListView.builder(
                    itemCount: singlecolorlist.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (ctx, index) {
                      return Container(
                        padding: const EdgeInsets.only(top: 20),
                        color: Color(0xFF000000 + int.parse(singlecolorlist[index], radix: 16)),
                        height: 100,
                        child: ListTile(
                          title: Text(
                            '#${singlecolorlist[index].toUpperCase()}',
                            style: const TextStyle(
                              fontFamily: 'Degular',
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              delete(index);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.black87,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    }),
                _isLoading1 ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ) : colorpalletlist.isEmpty ? const Center(
                  child: Text(
                    'You have not saved any color pallet yet.',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Degular',
                    ),
                  ),
                ) : ListView.builder(
                  itemCount: colorpalletlist.length,
                  padding: const EdgeInsets.only(top: 0),
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: ListTile(
                            title: ListView.builder(
                              itemCount: colorpalletlist[index].length,
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, i) {
                                return Container(
                                  width: (MediaQuery.of(context).size.width - 32) / colorpalletlist[index].length,
                                  color: Color(0xFF000000 + int.parse(colorpalletlist[index][i], radix: 16)),
                                  padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width / colorpalletlist[index].length - 4) / 2 - 20, bottom: 85),
                                  child: RotatedBox(
                                    quarterTurns: 3, // Rotate text 270 degrees clockwise (vertical)
                                    child: Text(
                                      '#${colorpalletlist[index][i].toUpperCase()}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Degular',
                                          fontSize: 24
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                delete1(index);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 30,
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
