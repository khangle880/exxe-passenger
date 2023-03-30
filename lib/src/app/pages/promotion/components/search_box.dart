import 'package:flutter/material.dart';

import '../../../../config/config.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Mã giảm giá của bạn',
        hintStyle: AppStyles.s14w4.copyWith(
          color: AppColors.gray70x76,
        ),
        filled: true,
        fillColor: AppColors.gray05,
      ),
    );
  }
}
