import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/generated/assets.gen.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CentersPostsForm extends StatefulWidget {
  const CentersPostsForm({super.key});

  @override
  State<CentersPostsForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<CentersPostsForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController postContextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  void dispose() {
    postContextController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted) {
        return true;
      }
      if (await Permission.storage.request().isGranted && await Permission.mediaLibrary.request().isGranted) {
        return true;
      }
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      return false;
    } else {
      final status = await Permission.photos.status;
      if (status.isDenied) {
        final result = await Permission.photos.request();
        return result.isGranted;
      }
      return status.isGranted;
    }
  }

  Future<File?> pickAndUploadImage() async {
    try {
      if (await _requestPermission()) {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image == null) {
          debugPrint("No image selected.");
          return null;
        }

        file = File(image.path);
        return file;
      }
      return null;
    } catch (e) {
      debugPrint("Upload failed: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            buildFieldTitle(title: LocaleKeys.posts_post_context.tr()),
            buildTextField(
              hint: LocaleKeys.posts_post_context.tr(),
              controller: postContextController,
              textInputAction: TextInputAction.newline,
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildFieldTitle(title: LocaleKeys.posts_post_image.tr()),
                LargeButton(
                  onPressed: () {
                    pickAndUploadImage();
                  },
                  text: LocaleKeys.posts_upload_image.tr(),
                  backgroundColor: context.primaryContainer,
                  circularRadius: 12,
                ),
              ],
            ),
            SizedBox(height: 3),
            LargeButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              icon: Assets.images.sideActions.twitter.path,
              text: LocaleKeys.posts_post.tr(),
              backgroundColor: context.primaryContainer,
              circularRadius: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFieldTitle({required String title}) {
    return AppText.labelLarge(
      title,
      textAlign: TextAlign.right,
      color: context.onPrimaryColor,
      fontWeight: FontWeight.bold,
    );
  }
}

Widget buildTextField({
  required String hint,
  required TextEditingController controller,
  String validatorTitle = "",
  int mxLine = 1,
  Widget? sufIcon,
  bool? readOnly,
  dynamic Function()? onTap,
  TextInputAction? textInputAction,
  bool needValidation = true,
}) {
  return CustomTextField(
    onTap: onTap,
    readOnly: readOnly,
    mxLine: mxLine,
    controller: controller,
    textInputAction: textInputAction,
    hint: hint,
    validator:
        needValidation
            ? (value) {
              if (value == null || value.isEmpty) {
                return validatorTitle.isNotEmpty ? validatorTitle : LocaleKeys.transfer_this_field_cant_be_empty.tr();
              }
              return null;
            }
            : null,
    sufIcon: sufIcon,
  );
}
