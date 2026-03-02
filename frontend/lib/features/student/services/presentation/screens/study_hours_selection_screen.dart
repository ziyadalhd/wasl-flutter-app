import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/components/primary_button.dart';

class DaySchedule {
  final String dayName;
  bool isSelected;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  DaySchedule({
    required this.dayName,
    this.isSelected = false,
    this.startTime,
    this.endTime,
  });
}

class StudyHoursSelectionScreen extends StatefulWidget {
  const StudyHoursSelectionScreen({super.key});

  @override
  State<StudyHoursSelectionScreen> createState() =>
      _StudyHoursSelectionScreenState();
}

class _StudyHoursSelectionScreenState extends State<StudyHoursSelectionScreen> {
  final List<DaySchedule> _days = [
    DaySchedule(dayName: 'الأحد'),
    DaySchedule(dayName: 'الاثنين'),
    DaySchedule(dayName: 'الثلاثاء'),
    DaySchedule(dayName: 'الأربعاء'),
    DaySchedule(dayName: 'الخميس'),
  ];

  bool _isValid() {
    bool hasSelectedDay = _days.any((d) => d.isSelected);
    if (!hasSelectedDay) return false;

    // If at least one day is selected, we need to ensure ALL selected days have valid times.
    for (var day in _days) {
      if (day.isSelected) {
        if (day.startTime == null || day.endTime == null) return false;
        if (day.startTime!.hour >= day.endTime!.hour) return false;
      }
    }

    // If we passed all checks for selected days, it's valid.
    return true;
  }

  bool _hasError(DaySchedule day) {
    if (!day.isSelected) return false;
    if (day.startTime != null && day.endTime != null) {
      return day.startTime!.hour >= day.endTime!.hour;
    }
    return false;
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'اختر الوقت';
    final int hour = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final String period = time.hour >= 12 ? 'م' : 'ص';
    return '$hour:00 $period';
  }

  Future<void> _selectTime(
    BuildContext context,
    DaySchedule schedule,
    bool isStart,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (schedule.startTime ?? const TimeOfDay(hour: 8, minute: 0))
          : (schedule.endTime ?? const TimeOfDay(hour: 14, minute: 0)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textColor,
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        final time = TimeOfDay(hour: picked.hour, minute: 0);
        if (isStart) {
          schedule.startTime = time;
        } else {
          schedule.endTime = time;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const BackButton(color: Colors.black),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: PrimaryButton(
              text: 'متابعة للدفع',
              onPressed: _isValid()
                  ? () {
                      context.push('/payment', extra: false);
                    }
                  : null,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'حدد أوقات دوامك',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'اختر الأيام وساعات الدوام ليتم تنسيق الذهاب والعودة مع السائق.',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ..._days.map((day) => _buildDayCard(day)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(DaySchedule day) {
    final bool hasError = _hasError(day);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: day.isSelected
            ? AppTheme.primaryColor.withValues(alpha: 0.03)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: day.isSelected
              ? (hasError
                    ? Colors.red
                    : AppTheme.primaryColor.withValues(alpha: 0.3))
              : Colors.grey[200]!,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day.dayName,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: day.isSelected
                      ? FontWeight.bold
                      : FontWeight.w600,
                  color: day.isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textColor,
                ),
              ),
              Switch(
                value: day.isSelected,
                activeThumbColor: AppTheme.primaryColor,
                onChanged: (val) {
                  setState(() {
                    day.isSelected = val;
                    if (!val) {
                      day.startTime = null;
                      day.endTime = null;
                    }
                  });
                },
              ),
            ],
          ),
          if (day.isSelected) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Colors.grey[200], height: 1),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTimeSelector(
                    label: 'بداية الدوام',
                    time: day.startTime,
                    onTap: () => _selectTime(context, day, true),
                    hasError: hasError,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeSelector(
                    label: 'نهاية الدوام',
                    time: day.endTime,
                    onTap: () => _selectTime(context, day, false),
                    hasError: hasError,
                  ),
                ),
              ],
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'وقت البداية يجب أن يكون قبل وقت النهاية',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
    required bool hasError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: hasError
                  ? Colors.red.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? Colors.red.withValues(alpha: 0.5)
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: time != null ? AppTheme.textColor : Colors.grey[400],
                  ),
                ),
                Icon(
                  Icons.access_time_rounded,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
