import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'configs/app_theme.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyA9KHSBDB5GjNU33hwle4vFXw_00soMpaA",
      authDomain: "studychinesetoday-7b129.firebaseapp.com",
      projectId: "studychinesetoday-7b129",
      storageBucket: "studychinesetoday-7b129.appspot.com",
      messagingSenderId: "526387177583",
      appId: "1:526387177583:web:6a406217101828b16a459a",
      measurementId: "G-FP8PC242MC");

  await Firebase.initializeApp(options: firebaseOptions);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
//
// class Manager {
//   final bool isOn;
//
//   Manager({required this.isOn});
//
//   Manager copyWith({bool? on}){
//     return Manager(isOn: on ?? isOn);
//   }
// }
//
// class ManagerStateNotifier extends StateNotifier<Manager> {
//   ManagerStateNotifier(Manager state) : super(state);
//
//   void setOn(bool isOn){
//     state = state.copyWith(on: isOn);
//   }
//
// }
//
// final managerProvider = StateNotifierProvider<ManagerStateNotifier, Manager>((ref) => ManagerStateNotifier(Manager(isOn: false)));
//
// class Test extends ConsumerWidget {
//   const Test({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final Manager manager = ref.watch(managerProvider);
//     final ManagerStateNotifier managerNotifier = ref.watch(managerProvider.notifier);
//
//     return Container(
//       color: Colors.lightBlue,
//       child: ElevatedButton(onPressed: (){
//         managerNotifier.setOn(!manager.isOn);
//       },
//         child: Text(manager.isOn.toString()),),
//     );
//   }
// }
