library account;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/data/models/profile_model.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:simanis/app/core/app_config.dart';
import 'package:simanis/app/core/utils/custom_helper.dart';
import 'package:simanis/app/core/values/colors.dart';
import 'package:simanis/app/core/values/value.dart';
import 'package:simanis/app/data/models/user_model.dart';
import 'package:simanis/app/modules/account/controllers/account_controller.dart';
import 'package:simanis/app/modules/account/controllers/account_detail_controller.dart';
import 'package:simanis/app/modules/account/controllers/account_update_controller.dart';
import 'package:simanis/app/modules/login/controllers/login_controller.dart';
import 'package:simanis/app/modules/webview/views/webview_view.dart';
import 'package:simanis/app/routes/app_pages.dart';
import 'package:simanis/app/widgets/forms/forms.dart';
import 'package:simanis/app/widgets/widget.dart';

part 'change_password_view.dart';
part 'detail_profile_view.dart';
part 'edit_profile_view.dart';
part 'widgets/wi_about_app.dart';
part 'widgets/wi_account_option.dart';
part 'widgets/wi_account_profile.dart';
part 'widgets/wi_contact.dart';
part 'widgets/wi_photo_change_preview.dart';
