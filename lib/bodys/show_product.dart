// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:enie/models/product_model.dart';
import 'package:enie/models/sqlite_model.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:enie/utillity/my_dialog.dart';
import 'package:enie/utillity/sqlite_helper.dart';
import 'package:enie/widgets/show_form.dart';
import 'package:enie/widgets/show_progress.dart';
import 'package:enie/widgets/show_text.dart';

class ShowProduct extends StatefulWidget {
  const ShowProduct({Key? key}) : super(key: key);

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  bool load = true;
  var productModels = <ProductModel>[];
  var searchProductModels = <ProductModel>[];
  final debouncher = Debouncer(milliSccond: 500);

  @override
  void initState() {
    super.initState();
    readAllProduct();
  }

  Future<void> readAllProduct() async {
    String path = 'https://www.androidthai.in.th/flutter/getAllFood.php';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        ProductModel productModel = ProductModel.fromMap(element);
        productModels.add(productModel);
      }
      searchProductModels.addAll(productModels);
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60),
                child: listViewProduct(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowForm(
                    label: 'Search',
                    iconData: Icons.search,
                    changeFunc: (String string) {
                      debouncher.run(() {
                        setState(() {
                          searchProductModels = productModels
                              .where(
                                (element) =>
                                    element.nameFood.toLowerCase().contains(
                                          string.toLowerCase(),
                                        ),
                              )
                              .toList();
                        });
                      });
                    },
                  ),
                ],
              ),
            ],
          );
  }

  Widget listViewProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: searchProductModels.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          MyDialog(context: context).normalDialog(
              pressFunc: () async {
                SqliteModel sqliteModel = SqliteModel(
                    nameProduct: searchProductModels[index].nameFood,
                    price: searchProductModels[index].price);
                await SQLiteHelper()
                    .insetrDatabase(sqliteModel: sqliteModel)
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              label: 'ใส่ตระกล้า',
              title: searchProductModels[index].nameFood,
              subTitle: 'คุณต้องการ เก็บใส ตระกล้า');
        },
        child: Card(
          child: Row(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://www.androidthai.in.th/flutter${searchProductModels[index].image}'),
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ShowText(
                          label: searchProductModels[index].nameFood,
                          textStyle: Myconstant().h2Style(),
                        ),
                        ShowText(
                          label: searchProductModels[index].price,
                          textStyle: Myconstant().h1Style(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliSccond;
  Timer? timer;
  VoidCallback? voidCallback;

  Debouncer({
    required this.milliSccond,
  });

  run(VoidCallback callback) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(microseconds: milliSccond), callback);
  }
}
