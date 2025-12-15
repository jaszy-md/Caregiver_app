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
    final payload = {
      'helpType': _helpType?.name,
      'contactType': _contactType.name,
      'phone': _contactType == ContactType.phone ? _phoneController.text : null,
    };

    debugPrint(payload.toString());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Verzoek verstuurd')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9F1F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waar heeft u hulp bij nodig?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          _helpRadio('Ketting verbinden', HelpType.ketting),
          _helpRadio('Mantelzorger verbinden', HelpType.mantelzorger),
          _helpRadio('Rol aanpassen', HelpType.rol),
          _helpRadio('Anders', HelpType.anders),

          const SizedBox(height: 12),

          const Text(
            'Hoe kunnen we u bereiken?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          _emailRow(),
          _phoneRow(),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _canSubmit ? _submit : null,
              icon: const Icon(Icons.send),
              label: const Text('Verstuur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3F42),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpRadio(String label, HelpType value) {
    return SizedBox(
      height: 36,
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

  Widget _emailRow() {
    return SizedBox(
      height: 40,
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

  Widget _phoneRow() {
    return SizedBox(
      height: 40,
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
