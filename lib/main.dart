import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/day_model.dart';
import 'screen/home_screen.dart';
import 'screen/day_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dayNames = [
    'Selasa', 'Rabu', 'Jumat', 'Sabtu', 'Cardio', 'Stretch'
  ];

  final allDays = await Future.wait(
    dayNames.map((day) => DayModel.create(dayName: day)).toList(),
  );

  runApp(
    MultiProvider(
      providers: allDays.map((model) => ChangeNotifierProvider.value(value: model)).toList(),
      child: MyApp(allDays: allDays),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<DayModel> allDays;

  const MyApp({super.key, required this.allDays});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Move Rest',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Colors.black,
            secondary: Colors.grey.shade800,
            background: Colors.white,
            surface: Colors.grey.shade100,
          ),
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          )
      ),
      home: Provider.value(
        value: allDays,
        child: const HomeScreen(),
      ),
      routes: {
        '/detail': (context) {
          final dayModel = ModalRoute.of(context)!.settings.arguments as DayModel;
          return ChangeNotifierProvider.value(
            value: dayModel,
            child: const DayDetailScreen(),
          );
        },
      },
    );
  }
}
