import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarakel/auth/auth_controller.dart';

class GoogleSignInButton extends ConsumerWidget {
  void google(WidgetRef ref) {
    ref.read(AuthControllerProvider).SignInWithGoogle();
  }

  const GoogleSignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => google(ref),
      child: Text(
        'Continue with Google',
        style: TextStyle(color: Colors.black),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 244, 236, 236),
        ),
      ),
    );
  }
}
