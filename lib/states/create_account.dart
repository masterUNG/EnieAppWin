import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:enie/main.dart';
import 'package:enie/models/district_model.dart';
import 'package:enie/models/province_model.dart';
import 'package:enie/models/sub_district_model.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:enie/utillity/my_dialog.dart';
import 'package:enie/widgets/show_button.dart';
import 'package:enie/widgets/show_icon_button.dart';
import 'package:enie/widgets/show_text.dart';
import 'package:enie/widgets/show_text_button.dart';
import 'package:enie/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';
import 'package:enie/widgets/show_image.dart';
import 'package:enie/widgets/show_progress.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  var provinceModels = <ProvinceModel>[];
  var indexProvinces = <int>[];
  bool load = true;
  int? indexProvince;

  bool loadDistrict = true;
  var districtModels = <DistrictModel>[];
  var indexDistricts = <int>[];
  int? indexDistrict;

  bool loadSubDistrict = true;
  var subDistrictModels = <SubDistrictModel>[];
  var indexSubDistricts = <int>[];
  int? indexSubDistrict;

  bool accept = false;

  @override
  void initState() {
    super.initState();
    readAllProvince();
  }

  File? file;
  String avatar = '';
  final formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lineController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController alleyController = TextEditingController();
  TextEditingController roadController = TextEditingController();
  TextEditingController persuaderController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildCreateNewAccount(),
        ],
        title: Text('Create Account'),
        backgroundColor: Myconstant.primary,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTitle('รูปภาพหน้าร้าน'),
                  newImageShop(),
                  buildSubTitle(),
                  buildTitle('ข้อมูลทั่วไป'),
                  buildName(size),
                  buildEmail(size),
                  buildPhone(size),
                  buildPassword(size),
                  buildLine(size),
                  buildTitle('ที่อยู่'),
                  buildAddress(size),
                  buildVillage(size),
                  buildAlley(size),
                  buildRoad(size),
                  load
                      ? const ShowProgress()
                      : newCenter(widget: dropProvince()),
                  indexProvince == null
                      ? const SizedBox()
                      : loadDistrict
                          ? const ShowProgress()
                          : newCenter(widget: dropDistrict()),
                  indexDistrict == null
                      ? const SizedBox()
                      : newCenter(widget: dropSubDistrict()),
                  buildPersuader(size),
                  newCenter(
                    widget: readAccetp(),
                  ),
                  newCenter(
                    widget: newAccetp(),
                  ),
                  newCenter(
                    widget: BuildInputUser(),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget readAccetp() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ShowTextButton(
        label: 'อ่านข้อกำหนดการใช้งาน และนโยบายความเป็นส่วนตัว',
        pressFunc: () {
          MyDialog(context: context).readAccetpDialog();
        },
      ),
    );
  }

  Container newAccetp() {
    return Container(
      width: 300,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title:
            ShowText(label: 'ยอมรับข้อกำหนดการใช้งาน และนโยบายความเป็นส่วนตัว'),
        value: accept,
        onChanged: (value) {
          accept = value!;
          setState(() {});
        },
      ),
    );
  }

  Row newImageShop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 250,
          height: 250,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0),
                child: file == null
                    ? ShowImage(
                        path: 'images/salon_picture.png',
                      )
                    : Image.file(file!),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ShowIconButton(
                  iconData: Icons.add_a_photo_outlined,
                  tapFunc: () {
                    dialogChoosePhoto();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// การเลือกถ่ายรูป หรือ ดึงรูปจาก แกลอรี่ มาแสดง
  Future<Null> takePhoto(ImageSource imageSource) async {
    try {
      var result = await ImagePicker()
          .getImage(source: imageSource, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Future<void> dialogChoosePhoto() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: const SizedBox(
            width: 80,
            child: ShowImage(
              path: 'images/salon_picture.png',
            ),
          ),
          title: ShowText(
            label: 'Take Photo',
            textStyle: Myconstant().h2Style(),
          ),
          subtitle: const ShowText(label: 'Please tab Camera or Gallery'),
        ),
        actions: [
          ShowButton(
            label: 'Camera',
            pressFunc: () {
              Navigator.pop(context);
              takePhoto(ImageSource.camera);
            },
          ),
          ShowButton(
            label: 'Gallery',
            pressFunc: () {
              Navigator.pop(context);
              takePhoto(ImageSource.gallery);
            },
          ),
          ShowButton(
            label: 'Cancel',
            pressFunc: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // First อ่าน API ที่อยู่ จังหวัด อำเภอ ตำบล
  void ReadSubDistrictByDistrictId({required String districtId}) async {
    String path = '${Myconstant.pathApiReadSubDistrictByDistrictId}$districtId';

    if (subDistrictModels.isNotEmpty) {
      loadSubDistrict = true;
      subDistrictModels.clear();
      indexSubDistricts.clear();
      indexSubDistrict = null;
    }

    await Dio().get(path).then((value) {
      int index = 0;
      for (var element in json.decode(value.data)) {
        SubDistrictModel SubdistrictModel = SubDistrictModel.fromMap(element);
        subDistrictModels.add(SubdistrictModel);
        indexSubDistricts.add(index);
        index++;
      }
      loadSubDistrict = false;
      setState(() {});
    });
  }

  Future<void> readDistrictByProvinceID({required String provinceId}) async {
    String path = '${Myconstant.pathApiReadDistrictByProvinceId}$provinceId';

    if (districtModels.isNotEmpty) {
      districtModels.clear();
      indexDistricts.clear();
      indexDistrict = null;
    }

    await Dio().get(path).then((value) {
      int index = 0;
      for (var element in json.decode(value.data)) {
        DistrictModel districtModel = DistrictModel.fromMap(element);
        districtModels.add(districtModel);
        indexDistricts.add(index);
        index++;
      }
      loadDistrict = false;

      setState(() {});
    });
  }

  Future<void> readAllProvince() async {
    String path = Myconstant.pathApiReadAllProvince;
    await Dio().get(path).then((value) {
      int index = 0;
      for (var element in json.decode(value.data)) {
        ProvinceModel model = ProvinceModel.fromMap(element);
        provinceModels.add(model);
        indexProvinces.add(index);
        index++;
      }
      load = false;
      setState(() {});
    });
  }
  // End อ่าน API ที่อยู่ จังหวัด อำเภอ ตำบล

  // First ฟอร์ม จังหวัด อำเภอ ตำบล
  Widget dropSubDistrict() => Container(
        padding: const EdgeInsets.only(left: 32),
        margin: const EdgeInsets.only(top: 16),
        decoration: Myconstant().coverBox(),
        width: 270,
        height: 60,
        child: DropdownButton<dynamic>(
          hint: ShowText(label: 'โปรดเลือกตำบล กับ zip'),
          value: indexSubDistrict,
          items: indexSubDistricts
              .map(
                (e) => DropdownMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShowText(
                          label: subDistrictModels[e].sub_district_name_th),
                      ShowText(
                          label: subDistrictModels[e].sub_district_zip_code),
                    ],
                  ),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (value) {
            indexSubDistrict = value;
            setState(() {});
          },
        ),
      );

  Widget dropDistrict() => Container(
        padding: const EdgeInsets.only(left: 32),
        margin: const EdgeInsets.only(top: 16),
        decoration: Myconstant().coverBox(),
        width: 270,
        height: 60,
        child: DropdownButton<dynamic>(
          underline: const SizedBox(),
          hint: ShowText(label: 'โปรดเลือกอำเภอ'),
          value: indexDistrict,
          items: indexDistricts
              .map(
                (e) => DropdownMenuItem(
                  child: ShowText(label: districtModels[e].district_name_th),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (value) {
            indexDistrict = value;
            ReadSubDistrictByDistrictId(
                districtId: districtModels[indexDistrict!].id.toString());
            setState(() {});
          },
        ),
      );

  Widget dropProvince() => Container(
        padding: const EdgeInsets.only(left: 32),
        margin: const EdgeInsets.only(top: 16),
        decoration: Myconstant().coverBox(),
        width: 270,
        height: 60,
        child: DropdownButton<dynamic>(
            underline: const SizedBox(),
            hint: ShowText(label: 'โปรดเลือกจังหวัด'),
            value: indexProvince,
            items: indexProvinces
                .map(
                  (e) => DropdownMenuItem(
                    child: ShowText(label: provinceModels[e].province_name_th),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (value) {
              loadDistrict = true;
              indexProvince = value;
              readDistrictByProvinceID(
                  provinceId: provinceModels[indexProvince!].id.toString());
              setState(() {});
            }),
      );
  // End ฟอร์ม จังหวัด อำเภอ ตำบล

  Row newCenter({required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget,
      ],
    );
  }

  IconButton buildCreateNewAccount() {
    return IconButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {
          print('Process Insert to Database');

          processCreateAccount();
        }
      },
      icon: Icon(Icons.cloud_upload),
    );
  }

  Container BuildInputUser() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ShowButton(
          label: 'สมัครใช้งาน',
          pressFunc: () {
            if (formkey.currentState!.validate()) {
              processCreateAccount();
            }
          }),
    );
  }

  Future<void> processCreateAccount() async {
    if ((indexProvince == null) ||
        (indexDistrict == null) ||
        (indexSubDistrict == null)) {
      MyDialog(context: context).normalDialog(
          title: 'Choose ไม่ครบ',
          subTitle: 'โปรดเลือก จังหวัด, อำเภอ และ ตำบล');
    } else if (accept) {
      uploadPictureAndInsertData();
    } else {
      MyDialog(context: context).normalDialog(
          title: 'ยังไม่ยอมรับ เงื่อนไข',
          subTitle: 'กรุณายอมรับเงิื่อนไขด้วยครับ');
    }
  }

  Future<Null> uploadPictureAndInsertData() async {
    String salon_name = nameController.text;
    String salon_email = emailController.text;
    String salon_phone = phoneController.text;
    String salon_password = passwordController.text;
    String salon_line = lineController.text;
    String salon_address = addressController.text;
    String salon_village = villageController.text;
    String salon_alley = alleyController.text;
    String salon_road = roadController.text;
    String salon_persuader = persuaderController.text;
    int province_id = provinceModels[indexProvince!].id;
    int district_id = districtModels[indexDistrict!].id;
    int sub_district_id = subDistrictModels[indexSubDistrict!].id;
    String salon_zip_code =
        subDistrictModels[indexSubDistrict!].sub_district_zip_code;

    print(
        '## salon_name =$salon_name,salon_email =$salon_email,salon_phone =$salon_phone,salon_password =$salon_password,salon_line =$salon_line,salon_address =$salon_address,salon_village =$salon_village,salon_alley =$salon_alley,salon_road =$salon_road,salon_persuader =$salon_persuader,province_id =$province_id,district_id =$district_id,sub_district_id =$sub_district_id,salon_zip_code =$salon_zip_code,salon_main_picture=$file');
    String path =
        'https://office.fantasy.co.th/api/salon/getUserWhereUser?username=$salon_phone';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');

      if (value.toString() == '[]') {
        print('## user OK');

        processInsertMySQL(
          salon_name: salon_name,
          salon_email: salon_email,
          salon_phone: salon_phone,
          salon_password: salon_password,
          salon_line: salon_line,
          salon_address: salon_address,
          salon_village: salon_village,
          salon_alley: salon_alley,
          salon_road: salon_road,
          salon_persuader: salon_persuader,
          province_id: province_id,
          district_id: district_id,
          sub_district_id: sub_district_id,
          salon_zip_code: salon_zip_code,
        );
      } else {
        MyDialog(context: context).normalDialog(
            title: 'เบอร์โทรนี้มีในระบบแล้ว',
            subTitle: 'กรุณาติดต่อ 02-9171941');
      }
    });
  }

  Future<Null> processInsertMySQL({
    String? salon_name,
    String? salon_email,
    String? salon_phone,
    String? salon_password,
    String? salon_line,
    String? salon_address,
    String? salon_village,
    String? salon_alley,
    String? salon_road,
    String? salon_persuader,
    int? province_id,
    int? district_id,
    int? sub_district_id,
    String? salon_zip_code,
  }) async {
    print('## processInsertMySQL Work avatar ==>> $avatar');
    String apiInsertUser =
        'https://office.fantasy.co.th/api/salon/register?salon_name=$salon_name&email=$salon_email&salon_phone=$salon_phone&password=$salon_password&salon_line=$salon_line&salon_address=$salon_address&salon_village=$salon_village&salon_alley=$salon_alley&salon_road=$salon_road&salon_persuader=$salon_persuader&province_id=$province_id&district_id=$district_id&subdistrict_id=$sub_district_id&salon_zip_code=$salon_zip_code';
    await Dio().post(apiInsertUser).then((value) => {
          if (value.toString() == 'true')
            {
              Navigator.pop(context),
              MyDialog(context: context).SuccessDialog(
                  title: 'สำเร็จแล้ว',
                  subTitle: 'กรุณารอการติดต่อกลับจากทีมงาน Enie'),
            }
          else
            {
              MyDialog(context: context).normalDialog(
                  title: 'Create New User False !!!',
                  subTitle: 'Please Try Again'),
            }
        });
  }

  ShowTitle buildSubTitle() {
    return ShowTitle(
      title: '*รูปภาพหน้าร้าน (ต้องใส่)',
      textStyle: Myconstant().h3Style(),
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ชื่อร้าน ด้วยค่ะ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: '*ชื่อร้าน :',
              prefixIcon: Icon(
                Icons.store_sharp,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: 'อีเมล :',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildLine(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: lineController,
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: 'ไลน์ :',
              prefixIcon: Icon(
                Icons.line_style,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก เลขที่/อาคาร ด้วยค่ะ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: '*เลขที่/อาคาร :',
              prefixIcon: Icon(
                Icons.store_sharp,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildVillage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: villageController,
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: 'หมู่บ้าน :',
              prefixIcon: Icon(
                Icons.factory,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAlley(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: alleyController,
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: 'ซอย :',
              prefixIcon: Icon(
                Icons.strikethrough_s_sharp,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRoad(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: roadController,
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: 'ถนน :',
              prefixIcon: Icon(
                Icons.landscape,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก เบอร์โทรศัพท์ ด้วยค่ะ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: '*เบอร์โทรศัพท์ :',
              prefixIcon: Icon(
                Icons.phone,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก รหัสผ่าน ด้วยค่ะ';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: '*รหัสผ่าน :',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPersuader(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: persuaderController,
            decoration: InputDecoration(
              labelStyle: Myconstant().h3Style(),
              labelText: '*ผู้แนะนำ :',
              prefixIcon: Icon(
                Icons.store_sharp,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: Myconstant().h2Style(),
      ),
    );
  }
}
