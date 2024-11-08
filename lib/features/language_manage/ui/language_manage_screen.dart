import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/locale/locale_cubit.dart';
import 'package:public_chat/features/language_manage/bloc/language_manage_bloc.dart';
import 'package:public_chat/utils/locale_support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageManageScreen extends StatelessWidget {
  const LanguageManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageManageBloc()
        ..add(LanguageManageInit(
            selectedLanguageCode:
                context.read<LocaleCubit>().state?.languageCode,
            supportedLocales: AppLocalizations.supportedLocales)),
      child: const _LanguageManageBody(),
    );
  }
}

class _LanguageManageBody extends StatelessWidget {
  const _LanguageManageBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageManageBloc, LanguageManageState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            Widget body;

            switch (state.status) {
              case LanguageFetchStatus.initial:
                body = const Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case LanguageFetchStatus.failed:
                body = Center(child: Text(context.locale.languagesLoadFailed));
                break;
              case LanguageFetchStatus.success:
                final searchBar = TextFormField(
                  controller:
                      context.read<LanguageManageBloc>().searchTextController,
                  onChanged: (value) => context
                      .read<LanguageManageBloc>()
                      .add(LanguageManageSearchTextChanged(searchText: value)),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Visibility(
                      visible: state.searchText.isNotEmpty,
                      child: IconButton(
                        onPressed: () => context
                            .read<LanguageManageBloc>()
                            .add(LanguageManageClearSearchText()),
                        icon: const Icon(Icons.close),
                        color: Colors.red,
                      ),
                    ),
                    hintText: '${context.locale.searchLanguage}...',
                  ),
                );

                final languages = ListView.builder(
                  controller: scrollController,
                  itemCount: state.languagesFiltered.length,
                  itemBuilder: (context, index) {
                    final locale = state.languagesFiltered[index];
                    final isSelected =
                        locale.languageCode == state.selectedLanguageCode;

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.blue
                              : index.isEven
                                  ? null
                                  : Colors.blue.withOpacity(0.1),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      onPressed: () {
                        Navigator.maybePop(context);
                        context.read<LocaleCubit>().setLocale(locale);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            locale.flagUrl,
                            height: 18,
                            width: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
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
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              locale.navigateName ?? locale.name,
                              style: TextStyle(
                                  color: isSelected ? Colors.white : null),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check, color: Colors.white),
                        ],
                      ),
                    );
                  },
                );

                body = Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: searchBar),
                    Expanded(child: languages),
                  ],
                );

                break;
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(context.locale.selectLanguage),
              ),
              body: body,
            );
          },
        );
      },
    );
  }
}
