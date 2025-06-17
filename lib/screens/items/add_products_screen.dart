import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/item.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final langSi = context.watch<SettingsProvider>().language == 'si';

    String tr(String en, String si) => langSi ? si : en;

    return Scaffold(
      appBar: AppBar(title: Text(tr('Add Product', 'භාණ්ඩ එකතු කරනවා'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: tr('Product Name', 'භාණ්ඩ නාමය'),
                  prefixIcon: const Icon(Icons.comment),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? tr('Required', 'අවශ්‍යයි')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceCtrl,
                decoration: InputDecoration(
                  labelText: tr('Selling Price (Rs.)', 'මිල (රු.)'),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val <= 0) {
                    return tr('Enter valid price', 'මිල හරියට ඇතුළු කරන්න');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockCtrl,
                decoration: InputDecoration(
                  labelText: tr('Stock (optional)', 'තොගය (අමතර)'),
                  prefixIcon: const Icon(Icons.inventory),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final item = Item(
                    id: const Uuid().v4(),
                    name: _nameCtrl.text.trim(),
                    price: double.parse(_priceCtrl.text),
                    stock: int.tryParse(_stockCtrl.text) ?? 0,
                  );
                  context.read<ItemProvider>().addItem(item);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr('Product saved', 'භාණ්ඩය සුරකින ලදි')),
                    ),
                  );
                },
                child: Text(tr('Save', 'සුරකින්න')),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(tr('Cancel', 'අවලංගු')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
