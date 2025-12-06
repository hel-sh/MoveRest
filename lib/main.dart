import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/day_model.dart';
import 'model/day_list_manager.dart';
import 'screen/home_screen.dart';
import 'screen/day_detail_screen.dart';
import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final dayListManager = await DayListManager.create();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: dayListManager)],
      child: MyApp(dayListManager: dayListManager),
    ),
  );
}

class MyApp extends StatelessWidget {
  final DayListManager dayListManager;

  const MyApp({super.key, required this.dayListManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Move Rest',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey.shade800,

          surface: Colors.grey.shade100,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: Consumer<DayListManager>(
        builder: (context, manager, child) {
          return MultiProvider(
            providers: manager.dayModels
                .map((model) => ChangeNotifierProvider.value(value: model))
                .toList(),
            child: const HomeScreen(),
          );
        },
      ),
      routes: {
        '/detail': (context) {
          final model = ModalRoute.of(context)!.settings.arguments as DayModel;
          return ChangeNotifierProvider.value(
            value: model,
            child: const DayDetailScreen(),
          );
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
