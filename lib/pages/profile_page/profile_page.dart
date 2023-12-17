import 'dart:io';
import 'dart:typed_data';
import 'package:efficacy_user/controllers/services/user/user_controller.dart';
import 'package:efficacy_user/controllers/controllers.dart';
import 'package:efficacy_user/models/models.dart';
import 'package:efficacy_user/pages/profile_page/widgets/buttons.dart';
import 'package:efficacy_user/widgets/custom_drop_down/custom_drop_down.dart';
import 'package:efficacy_user/widgets/custom_phone_input/custom_phone_input.dart';
import 'package:efficacy_user/widgets/custom_text_field/custom_text_field.dart';
import 'package:efficacy_user/widgets/profile_image_viewer/profile_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:efficacy_user/config/config.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/phone_number.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/ProfilePage';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _nameController.text = UserController.currentUser!.name;
    _scholarIDController.text = UserController.currentUser!.scholarID;
    _emailController.text = UserController.currentUser!.email;
    selectedDegree =
        UserController.currentUser!.degree?.name ?? Degree.BTech.name;
    selectedBranch =
        UserController.currentUser!.branch?.name ?? Branch.CSE.name;
    phoneNumber = UserController.currentUser!.phoneNumber;
  }

  bool editMode = false;
  bool showButton = false;

  //controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scholarIDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String selectedDegree = Degree.BTech.name;
  String selectedBranch = Branch.CSE.name;
  Uint8List? image;
  PhoneNumber? phoneNumber;

  void enableEdit() {
    setState(() {
      editMode = true;
      showButton = true;
    });
  }

  void saveUpdates() async {
    UploadInformation info = UploadInformation(
      url: UserController.currentUser?.userPhoto,
      publicID: UserController.currentUser?.userPhotoPublicID,
    );
    if (image != null) {
      info = await ImageController.uploadImage(
        img: image!,
        folder: ImageFolder.userImage,
        publicID: UserController.currentUser?.userPhotoPublicID,
        userName: _nameController.text,
      );
    }
    UserController.currentUser = UserController.currentUser?.copyWith(
      name: _nameController.text,
      scholarID: _scholarIDController.text,
      userPhoto: info.url,
      userPhotoPublicID: info.publicID,
      phoneNumber: phoneNumber,
      branch:
          Branch.values.firstWhere((branch) => branch.name == selectedBranch),
      degree:
          Degree.values.firstWhere((degree) => degree.name == selectedDegree),
    );
    await UserController.update();
    setState(() {
      editMode = false;
      showButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //screen size
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    //size constants
    double gap = height * 0.02;
    double hMargin = width * 0.08;
    double vMargin = width * 0.16;

    return Scaffold(
      floatingActionButtonLocation: showButton
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.endTop,
      floatingActionButton: showButton
          ? SaveButton(
              onPressed: () => saveUpdates(),
            )
          : EditButton(
              onPressed: () => enableEdit(),
            ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: vMargin, horizontal: hMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Account Details",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Gap(gap),

                ProfileImageViewer(
                  enabled: editMode,
                  imagePath: UserController.currentUser?.userPhoto,
                  imageData: image,
                  onImageChange: (Uint8List? newImage) {
                    image = newImage;
                  },
                ),

                CustomTextField(
                  controller: _nameController,
                  title: "Name",
                  enabled: editMode,
                ),
                CustomTextField(
                  controller: _emailController,
                  title: "Email",
                  enabled: false,
                ),
                CustomPhoneField(
                  title: "Phone",
                  initialValue: phoneNumber,
                  onPhoneChanged: (PhoneNumber newPhoneNumber) {
                    phoneNumber = newPhoneNumber;
                  },
                  enabled: editMode,
                ),
                CustomTextField(
                  controller: _scholarIDController,
                  title: "ScholarID",
                  enabled: editMode,
                ),
                CustomDropDown(
                  title: "Branch",
                  items: Branch.values.map((branch) => branch.name).toList(),
                  enabled: editMode,
                  value: UserController.currentUser!.branch?.name,
                ),
                CustomDropDown(
                  title: "Degree",
                  items: Degree.values.map((degree) => degree.name).toList(),
                  enabled: editMode,
                  value: UserController.currentUser!.degree?.name,
                ),
                // CustomDataTable(
                //   columnspace: width*0.35,
                //   columns: const ["ClubId", "Position"],
                //   rows: (UserController.currentUser?.position)??const [],
                // )
              ].separate(gap),
            ),
          ),
        ),
      ),
    );
  }
}