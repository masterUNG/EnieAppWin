import 'package:enie/utillity/my_constant.dart';
import 'package:enie/widgets/show_image.dart';
import 'package:enie/widgets/show_text.dart';
import 'package:enie/widgets/show_text_button.dart';
import 'package:flutter/material.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  Future<void> promotionDialog({
    required String title,
    required String urlPath,
    required Function() pressFunc,
    String? label,
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Stack(
          children: [
            Image.network(urlPath),
            Positioned(
              left: 16,
              top: 16,
              child: ShowText(
                label: title,
                textStyle: Myconstant().h2WhiteStyle(),
              ),
            ),
          ],
        ),
        actions: [
          ShowTextButton(label: label ?? 'Keep', pressFunc: pressFunc),
          ShowTextButton(
              label: 'Cancel',
              pressFunc: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  Future<void> normalDialog({
    required String title,
    required String subTitle,
    String? label,
    Function()? pressFunc,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: const SizedBox(
            width: 80,
            child: ShowImage(),
          ),
          title: ShowText(
            label: title,
            textStyle: Myconstant().h2Style(),
          ),
          subtitle: ShowText(label: subTitle),
        ),
        actions: [
          (label != null) && (pressFunc != null)
              ? ShowTextButton(label: label, pressFunc: pressFunc)
              : const SizedBox(),
          ShowTextButton(
            label: label == null ? 'OK' : 'Cancel',
            pressFunc: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> SuccessDialog(
      {required String title, required String subTitle}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: SizedBox(
            width: 80,
            child: ShowImage(
              path: 'images/success.png',
            ),
          ),
          title: ShowText(
            label: title,
            textStyle: Myconstant().h2Style(),
          ),
          subtitle: ShowText(label: subTitle),
        ),
        actions: [
          ShowTextButton(
            label: 'ok',
            pressFunc: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> readAccetpDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: AlertDialog(
          title: ListTile(
            title: ShowText(
              label: 'ข้อกำหนด',
              textStyle: Myconstant().h2Style(),
            ),
            subtitle: ShowText(
                label:
                    'ข้อกำหนดและเงื่อนไขในการใช้งาน LINE ข้อกำหนดและเงื่อนไขในการใช้งาน LINE ฉบับนี้ ("ข้อกำหนดและเงื่อนไขฯ") ได้ระบุถึงข้อกำหนดและเงื่อนไขในการใช้งานผลิตภัณฑ์และบริการใดๆ (เรียกรวมกันว่า “บริการฯ”) ของ ไลน์ คอร์ปอเรชั่น ("LINE") แก่ผู้ใช้บริการ (โดยแต่ละรายเรียกว่า "ผู้ใช้" หรือ “ผู้ใช้รายต่างๆ” ขึ้นอยู่กับเนื้อหา 1.คำนิยามคำและข้อความดังต่อไปนี้ให้มีความหมายตามที่ได้กำหนดไว้ด้านล่างเมื่อมีการใช้ในข้อกำหนดและเงื่อนไขฯ ฉบับนี้ 1.1."เนื้อหา" หมายถึง ข้อมูลต่างๆ เช่น ข้อความ เสียง เพลง รูปภาพ วิดีโอ ซอฟต์แวร์ โปรแกรม รหัสคอมพิวเตอร์ และข้อมูลอื่นๆ 1.2."เนื้อหาหลัก" หมายถึง เนื้อหาที่สามารถเข้าถึงได้ผ่านทางบริการฯ 1.3."เนื้อหาจากผู้ใช้" หมายถึง เนื้อหาที่ผู้ใช้ได้ส่ง ส่งผ่าน หรือ อัพโหลดบนระบบการให้บริการฯ 1.4."เหรียญ" หมายถึง ตราสารการชำระหนี้แบบเติมเงินหรือสิ่งอื่นใดที่มีความคล้ายคลึงกัน ซึ่งผู้ใช้สามารถใช้ตราสารดังกล่าวแลกเปลี่ยนกับเนื้อหาและบริการต่างๆ โดยเสียค่าตอบแทนซึ่ง LINE เป็นผู้ให้บริการ 1.5."ข้อกำหนดและเงื่อนไขฯ เพิ่มเติม" หมายถึง ข้อกำหนดและเงื่อนไขอื่นใดซึ่งแยกต่างหากจากข้อกำหนดและเงื่อนไขฯ ฉบับนี้ และเกี่ยวข้องกับบริการฯ ซึ่งเผยแพร่หรืออัพโหลดโดย LINE ภายใต้ชื่อ "ข้อตกลง" "แนวทางปฏิบัติ" "นโยบาย" หรือภายใต้ชื่ออื่นๆ ที่มีความหมายคล้ายคลึงกัน 2.การตกลงยอมรับข้อกำหนดและเงื่อนไขฯ ฉบับนี้ 2.1.ผู้ใช้ทุกรายจะต้องใช้บริการฯ ตามข้อกำหนดที่ระบุไว้ในข้อกำหนดและเงื่อนไขฯ ฉบับนี้ โดยผู้ใช้จะไม่สามารถใช้บริการฯ ได้เว้นเสียแต่ผู้ใช้ได้ตกลงยอมรับข้อกำหนดและเงื่อนไขฯ ฉบับนี้แล้ว 2.2.ผู้ใช้ซึ่งเป็นผู้เยาว์จะสามารถใช้บริการฯ ได้ก็ต่อเมื่อได้รับความยินยอมล่วงหน้าจากบิดามารดาหรือผู้แทนโดยชอบกฎหมายเท่านั้น นอกจากนี้ หากผู้ใช้ดังกล่าวใช้บริการฯ ในนามหรือเพื่อวัตถุประสงค์ขององค์กรธุรกิจใด ให้ถือว่าองค์กรธุรกิจดังกล่าวได้ตกลงยอมรับข้อกำหนดและเงื่อนไขฯ ฉบับนี้แล้วล่วงหน้า 2.3.หากมีข้อกำหนดและเงื่อนไขฯ เพิ่มเติมใดๆ ซึ่งเกี่ยวข้องกับการให้บริการฯ ผู้ใช้จะต้องปฏิบัติตามข้อกำหนดและเงื่อนไขฯ เพิ่มเติมดังกล่าวเช่นเดียวกับข้อกำหนดและเงื่อนไขฯ ในการใช้งานฉบับนี้ .การแก้ไขข้อกำหนดและเงื่อนไขฯ ฉบับนี้ LINE อาจเปลี่ยนแปลงแก้ไขข้อกำหนดและเงื่อนไขฯ ฉบับนี้ได้ตลอดเวลาตามที่ LINE เห็นสมควรซึ่งจะอยู่ภายใต้ขอบวัตถุประสงค์ของข้อกำหนดและเงื่อนไขฯ ฉบับนี้ ในกรณีดังกล่าว LINE จะแจ้งเนื้อหาของข้อกำหนดฉบับแก้ไขรวมถึงวันที่มีผลบังคับใช้บนเว็บไซต์ของ LINE หรืออาจแจ้งให้ผู้ใช้ทราบด้วยวิธีการอื่นใดตามที่ LINE กำหนด ทั้งนี้ ข้อกำหนดและเงื่อนไขฉบับแก้ไขจะมีผลบังคับใช้ตามวันที่กำหนดต่อไป 4.บัญชี 4.1.เมื่อใช้บริการฯ ผู้ใช้อาจมีความจำเป็นต้องลงทะเบียนการใช้บริการฯ ด้วยข้อมูลบางประการ ทั้งนี้ ผู้ใช้ต้องให้ข้อมูลที่เป็นความจริง ถูกต้อง ครบถ้วนและมีหน้าที่ต้องปรับปรุงและแก้ไขข้อมูลดังกล่าวให้เป็นปัจจุบันอยู่เสมอ 4.2.ในกรณีที่ผู้ใช้ลงทะเบียนข้อมูลการยืนยันตัวตนใดๆ (Authentication information) เมื่อใช้บริการฯ ผู้ใช้ต้องใช้ความระมัดระวังในการจัดการข้อมูลดังกล่าวด้วยความรับผิดชอบของตน เพื่อให้เป็นที่เน่ใจว่าข้อมูลดังกล่าวจะไม่ถูกนำไปใช้ในลักษณะที่ไม่ชอบด้วยกฎหมาย ทั้งนี้ LINE อาจถือว่ากิจกรรมใดๆ ซึ่งดำเนินการโดยการใช้ข้อมูลการรับรองตัวตนดังกล่าว เสมือนเป็นกิจกรรมที่ผู้เป็นเจ้าของข้อมูลได้ดำเนินการด้วยตนเองทั้งสิ้น 4.3.ผู้ใช้ซึ่งลงทะเบียนใช้บริการฯ สามารถลบบัญชีของตนและยกเลิกการใช้บริการฯ ได้ไม่ว่าในเวลาใด 4.4.LINE ขอสงวนสิทธิในการลบบัญชีใดๆ ซึ่งไม่มีการเปิดใช้งานเป็นเวลากว่า หนึ่ง (1) ปี หรือนานกว่านับแต่วันที่มีการเปิดใช้งานบัญชีดังกล่าวครั้งล่าสุด ทั้งนี้ โดยไม่ต้องบอกกล่าวล่วงหน้าใดๆ แก่ผู้ใช้บัญชีดังกล่าว 4.5.สิทธิใดๆ ของผู้ใช้บริการอาจสิ้นสุดลงเมื่อบัญชีของผู้ใช้ดังกล่าวถูกลบไม่ว่าด้วยเหตุผลประการใดๆ ทั้งนี้ บัญชีการใช้บริการฯ จะไม่สามารถกู้คืนได้ถึงแม้ว่าผู้ใช้บริการฯ จะลบบัญชีของตนโดยไม่ได้ตั้งใจก็ตาม 4.6.บัญชีแต่ละบัญชีในการใช้บริการฯ นั้น มีไว้เพื่อการใช้งานเฉพาะบุคคลและเป็นของเจ้าของบัญชีนั้นแต่เพียงผู้เดียว ผู้ใช้ไม่สามารถโอน ให้ยืม หรือจำหน่ายสิทธิในการใช้บัญชีของตนแก่บุคคลภายนอก ขณะเดียวกันบุคคลภายนอกก็ไม่สามารถรับช่วงสิทธิหรือสืบทอดบัญชีจากผู้ใช้ดังกล่าวได้เช่นกัน'),
          ),
          actions: [
            ShowTextButton(
              label: 'ok',
              pressFunc: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
