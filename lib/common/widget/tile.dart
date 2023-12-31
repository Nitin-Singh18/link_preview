import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/url_modell.dart';
import '../const/app_colors.dart';

class Tile extends StatelessWidget {
  final UrlPreviewData url;

  const Tile({
    super.key,
    required this.url,
  });

  @override
  build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: AnyLinkPreview(
        link: url.url!,
        displayDirection: UIDirection.uiDirectionHorizontal,
        bodyMaxLines: 3, // Max lines for the description
        bodyStyle: TextStyle(
          color: AppColor.backGroundColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
