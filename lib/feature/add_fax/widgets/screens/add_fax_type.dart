import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/widgets/screens/add_fax_screen.dart';
import 'package:flutter/material.dart';

class AddFaxTypeDialog extends StatelessWidget {
  const AddFaxTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the screen is small (similar to mobile view in responsive design)
    return AlertDialog(
      title: const Text(
        'اضافة نوع فاكس',
        style: TextStyle(color: Color(0xFF1E2756), fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(child: _buildOutgoingCard(context)),
            const SizedBox(width: 16),
            Expanded(child: _buildIncomingCard(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOutgoingCard(BuildContext context) {
    return _buildCard(
      context: context,
      icon: Icons.arrow_outward,
      title: 'صادر',
      faxType: 1,
      subtitle: 'الفاكسات الصادرة',
    );
  }

  Widget _buildIncomingCard(BuildContext context) {
    return _buildCard(
      context: context,
      icon: Icons.arrow_downward,
      faxType: 2,
      title: 'وارد',
      subtitle: 'الفاكسات الواردة',
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required int faxType
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          navigateToScreen(context, AddFaxScreen(faxType: faxType));
        },
        borderRadius: BorderRadius.circular(12),
        hoverColor: const Color(0xFFF5B93F).withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: const Color(0xFFF5B93F)),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2756),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
