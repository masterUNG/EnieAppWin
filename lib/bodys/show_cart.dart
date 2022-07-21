import 'package:enie/models/sqlite_model.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:enie/utillity/sqlite_helper.dart';
import 'package:enie/widgets/show_button.dart';
import 'package:enie/widgets/show_icon_button.dart';
import 'package:enie/widgets/show_progress.dart';
import 'package:enie/widgets/show_text.dart';
import 'package:flutter/material.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  var sqliteModels = <SqliteModel>[];
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    readProduceFromSQLite();
  }

  Future<void> readProduceFromSQLite() async {
    await SQLiteHelper().readAllDatabase().then((value) {
      sqliteModels = value;
      print('sqliteModels ==> $sqliteModels');

      if (sqliteModels.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveData!
            ? Column(
                children: [
                  newHead(),
                  listViewCart(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShowButton(
                        size: 120,
                        label: 'Empty Cart',
                        pressFunc: () async {
                          await SQLiteHelper()
                              .deletaAllDatabase()
                              .then((value) {
                            load = true;
                            readProduceFromSQLite();
                            setState(() {});
                          });
                        },
                      ),
                      ShowButton(
                        size: 120,
                        label: 'Order',
                        pressFunc: () {
                          processOrder();
                        },
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: ShowText(
                  label: 'Empty Cart',
                  textStyle: Myconstant().h1Style(),
                ),
              );
  }

  Container newHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade400),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ShowText(
              label: 'รายการ',
              textStyle: Myconstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              label: 'ราคา',
              textStyle: Myconstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              label: 'Delete',
              textStyle: Myconstant().h2Style(),
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewCart() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 3,
            child: ShowText(
              label: sqliteModels[index].nameProduct,
              textStyle: Myconstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(label: sqliteModels[index].price),
          ),
          Expanded(
            flex: 1,
            child: ShowIconButton(
              iconData: Icons.delete_forever_outlined,
              tapFunc: () async {
                int? idDelete = sqliteModels[index].id;
                print('idDelete ===>>> $idDelete');

                await SQLiteHelper()
                    .deleteDatabseWhereId(idDelete: idDelete!)
                    .then((value) {
                  load = true;
                  sqliteModels.clear();
                  readProduceFromSQLite();
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processOrder() async {
    var products = <String>[];
    for (var element in sqliteModels) {
      products.add(element.nameProduct);
    }
    print('products ==> $products');
  }
}
