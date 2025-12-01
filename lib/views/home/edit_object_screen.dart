import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/object_controller.dart';
import '../../models/api_object_model.dart';
import '../../utils/validators.dart';

/// Screen for editing an existing API object
class EditObjectScreen extends GetView<ObjectController> {
  const EditObjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiObject object = Get.arguments as ApiObject;
    // Populate controller fields from the passed object
    controller.setSelectedObject(object);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Object'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions card
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.orange[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Update the fields below to modify this object',
                            style: TextStyle(color: Colors.orange[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ID display (read-only)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Object ID',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          object.id ?? 'N/A',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Name field
                const SizedBox(height: 8),

                // Structured fields
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name *',
                    hintText: 'Enter object name',
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: Validators.validateObjectName,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    hintText: 'e.g. blue',
                    prefixIcon: Icon(Icons.palette_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity',
                    hintText: 'e.g. 256 GB',
                    prefixIcon: Icon(Icons.sd_storage_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'e.g. 999',
                    prefixIcon: Icon(Icons.attach_money_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Advanced JSON section (optional)
                ExpansionTile(
                  initiallyExpanded: false,
                  leading: const Icon(Icons.code),
                  title: const Text('Advanced: Additional Data (JSON)'),
                  subtitle: const Text('Optional. Use to add custom key-value pairs'),
                  children: [
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.dataController,
                      decoration: const InputDecoration(
                        labelText: 'Data (JSON)',
                        hintText: '{"warranty": "1 year", "weight": 1.2}',
                        alignLabelWithHint: true,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        return Validators.validateJson(v);
                      },
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                const SizedBox(height: 24),

                // JSON format help
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outline, size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 8),
                          Text(
                            'JSON Format Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Use double quotes for keys and string values\n'
                        '• Separate key-value pairs with commas\n'
                        '• Example: {"key1": "value1", "key2": 123}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Update button
                Obx(() => ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : () => controller.updateObject(object.id!),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isUpdating.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Update Object',
                              style: TextStyle(fontSize: 16),
                            ),
                    )),
                const SizedBox(height: 16),

                // Cancel button
                OutlinedButton(
                  onPressed: () {
                    controller.clearForm();
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
