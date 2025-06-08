import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/fax_details/widget/screens/fax_system_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FaxViewHeader extends StatelessWidget {
  const FaxViewHeader({
    super.key,
    required this.faxType,
    required this.faxTypeModel,
    required this.start,
    required this.end,
  });
  final String faxType;
  final String faxTypeModel;
  final dynamic start;
  final dynamic end;
  @override
  Widget build(BuildContext context) {
    print(faxType);
    print(start);
    print(end);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFA08C5B).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: IconButton(
            onPressed: () {
              navigateAndFinish(context, AllFaxScreen(faxType: faxType,start: start,end: end,));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFF5B93F),
              size: 28,
            ),
          ),
        ),

        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  (faxTypeModel != 'sader')
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
        SizedBox(width: 12),
      ],
    );
  }
}
