import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/view_fax/widgets/screens/edit_fax_screen.dart';
import 'package:faxfy/feature/view_fax/widgets/screens/view_details_fax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../auth/domain/entities/user_entites.dart';
import '../../controller/fax_system_cubit.dart';

class FaxSystemHeader extends StatelessWidget {
  const FaxSystemHeader({super.key, required this.faxType});
  final String faxType;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: -20, end: 0),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Transform.translate(offset: Offset(0, value), child: child);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title with fade-in animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Opacity(opacity: value, child: child);
            },

            child: Text(
              faxType == 'elyom'
                  ? 'منظومة فاكسات اليوم سنة ${DateTime.now().year}'
                  : faxType == 'sader'
                  ? 'منظومة فاكسات الصادرة سنة ${DateTime.now().year}'
                  : 'منظومة فاكسات الواردة سنة ${DateTime.now().year}',
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontSize: 33,
                shadows: [
                  Shadow(
                    color: ColorManager.secondColor,
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FaxSystemMainContent extends StatelessWidget {
  const FaxSystemMainContent({
    super.key,
    required this.faxType,
    required this.cubit,
  });
  final String faxType;
  final FaxSystemCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FaxSystemCubit, FaxSystemState>(
      listener: (context, state) {},
      builder: (context, state) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, double value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFFFD700), width: 4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEEEEEE), width: 2),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'عنوان الفاكس',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'الجهة ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'رقم الفاكس',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'التاريخ والوقت',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                // Fax list
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is FaxSystemLoaded) {
                        final faxes = state.faxes;

                        if (faxes.isEmpty) {
                          return const Center(child: Text('لا توجد نتائج'));
                        }

                        return ListView.builder(
                          itemCount: faxes.length,
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            final fax = faxes[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color:
                                    index % 2 == 0
                                        ? const Color(0xFFF8F8F8)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFEEEEEE),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          print('fax: ${fax.faxType}');
                                          print('fax: ${faxType}');
                                          if (MainCubit.get(
                                            context,
                                          ).roles.contains(Roles.edit)) {
                                            navigateToScreen(
                                              context,
                                              FaxSystemEditScreen(
                                                fax: fax,
                                                faxType: faxType,
                                                endDate: cubit.endDate,
                                                startDate: cubit.startDate,
                                              ),
                                            );
                                            print('endDate: ${cubit.endDate}');
                                            print(
                                              'startDate: ${cubit.startDate}',
                                            );
                                          } else {
                                            navigateToScreen(
                                              context,
                                              FaxSystemScreen(
                                                fax: fax,
                                                faxType: faxType,
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            // Status indicators column
                                            if (cubit.roles.contains(
                                              Roles.edit,
                                            ))
                                              Column(
                                                children: [
                                                  // Viewed/Unviewed indicator
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          fax.viewed!
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                    0.5,
                                                                  )
                                                              : const Color(
                                                                0xFF4CAF50,
                                                              ), // Green for unviewed
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  // Edited indicator
                                                  if (fax.edited!)
                                                    if (cubit.roles.contains(
                                                      Roles.create,
                                                    ))
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            const BoxDecoration(
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                              color: Color(
                                                                0xFF2196F3,
                                                              ), // Blue for edited
                                                            ),
                                                      ),
                                                ],
                                              ),
                                            const SizedBox(width: 8),
                                            SvgPicture.asset(
                                              fax.faxType == 'wared'
                                                  ? 'assets/images/wared_icon.svg'
                                                  : 'assets/images/sader_icon.svg',
                                              width: 30,
                                              height: 30,
                                              color:
                                                  fax.faxType == 'wared'
                                                      ? Color(0xFFD87218)
                                                      : const Color(0xFF78B858),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                fax.subject,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                fax.faxAddress,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                fax.index.toString(),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                fax.formattedDate,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Add options menu
                                    if (cubit.roles.contains(Roles.edit))
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            // Handle edit action
                                            print('fax: ${fax.faxType}');
                                            navigateToScreen(
                                              context,
                                              FaxSystemEditScreen(
                                                fax: fax,
                                                faxType: faxType,
                                                endDate: cubit.endDate,
                                                startDate: cubit.startDate,
                                              ),
                                            );
                                          } else if (value == 'delete') {
                                            // Show confirmation dialog
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('تأكيد الحذف'),
                                                      ],
                                                    ),
                                                    content: Text(
                                                      'هل أنت متأكد من رغبتك في حذف هذا الفاكس؟ لا يمكن التراجع عن هذا الإجراء.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: Text('إلغاء'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          // Delete the fax
                                                          cubit.deleteFax(
                                                            fax.faxId,
                                                            faxType,
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        style:
                                                            TextButton.styleFrom(
                                                              foregroundColor:
                                                                  Colors.red,
                                                            ),
                                                        child: Text('نعم، حذف'),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          }
                                        },
                                        itemBuilder:
                                            (context) => [
                                              PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit, size: 20),
                                                    SizedBox(width: 8),
                                                    Text('تعديل'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'حذف',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FaxSystemSearchBar extends StatelessWidget {
  const FaxSystemSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaxSystemCubit, FaxSystemState>(
      builder: (context, state) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 20, end: 0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(value, 0),
              child: Opacity(
                opacity: value == 0 ? 1.0 : 1.0 - (value / 20),
                child: child,
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4 - 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                // Search input
                TextField(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'بحث...',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  onChanged: (value) {
                    context.read<FaxSystemCubit>().searchFax(value);
                  },
                ),

                // Left icon (search)
                Positioned(
                  left: 15,
                  top: 0,
                  bottom: 0,
                  child: PulsingWidget(
                    child: const Icon(
                      Icons.search,
                      color: Color(0xFFF97316), // Orange
                    ),
                  ),
                ),

                // Right icon (info)
                Positioned(
                  right: 15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(Icons.info_outline, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final IconData icon;
  final int delay;
  final VoidCallback onTap;

  const AnimatedButton({
    super.key,
    required this.icon,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: -20, end: 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: Opacity(
            opacity: value == 0 ? 1.0 : 1.0 - (value.abs() / 20),
            child: child,
          ),
        );
      },
      child: Material(
        color: const Color(0xFF8A7654),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: const Color(0xFFF97316), // Orange
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class PulsingWidget extends StatelessWidget {
  final Widget child;

  const PulsingWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: 1.05),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }
}
