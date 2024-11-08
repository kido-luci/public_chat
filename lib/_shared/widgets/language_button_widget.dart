import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/locale/locale_cubit.dart';
import 'package:public_chat/_shared/data/locale_language.dart';
import 'package:public_chat/features/language_manage/ui/language_manage_screen.dart';

class LanguageButtonWidget extends StatelessWidget {
  const LanguageButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleLanguage?>(
      builder: (context, state) {
        return SizedBox(
          height: 32,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const LanguageManageScreen(),
            ),
            child: Builder(builder: (context) {
              return Row(
                children: [
                  if (state != null)
                    Image.network(
                      state.flagUrl,
                      height: 18,
                      width: 28,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 18,
                        width: 28,
                        color: Colors.blue.shade200,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.info,
                          size: 15,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Text(state?.languageCode.toUpperCase() ?? 'N/A'),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
