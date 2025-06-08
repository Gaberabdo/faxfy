import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/fax_details/widget/component/filter_by_data.dart';
import 'package:faxfy/feature/layout/widget/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/fax_system_cubit.dart';
import '../component/fax_system_widgets.dart';

class AllFaxScreen extends StatelessWidget {
  const AllFaxScreen({
    super.key,
    required this.faxType,
    required this.start,
    required this.end,
  });

  final String faxType;
  final dynamic start;
  final dynamic end;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<FaxSystemCubit>()
                ..getFaxes(
                  isFollow: faxType == 'follow',
                  isToday: faxType == 'elyom',
                  isSader: faxType == 'sader',
                  isWared: faxType == 'wared',
                )
                ..initializeDateFilter(
                  start,
                  end,
                  isFollow: faxType == 'follow',
                  isToday: faxType == 'elyom',
                  isSader: faxType == 'sader',
                  isWared: faxType == 'wared',
                ),
      child: FaxSystemView(faxType: faxType),
    );
  }
}

class FaxSystemView extends StatelessWidget {
  const FaxSystemView({super.key, required this.faxType});
  final String faxType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FaxSystemCubit, FaxSystemState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl, // RTL for Arabic
          child: Scaffold(
            body: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    // Main content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        FaxSystemHeader(faxType: faxType),
                        const SizedBox(height: 20),

                        Column(
                          children: [
                            FaxSystemMainContent(
                              faxType: faxType,
                              cubit: context.read<FaxSystemCubit>(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaxSystemSearchBar(),
                                const SizedBox(width: 10),
                                if (faxType == 'wared' || faxType == 'sader')
                                  DateFilterCalendar(
                                    faxSystemCubit: context.read<FaxSystemCubit>(),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),

                    // Back button (top left)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: AnimatedButton(
                        icon: Icons.arrow_forward_ios,
                        delay: 0,
                        onTap: () {
                          navigateAndFinish(context, HomeScreen());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
