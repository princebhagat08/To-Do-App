import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'app_color.dart';

final fontFamily = GoogleFonts.outfit().fontFamily;

// Different Text Sizes
const appName = 'To-Do';
const defaultPadding = 8.00;
const defaultMargin = 8.00;
const defaultRadius = 8.00;
const defaultContentPadding = 14.00;
const defaultGap = 8.00;
const defaultCardRadius = 12.00;
const xsmallTextsize = 10.00;
const smallTextsize = 12.00;
const normalTextsize = 14.00;
const mediumTextsize = 16.00;
const largeTextsize = 18.00;
const xLargeTextsize = 24.00;
const xxLargeTextsize = 75.00;

//blackColor color textstyle
final xsmallText = TextStyle(
  fontSize: xsmallTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
);
final xsmallLightText = TextStyle(
  fontSize: xsmallTextsize.sp,
  color: AppColor.lightPrimary,
  fontFamily: fontFamily,
);

final smallText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
);
final smallBoldText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final smallBoldColorText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final normalText = TextStyle(
  fontSize: normalTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
);

final mediumText = TextStyle(
  fontSize: mediumTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
);

final mediumBoldText = TextStyle(
  fontSize: mediumTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final mediumBoldWhiteText = TextStyle(
  fontSize: mediumTextsize.sp,
  color: Colors.white,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
);

final largeText = TextStyle(
  fontSize: largeTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
);

final largeBoldText = TextStyle(
  fontSize: largeTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

final xLargeText = TextStyle(
  fontSize: xLargeTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
);

final xLargeBoldText = TextStyle(
  fontSize: xLargeTextsize.sp,
  color: AppColor.blackColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
);

final xLargeBoldColorText = TextStyle(
  fontSize: xLargeTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
);
final xxLargeBoldColorText = TextStyle(
  fontSize: xxLargeTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

//whiteColor color textstyle

final smallWhiteText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.whiteColor,
  fontFamily: fontFamily,
);

final smallWhiteBoldText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.whiteColor,
  fontWeight: FontWeight.w500,
  fontFamily: fontFamily,
);

final normalWhiteText = TextStyle(
  fontSize: normalTextsize.sp,
  color: AppColor.whiteColor,
  fontFamily: fontFamily,
);

final mediumWhiteText = TextStyle(
  fontSize: mediumTextsize.sp,
  color: AppColor.whiteColor,
  fontFamily: fontFamily,
);

final largeWhiteText = TextStyle(
  fontSize: largeTextsize.sp,
  color: AppColor.whiteColor,
  fontFamily: fontFamily,
);

final xLargeWhiteText = TextStyle(
  fontSize: xLargeTextsize.sp,
  color: AppColor.whiteColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
);

//light color textStyle

final smallLightText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.lightPrimary,
  fontFamily: fontFamily,
);

final normalLightText = TextStyle(
  fontSize: normalTextsize.sp,
  color: AppColor.lightPrimary,
  fontFamily: fontFamily,
);

final mediumLightText = TextStyle(
  fontSize: mediumTextsize.sp,
  color: AppColor.lightPrimary,
  fontFamily: fontFamily,
);

final largeLightText = TextStyle(
  fontSize: largeTextsize.sp,
  color: AppColor.lightPrimary,
  fontFamily: fontFamily,
);

final xLargeLightText = TextStyle(
  fontSize: xLargeTextsize.sp,
  color: AppColor.lightPrimary,
  fontFamily: fontFamily,
);

//App color TextStyle

final xSmallColorText = TextStyle(
  fontSize: xsmallTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
);
final xSmallWhiteText = TextStyle(
  fontSize: xsmallTextsize.sp,
  color: AppColor.whiteColor,
  fontFamily: fontFamily,
);

final smallColorText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
);

final normalColorText = TextStyle(
  fontSize: normalTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
);

final mediumColorText = TextStyle(
  fontSize: mediumTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
);

final mediumBoldColorText = TextStyle(
  fontSize: mediumTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
);

final largeColorText = TextStyle(
  fontSize: largeTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
);

final largeBoldColorText = TextStyle(
  fontSize: largeTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
  fontWeight: FontWeight.w400,
);

final xLargeColorText = TextStyle(
  fontSize: xLargeTextsize.sp,
  color: AppColor.primaryColor,
  fontFamily: fontFamily,
);

final smallcrossedText = TextStyle(
  fontSize: smallTextsize.sp,
  color: AppColor.lightPrimary,
  fontFamily: fontFamily,
  decoration: TextDecoration.lineThrough,
);

final largeCrossedText = TextStyle(
  fontSize: largeTextsize.sp,
  color: Colors.red,
  fontFamily: fontFamily,
  decoration: TextDecoration.lineThrough,
);
