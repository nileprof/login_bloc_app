import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../bloc/settings_bloc.dart'; // استيراد SettingsBloc

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              context.read<SettingsBloc>().add(ToggleTheme());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('فشل تسجيل الدخول')),
              );
            } else if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
              );
            }
          },
          child: Column(
            children: [
              TextField(
                onChanged: (email) => loginBloc.add(EmailChanged(email)),
                decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (password) =>
                    loginBloc.add(PasswordChanged(password)),
                obscureText: true,
                decoration: InputDecoration(labelText: 'كلمة السر'),
              ),
              SizedBox(height: 24),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state.isSubmitting) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      loginBloc.add(LoginSubmitted());
                    },
                    child: Text('تسجيل الدخول'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
