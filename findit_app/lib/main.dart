import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const FindItApp());
}

final _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (ctx, state) => const OnboardingScreen()),
    ShellRoute(
      builder: (ctx, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (ctx, state) => const HomeScreen()),
        GoRoute(path: '/saved', builder: (ctx, state) => const SavedScreen()),
        GoRoute(path: '/profile', builder: (ctx, state) => const ProfileScreen()),
      ],
    ),
    GoRoute(
      path: '/product/:resultId',
      builder: (ctx, state) => ProductDetailScreen(resultId: state.pathParameters['resultId']!),
    ),
  ],
);

class FindItApp extends StatelessWidget {
  const FindItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FindIt',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A0A0A),
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFFAF9F7),
          onSurface: const Color(0xFF0A0A0A),
          primary: const Color(0xFF0A0A0A),
          secondary: const Color(0xFFD4A853),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF9F7),
        fontFamily: 'DM Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF9F7),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Syne',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0A0A0A),
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _tabs = ['/home', '/saved', '/profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F7),
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.08), width: 1)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            setState(() => _currentIndex = i);
            context.go(_tabs[i]);
          },
          indicatorColor: const Color(0xFF0A0A0A),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded),
              selectedIcon: Icon(Icons.grid_view_rounded, color: Colors.white),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border_rounded),
              selectedIcon: Icon(Icons.bookmark_rounded, color: Colors.white),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: Colors.white),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
