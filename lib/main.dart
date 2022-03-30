import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/repository/auth_repository.dart';
import 'package:flutterapp/state/auth_state.dart';
import 'package:flutterapp/view/HomePage.dart';
import 'package:flutterapp/view/LoginPage.dart';
import 'blocs/auth_bloc.dart';
import 'event/auth_event.dart';
import 'view/LoginPage.dart';

void main(List<String> args) {
  final AuthRepository authRepository = AuthRepository();
  runApp(BlocProvider(
    create: (context) {
      return AuthBloc(authRepository: authRepository);
    },
    child: App(
      authRepository: authRepository,
      authBloc: AuthBloc(authRepository: authRepository),
    ),
  ));
}

class App extends StatelessWidget {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  const App({Key? key, required this.authRepository, required this.authBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder(
        bloc: authBloc,
        builder: (context, AuthState state) {
          if (state is AuthInit) {
            authBloc.add(AuthCheck());
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is AuthHasToken || state is AuthData)
            return HomePage(
              authBloc: authBloc,
            );
          if (state is AuthFailed || state is LoginFailed)
            return LoginPage(authBloc: authBloc);
          if (state is AuthLoading)
            return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            );
          return Container();
        },
      ),
    );
  }
}
