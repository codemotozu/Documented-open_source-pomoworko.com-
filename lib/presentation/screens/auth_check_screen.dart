

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../notifiers/providers.dart';
// import '../pages/1.app_bar_pomodoro/analytics/cartesian_chart.dart';
// import '../pages/1.app_bar_pomodoro/analytics/not_login_cartesian_chart.dart';
// import '../pages/1.app_bar_pomodoro/premium_analytics/cartesian_premium.dart';
// import '../repository/auth_repository.dart';
// import '../repository/local_storage_repository.dart';

// class AuthCheckScreen extends ConsumerStatefulWidget {
//   const AuthCheckScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AuthCheckScreenState();
// }

// class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
//   @override
//   void initState() {
//     super.initState();
//     checkAuthStatus();
//   }

//   Future<void> checkAuthStatus() async {
//     final localStorageRepository = ref.read(localStorageRepositoryProvider);
//     final token = await localStorageRepository.getToken();
//     final isPremium = await localStorageRepository.getIsPremium();

//     if (token != null && token.isNotEmpty) {
//       // Si hay un token, intentar obtener los datos del usuario
//       final errorModel = await ref.read(authRepositoryProvider).getUserData();
//       if (errorModel.data != null) {
//         ref.read(userProvider.notifier).update((state) => errorModel.data);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, watch, child) {
//         final user = ref.watch(userProvider);
        
//         // Si el usuario está cargando, mostrar un indicador de carga
//         if (user == null) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         // Una vez que tenemos el estado del usuario
//         if (user.token.isNotEmpty) {
//           if (user.isPremium) {
//             return const CartesianPremiumChart(title: '');
//           } else {
//             return const CartesianChart(title: '');
//           }
//         }

//         // Si no hay token o el usuario no está autenticado
//         return const NotLoginCartesianChart(title: '');
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/providers.dart';
import '../pages/1.app_bar_pomodoro/analytics/cartesian_chart.dart';
import '../pages/1.app_bar_pomodoro/analytics/not_login_cartesian_chart.dart';
import '../pages/1.app_bar_pomodoro/premium_analytics/cartesian_premium.dart';
import '../repository/auth_repository.dart';
import '../repository/local_storage_repository.dart';

class AuthCheckScreen extends ConsumerStatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
  bool isLoading = true; // Add a loading flag

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final localStorageRepository = ref.read(localStorageRepositoryProvider);
    final token = await localStorageRepository.getToken();

    if (token != null && token.isNotEmpty) {
      final errorModel = await ref.read(authRepositoryProvider).getUserData();
      if (errorModel.data != null) {
        ref.read(userProvider.notifier).update((state) => errorModel.data);
      }
    }

    setState(() {
      isLoading = false; // Stop loading once the authentication status is determined
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
         ? Container(
          color: Colors.black, // Ensure a white background
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white, // Set loading indicator to black for visibility
            ),
          ),
        )
        : Consumer(
            builder: (context, watch, child) {
              final user = ref.watch(userProvider);

              if (user == null || user.token.isEmpty) {
                // User not logged in or no token
                return const NotLoginCartesianChart(title: '');
              }

              if (user.isPremium) {
                return const CartesianPremiumChart(title: '');
              } else {
                return const CartesianChart(title: '');
              }
            },
          );
  }
}
