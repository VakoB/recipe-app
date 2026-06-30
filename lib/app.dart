import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/favorites/presentation/bloc/favorites_cubit.dart';

import 'core/di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/recipes/presentation/pages/recipes_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>(),
      child: MaterialApp(
        title: 'Recipes',
        theme: ThemeData(useMaterial3: true),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthAuthenticated() => BlocProvider<FavoritesCubit>(
            key: ValueKey(state.user.uid),
            create: (_) => sl<FavoritesCubit>(param1: state.user.uid),
            child: const RecipesPage(),
          ),
          AuthUnauthenticated() => const LoginPage(),
          AuthInitial() || AuthLoading() => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          AuthError() => const LoginPage(),
        };
      },
    );
  }
}
