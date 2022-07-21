import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:enie/states/page_non_login.dart';
import 'package:enie/states/page_require_login.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:enie/widgets/show_button.dart';
import 'package:enie/widgets/show_text_button.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DamoTestLogin extends StatelessWidget {
  const DamoTestLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ShowTextButton(
            label: 'Demo PageNonLogin',
            pressFunc: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PageNoneLogin(),
                  ));
            },
          ),
          ShowTextButton(
            label: 'Demo PageRequireLogin',
            pressFunc: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PageRequireLogin(),
                  ));
            },
          ),
          Container(
            margin: const EdgeInsets.all(16),
            width: 200,
            height: 200,
            child: Image.network(Myconstant.urlPromPay),
          ),
          ShowButton(
            label: 'Save PromPay',
            pressFunc: () {
              processSaveImage();
            },
          ),
        ],
      ),
    );
  }

  Future<void> processSaveImage() async {
    var response = await Dio().get(Myconstant.urlPromPay,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: 'ungpromptpay',
    );

    if (result['isSuccess']) {
      print('Save Success');
    } else {
      print('Error Save Image');
    }
  }
}
