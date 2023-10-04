import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_preview_app/common/const/app_colors.dart';
import 'package:url_preview_app/model/url_modell.dart';

class CustomLinkPreviewWidget extends StatelessWidget {
  final UrlPreviewData url;
  const CustomLinkPreviewWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      height: 100.h,
      width: 340.w,
      child: Row(
        children: [
          SizedBox(
            width: 110.w,
            height: 100.h,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Image.network(
                url.image ??
                    'https://img.icons8.com/?size=50&id=1G2BW7-tQJJJ&format=png',
                errorBuilder: (context, error, stackTrace) => Image.network(
                  'https://img.icons8.com/?size=80&id=1RWURK6uUGd9&format=png',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    url.title ?? "Can't find title",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColor.backGroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    url.desc ?? 'No Description to Show.',
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 15.sp,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.backGroundColor,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
