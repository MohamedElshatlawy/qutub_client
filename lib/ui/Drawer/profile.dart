import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_clinet/API/authentication.dart';
import 'package:qutub_clinet/Providers/userProvider.dart';
import 'package:qutub_clinet/models/userModel.dart';
import 'package:qutub_clinet/ui/widgets/customButton.dart';
import 'package:qutub_clinet/ui/widgets/customTextField.dart';
import 'package:qutub_clinet/ui/widgets/snackBarAndDialog.dart';

import '../colors.dart';

class Profile extends StatefulWidget {
  TextEditingController nameController;
  TextEditingController mailController;
  TextEditingController phoneController;
  UserModel userModel;
  Profile({this.userModel}) {
    nameController = TextEditingController(text: userModel.name);
    mailController = TextEditingController(text: userModel.email ?? "");
    phoneController = TextEditingController(text: userModel.phone);
  }

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File img;
  var profileKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: profileKey,
      appBar: AppBar(
        backgroundColor: MyColor.customColor,
        title: Text('الحساب الشخصي'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: MyColor.customColor)),
                              child: ClipOval(
                                  child: (img != null)
                                      ? Image.file(img,
                                      fit: BoxFit.cover,
                                      )
                                      : (widget.userModel.profileImg == null)
                                          ? Image.asset(
                                              'assets/camera.png',
                                              color: MyColor.customColor,
                                              scale: 4,
                                            )
                                          : Image.network(
                                              widget.userModel.profileImg,
                                              fit: BoxFit.cover,
                                              )))),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              img = await getImage();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.red[800],
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                CustomTextField(
                  controller: widget.nameController,
                  labelColor: MyColor.customColor,
                  txtColor: MyColor.customColor,
                  txtLablel: 'اسم المستخدم',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: widget.mailController,
                  labelColor: MyColor.customColor,
                  txtColor: MyColor.customColor,
                  txtLablel: 'البريد الألكتروني',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  isEditForProfile: true,
                  controller: widget.phoneController,
                  isEdit: false,
                  labelColor: MyColor.customColor,
                  txtColor: MyColor.customColor,
                  txtLablel: 'رقم التليفون',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  backgroundColor: MyColor.whiteColor,
                  textColor: MyColor.customColor,
                  txt: 'تعديل',
                  btnPressed: () async {
                    if (widget.nameController.text.isEmpty) {
                      showSnackbarError(
                          msg: 'من فضلك ادخل اسم المستخدم',
                          scaffoldKey: profileKey);
                      return;
                    }
                    widget.userModel.name = widget.nameController.text;
                    widget.userModel.email = widget.mailController.text;

                    showMyDialog(context: context, msg: 'جاري تحديث البيانات');
                    await updateUserInfo(widget.userModel, img).then((value) {
                      dismissDialog(context);
                      userProvider.setUser(widget.userModel);
                      Navigator.pop(context);
                    }).catchError((e) {
                      dismissDialog(context);
                      print('ErrorUpdateUserInfo:$e');
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
