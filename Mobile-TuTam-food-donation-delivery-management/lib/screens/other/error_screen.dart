import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error,color: Colors.red,size: 50,),
              const Text('Hệ thống đang gặp lỗi', style: TextStyle(color: Colors.red),),
              const SizedBox(height: 40,),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>( Colors.red)
                ),
                child: const Text('Quay lại',style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      ),
    );
  }
}