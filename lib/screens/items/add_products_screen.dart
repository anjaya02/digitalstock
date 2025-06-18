
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/item.dart';
import '../../providers/item_provider.dart';
import '../../providers/settings_provider.dart';

/// Re‑usable screen for *adding* **or** *editing* a product.
/// If [existing] is supplied we pre‑fill the form and update the record
/// instead of creating a new `Item`.
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.existing});
  final Item? existing;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: widget.existing?.name ?? '');
    _priceCtrl = TextEditingController(
      text: widget.existing != null ? widget.existing!.price.toString() : '');
    _stockCtrl = TextEditingController(
      text: widget.existing != null ? widget.existing!.stock.toString() : '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langSi = context.watch<SettingsProvider>().language == 'si';
    String tr(String en, String si) => langSi ? si : en;
    final editing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(tr(editing ? 'Edit Product' : 'Add Product',
          editing ? 'භාණ්ඩ සංස්කරණය' : 'භාණ්ඩ එකතු කරනවා'))),
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

                  final id = widget.existing?.id ?? const Uuid().v4();
                  final item = Item(
                    id: id,
                    name: _nameCtrl.text.trim(),
                    price: double.parse(_priceCtrl.text),
                    stock: int.tryParse(_stockCtrl.text) ?? 0,
                  );
                  final prov = context.read<ItemProvider>();
                  if (editing) {
                    prov.updateItem(
                      id,
                      name: item.name,
                      price: item.price,
                      stock: item.stock,
                    );
                  } else {
                    prov.addItem(item);
                  }
                  Navigator.pop(context, item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr(
                          editing ? 'Product updated' : 'Product saved',
                          editing ? 'භාණ්ඩය යාවත්කාලින කරන ලදි' : 'භාණ්ඩය සුරකින ලදි')),
                    ),
                  );
                },
                child: Text(tr(editing ? 'Update' : 'Save',
                    editing ? 'යාවත්කාලින' : 'සුරකින්න')),
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
