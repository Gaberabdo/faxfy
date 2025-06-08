import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'dart:ui';

class FaxLinkedIndicator extends StatelessWidget {
  final List<FaxEntities> linkedFaxes;
  final Function(FaxEntities) onOpenFax;

  const FaxLinkedIndicator({
    Key? key,
    required this.linkedFaxes,
    required this.onOpenFax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no linked faxes, don't show anything
    if (linkedFaxes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        onTap: () => _showLinkedFaxesDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE6A23C).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.link,
                    color: const Color(0xFFE6A23C),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'فاكسات مرتبطة (${linkedFaxes.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLinkedFaxesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: 400,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2756).withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE6A23C).withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الفاكسات المرتبطة',
                        style: TextStyle(
                          color: const Color(0xFFE6A23C),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xFFE6A23C),
                  thickness: 0.5,
                  height: 1,
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: linkedFaxes.length,
                    itemBuilder: (context, index) {
                      final fax = linkedFaxes[index];
                      return _buildLinkedFaxItem(context, fax);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedFaxItem(BuildContext context, FaxEntities fax) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onOpenFax(fax);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fax.subject,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: fax.faxType == 'sader'
                            ? Colors.green
                            : const Color(0xFF4361EE),
                      ),
                    ),
                    child: Text(
                      fax.faxType == 'sader' ? 'صادر' : 'وارد',
                      style: TextStyle(
                        color: fax.faxType == 'sader'
                            ? Colors.green
                            : const Color(0xFF4361EE),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    IconlyLight.calendar,
                    color: Colors.white.withOpacity(0.7),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fax.formattedDate,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}