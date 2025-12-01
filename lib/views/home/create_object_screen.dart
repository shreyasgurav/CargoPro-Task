import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/object_controller.dart';
import '../../utils/validators.dart';

/// Screen for creating a new API object
class CreateObjectScreen extends GetView<ObjectController> {
  const CreateObjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Object'),
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
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Fill in the details below to create a new object',
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Name field
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

                // Color field
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

                // Capacity field
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

                // Price field
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

                // Advanced section: Additional Data (JSON)
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

                // Submit button
                Obx(() => ElevatedButton(
                      onPressed: controller.isCreating.value
                          ? null
                          : controller.createObject,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isCreating.value
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
                              'Create Object',
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
