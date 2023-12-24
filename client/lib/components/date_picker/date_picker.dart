import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:hyper_tools/components/date_picker/date_picker_provider.dart';
import 'package:hyper_tools/helpers/date_helper.dart';
import 'package:provider/provider.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    required this.onSelected,
    super.key,
    this.label,
    this.initialDate,
  });

  final FutureOr<bool> Function(DateTime date) onSelected;
  final String? label;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<DatePickerProvider>(
        create: (_) => DatePickerProvider(initialDate: initialDate),
        child: _DatePickerBuilder(
          onSelected: onSelected,
          label: label,
        ),
      );
}

class _DatePickerBuilder extends StatelessWidget {
  const _DatePickerBuilder({
    required this.onSelected,
    this.label,
  });

  final FutureOr<bool> Function(DateTime date) onSelected;
  final String? label;

  Future<void> _onClick(BuildContext context) async {
    final DatePickerProvider provider = context.read<DatePickerProvider>();

    final DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1000)),
      lastDate: DateTime.now().add(const Duration(days: 1000)),
      initialDate: provider.date ?? DateTime.now(),
    );

    if (newDate != null &&
        newDate != provider.date &&
        await onSelected(newDate)) provider.date = newDate;
  }

  Widget _button(BuildContext context) {
    final DateTime? selectedDate =
        context.select<DatePickerProvider, DateTime?>(
      (DatePickerProvider provider) => provider.date,
    );

    final bool isOpen = context.select<DatePickerProvider, bool>(
      (DatePickerProvider provider) => provider.isOpen,
    );

    return InkWell(
      onTap: () async => _onClick(context),
      child: InputDecorator(
        isFocused: isOpen,
        isEmpty: selectedDate == null,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          labelText: label,
          prefixIcon: const Icon(Boxicons.bx_calendar),
        ),
        child: selectedDate != null
            ? Text(DateHelper.formatDateToFrench(selectedDate))
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _button(context);
}