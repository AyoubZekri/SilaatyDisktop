import sys
import codecs

filepath = r'd:\flutter\SilaatyV1\silaaty_desktop\lib\view\widget\user_profile_dialog.dart'

with codecs.open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

index = content.find('class EditProfileDialog extends StatelessWidget {')
if index != -1:
    new_class = """class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Updateusercontroller());
    
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GetBuilder<Updateusercontroller>(
        builder: (controller) {
          return Container(
            width: 700,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: controller.formstate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Premium Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColor.primaryPurple.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: AppColor.primaryPurple.withOpacity(0.2),
                          width: 1,
                        )
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.primaryPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.edit_document,
                                color: AppColor.primaryPurple,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'edit_account'.tr,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white 
                                    : AppColor.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back(),
                          splashRadius: 24,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Picture Section
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColor.primaryPurple.withOpacity(0.3),
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.primaryPurple.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: controller.file != null
                                        ? Image.file(controller.file!, fit: BoxFit.cover)
                                        : Container(
                                            color: Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.grey.shade800 
                                                : Colors.grey.shade100,
                                            child: Icon(Icons.person, size: 60, color: Colors.grey.shade400),
                                          ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.imageupload(),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryPurple,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Theme.of(context).cardColor, width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Form Fields Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade900 
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "personal_info".tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primaryPurple,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.nameController,
                                        label: 'name'.tr,
                                        hint: 'name'.tr,
                                        icon: Icons.person_outline,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.FamlynameController,
                                        label: 'family_name'.tr,
                                        hint: 'family_name'.tr,
                                        icon: Icons.people_outline,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.PhoneController,
                                        label: 'phone'.tr,
                                        hint: 'phone'.tr,
                                        icon: Icons.phone_outlined,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.emailController,
                                        label: 'email_label'.tr,
                                        hint: 'email_hint'.tr,
                                        icon: Icons.email_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.adresseController,
                                        label: 'address'.tr,
                                        hint: 'address'.tr,
                                        icon: Icons.location_on_outlined,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: CustemTextField(
                                        controller: controller.AddressController,
                                        label: 'secondary_address'.tr,
                                        hint: 'secondary_address'.tr,
                                        icon: Icons.map_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Get.back(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: Text(
                                  'cancel'.tr,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  controller.updateuser();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 2,
                                  shadowColor: AppColor.primaryPurple.withOpacity(0.5),
                                ),
                                child: controller.statusrequest == Statusrequest.loadeng
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                      )
                                    : Text(
                                        'save'.tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
"""
    content = content[:index] + new_class
    with codecs.open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
