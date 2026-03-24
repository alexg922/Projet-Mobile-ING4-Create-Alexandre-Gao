import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_vectorial_images.dart';

class HomePageEmpty extends StatelessWidget {
  const HomePageEmpty({super.key, this.onScan});

  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Spacer(flex: 20),
          SvgPicture.asset(AppVectorialImages.illEmpty),
          const Spacer(flex: 10),
          Expanded(
            flex: 20,
            child: Column(
              children: <Widget>[
                Text(
                  localizations.my_scans_screen_description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 16,
                    color: AppColors.grey3,
                  ),
                ),
                const Spacer(flex: 5),
                SizedBox(
                  width: 275,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.blue,
                      backgroundColor: AppColors.yellow,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    onPressed: onScan,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          localizations.my_scans_screen_button.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Icon(Icons.arrow_forward_outlined, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 20),
        ],
      ),
    );
  }
}
