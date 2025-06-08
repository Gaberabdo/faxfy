import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../controller/add_fax_cubit.dart';

class FaxHeader extends StatelessWidget {
  const FaxHeader({super.key, required this.faxType, required this.cubit});
  final int faxType;
  final AddFaxCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFA08C5B).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFF5B93F),
              size: 28,
            ),
          ),
        ),

        // Logo and title
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  faxType == 2
                      ? 'منظومة فاكسات الوارد'
                      : 'منظومة فاكسات الصادر',
                  style: TextStyle(
                    color: Color(0xFFF5B93F),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' سنة '
                  " ${DateTime.now().year} ",
                  style: TextStyle(color: Color(0xFFF5B93F), fontSize: 18),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF5B93F),
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Color(0xFF1E2756),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        // Forward/Outgoing button
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            cubit.clear(faxType == 2 ? "wared" : "sader");
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFA08C5B).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  faxType == 2
                      ? 'اضافة فاكس وارد جديد'
                      : 'اضافة فاكس صادر جديد ',
                  style: TextStyle(
                    color: Color(0xFFF5B93F),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  faxType == 2 ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Color(0xFFF5B93F),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
