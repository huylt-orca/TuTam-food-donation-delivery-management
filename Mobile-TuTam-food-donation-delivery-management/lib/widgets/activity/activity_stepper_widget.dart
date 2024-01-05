import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/activity_phase.dart';
import 'package:food_donation_delivery_app/services/activity_phase_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

enum StepEnabling { sequential, individual }

class ActivityStepperWidget extends StatefulWidget {
  final String activityId;
  const ActivityStepperWidget({super.key, required this.activityId});

  @override
  State<ActivityStepperWidget> createState() => _ActivityStepperWidgetState();
}

class _ActivityStepperWidgetState extends State<ActivityStepperWidget> {
  int activeStep = 0;
  int activeStep2 = 0;
  int reachedStep = 0;
  int upperBound = 5;
  double progress = 0.2;

  List<ActivityPhase> _phases = List.empty(growable: true);

  List<EasyStep> _step() {
    List<EasyStep> stepper = List.empty(growable: true);
    for (var i = 0; i < _phases.length; i++) {
      stepper.add(EasyStep(
        customStep: Opacity(
          opacity: activeStep >= 0 ? 1 : 0.3,
          child: Text('${i + 1}',
          style: TextStyle(
            color: i < activeStep ? Colors.white : Colors.black
          ),
          ),
        ),
        customTitle: Text(
          _phases[i].name,
          textAlign: TextAlign.center,
        ),
      ));
    }

    return stepper;
  }

  void _getData() {
    ActivityPhaseService.fetchActivityPhaseList(activityId: widget.activityId)
        .then((value) {
      setState(() {
        _phases = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return _phases.isEmpty ? const SizedBox()
    : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Giai đoạn',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        EasyStepper(
          activeStep: activeStep,
          lineStyle: const LineStyle(
              lineLength: 50,
              lineType: LineType.normal,
              lineThickness: 3,
              lineSpace: 1,
              lineWidth: 10,
              unreachedLineType: LineType.dashed,
              defaultLineColor: AppTheme.primarySecond,
              unreachedLineColor: AppTheme.primarySecond,
              activeLineColor: AppTheme.primarySecond,
              finishedLineColor: AppTheme.primarySecond),
          stepShape: StepShape.rRectangle,
          stepBorderRadius: 15,
          borderThickness: 2,
          internalPadding: 15,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          stepRadius: 15,
          finishedStepBorderColor: AppTheme.primarySecond,
          finishedStepTextColor: AppTheme.primarySecond,
          finishedStepBackgroundColor: AppTheme.primarySecond,
          activeStepIconColor: AppTheme.primarySecond,
          showLoadingAnimation: false,
          steps: _step(),
          onStepReached: (index) => setState(() => activeStep = index),
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.converDate(_phases[activeStep].startDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text('Bắt đầu')
              ],
            )),
            SizedBox(
                width: 150,
                child: Column(
                  children: [
                    Text(
                      _phases[activeStep].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text('Giai đoạn ${activeStep + 1}')
                  ],
                )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Utils.converDate(_phases[activeStep].endDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Kết thúc')
              ],
            )),
          ],
        ),
      ],
    );
  }
}
