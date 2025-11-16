import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Generic Text Field Widget (uses InputDecorationTheme)
Widget textFieldWidget({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  String? Function(String?)? validator,
  String? label,
  TextInputType inputType = TextInputType.text,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colorScheme.onSurface.withOpacity(0.8)),
          labelText: label ?? hint,
          hintText: hint,
        ),
      );
    },
  );
}

/// Password Text Field Widget (uses InputDecorationTheme)
Widget textFieldPasswordWidget({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  required RxBool isObsure,
  String? Function(String?)? validator,
  String? label,
  TextInputType inputType = TextInputType.visiblePassword,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Obx(
        () => TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: isObsure.value,
          validator: validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
            labelText: label ?? hint,
            hintText: hint,

            suffixIcon: IconButton(
              icon: Icon(
                isObsure.value ? Icons.visibility_off : Icons.visibility,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              onPressed: () => isObsure.value = !isObsure.value,
            ),
          ),
        ),
      );
    },
  );
}
