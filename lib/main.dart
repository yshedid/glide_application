import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glide/features/home/view/layout_screen.dart';
import 'package:glide/features/splash/view/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/viewmodel/auth_cubit.dart';
import 'features/home/viewmodel/layout_cubit/layout_cubit.dart';
import 'features/on_boarding/view/on_boarding.dart';
import 'features/search/view/search_results_screen.dart';
import 'features/search/view/search_screen.dart';

void main() async {
  await Supabase.initialize(
    url: "https://jbcxkggbaxqfncplsuzi.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXB"
        "hYmFzZSIsInJlZiI6ImpiY3hrZ2diYXhxZm5jcGxzdXppIiwicm9sZ"
        "SI6ImFub24iLCJpYXQiOjE3NTQ3MzQ0NDIsImV4cCI6MjA3MDMxMDQ0"
        "Mn0.gvS6W2zl9UXDjpa7TjQqVNZiaXoUlVJ5yGMMJON41xs",
  );
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(create:  (context) => LayoutCubit(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
