import 'package:care_link/features/shared/presentation/widgets/dialogs/contact_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum HelpType { ketting, mantelzorger, rol, anders }

enum ContactType { email, phone }

class HelpRequestForm extends StatefulWidget {
  const HelpRequestForm({super.key});

  @override
  State<HelpRequestForm> createState() => _HelpRequestFormState();
}

class _HelpRequestFormState extends State<HelpRequestForm> {
  HelpType? _helpType;
  ContactType _contactType = ContactType.email;
  final TextEditingController _phoneController = TextEditingController();

  bool get _canSubmit {
    if (_helpType == null) return false;
    if (_contactType == ContactType.phone && _phoneController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void _submit() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ContactConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double formWidth = screenWidth > 380 ? 340 : 310;
    final double formHeight = screenWidth > 380 ? 400 : 350;

    final double formPadding = screenWidth > 380 ? 20 : 16;
    final double titleFontSize = screenWidth > 380 ? 18 : 16;
    final double sectionSpacing = screenWidth > 380 ? 12 : 10;
    final double rowHeight = screenWidth > 380 ? 35 : 30;
    final double buttonPadding = screenWidth > 380 ? 12 : 10;

    return Center(
      child: Container(
        width: formWidth,
        height: formHeight,
        padding: EdgeInsets.all(formPadding),
        decoration: BoxDecoration(
          color: const Color(0xFFD9F1F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoe kunnen we u bereiken?',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: sectionSpacing),

              _emailRow(rowHeight),
              _phoneRow(rowHeight),

              SizedBox(height: sectionSpacing),

              Text(
                'Waar heeft u hulp bij nodig?',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: sectionSpacing),

              _helpRadio('Ketting verbinden', HelpType.ketting, rowHeight),
              _helpRadio(
                'Mantelzorger verbinden',
                HelpType.mantelzorger,
                rowHeight,
              ),
              _helpRadio('Rol aanpassen', HelpType.rol, rowHeight),
              _helpRadio('Anders', HelpType.anders, rowHeight),

              SizedBox(height: sectionSpacing),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _canSubmit ? _submit : null,
                  icon: const Icon(Icons.send),
                  label: const Text('Verstuur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3F42),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: buttonPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _helpRadio(String label, HelpType value, double rowHeight) {
    return SizedBox(
      height: rowHeight,
      child: RadioListTile<HelpType>(
        value: value,
        groupValue: _helpType,
        onChanged: (v) => setState(() => _helpType = v),
        title: Text(label),
        dense: true,
        visualDensity: const VisualDensity(vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _emailRow(double rowHeight) {
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          Radio<ContactType>(
            value: ContactType.email,
            groupValue: _contactType,
            onChanged: (v) => setState(() => _contactType = ContactType.email),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(vertical: -4),
          ),
          const Text('Email'),
        ],
      ),
    );
  }

  Widget _phoneRow(double rowHeight) {
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          Radio<ContactType>(
            value: ContactType.phone,
            groupValue: _contactType,
            onChanged: (v) => setState(() => _contactType = ContactType.phone),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(vertical: -4),
          ),
          Expanded(
            child:
                _contactType == ContactType.phone
                    ? TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: 'Telefoonnummer',
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                    )
                    : const Text('Telefoon'),
          ),
        ],
      ),
    );
  }
}
