import 'package:bat_theme/bat_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarty/features/devices/presentation/views/home_page.dart';
import '../../domain/models/devices.dart';

import '../../../../core/navigation/navigator.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../home/presentation/widgets/widgets.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = BatThemeData.of(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: HomePage(),
    );
  }
}
