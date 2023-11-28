import 'package:flutter/material.dart';

class RoundedCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>? onTap;

  const RoundedCheckbox({
    Key? key,
    required this.isChecked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call(!isChecked);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: isChecked
            ? const Icon(
                Icons.check,
                size: 14.0,
                color: Colors.green,
              )
            : Container(
                width: 14.0,
                height: 14.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
      ),
    );
  }
}