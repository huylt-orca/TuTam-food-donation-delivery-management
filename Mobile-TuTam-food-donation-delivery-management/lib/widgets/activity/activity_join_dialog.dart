import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/activity_role.dart';
import 'package:food_donation_delivery_app/services/activity_member_service.dart';
import 'package:food_donation_delivery_app/services/activity_role_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';

class ActivityJoinDialog extends StatefulWidget {
  final String activityId;
  const ActivityJoinDialog({
    super.key,
    required this.activityId
    });

  @override
  State<ActivityJoinDialog> createState() => _ActivityJoinDialogState();
}

class _ActivityJoinDialogState extends State<ActivityJoinDialog> {
  final TextEditingController _txtDescription = TextEditingController();
  List<ActivityRole> _roles = List.empty(growable: true);
  ActivityRole _selectedRole = ActivityRole(
    id: '',
    activityId: '',
    name: '',
    description: '',
    isDefault: false,
    status: ''
  );
  String _messageError = '';

  void _getData(){
    ActivityRoleService.fetchActivityRoleList(activityId: widget.activityId)
    .then((value){
      _roles = value;
      if (value.isNotEmpty){
      setState(() {
        _selectedRole = value[0];
      });}
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Tham gia hoạt động',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppTheme.primaryFirst)
          ),
          child: const Text('Tham gia', style: TextStyle(color: Colors.white),),
          onPressed: () async {
            try {
              if (_txtDescription.text.length > 500){
                _messageError = 'Độ dài của lý do tham gia phải ngắn hơn 500 ký tự';
              } else {
                DialogHelper.showLoading(context);
              
               bool isSuccess = await ActivityMemberService.sendApplicationToActivity(
              activityId: widget.activityId, 
              roleId: _selectedRole.id, 
              description: _txtDescription.text);

               if (!context.mounted) return ;
            DialogHelper.hideLoading(context);

            if (isSuccess){
              Fluttertoast.showToast(
                msg: 'Gửi thành công',
                gravity: ToastGravity.CENTER
                );
            } else {
              Fluttertoast.showToast(
                msg: 'Gửi thất bại',
                gravity: ToastGravity.CENTER
                );
            }
              }
            } catch (e){
              DialogHelper.hideLoading(context);
              DialogHelper.showAwesomeDialogError(context, e.toString());
              
            }
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(15)),
            child: DropdownButton<ActivityRole>(
              value: _selectedRole,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              itemHeight: 70,
              onChanged: (ActivityRole? value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
              items: _roles.map<DropdownMenuItem<ActivityRole>>((ActivityRole value) {
                return DropdownMenuItem<ActivityRole>(
                  value: value,
                  child: ListTile(
                    title: Text(value.name),
                    subtitle: Text(value.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            maxLines: 4,
            controller: _txtDescription,
            decoration: const InputDecoration(
              label: Text("Lý do tham gia"),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          _messageError.isEmpty ? const SizedBox():
           Text(_messageError, style: const TextStyle(color: Colors.red),)
        ],
      ),
    );
  }
}
