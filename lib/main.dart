import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/aether_config.dart';
import 'services/vpn_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/logs_screen.dart';
import 'screens/update_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('user_locale') ?? 'fa';

  runApp(AetherApp(initialLocale: savedLocale));
}

class AetherApp extends StatefulWidget {
  final String initialLocale;

  const AetherApp({super.key, required this.initialLocale});

  @override
  State<AetherApp> createState() => _AetherAppState();
}

class _AetherAppState extends State<AetherApp> {
  late String _currentLocale;
  final AetherConfig _config = AetherConfig();
  final VpnServiceController _vpnController = VpnServiceController();

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.initialLocale;
  }

  void _changeLocale(String newLocale) async {
    setState(() {
      _currentLocale = newLocale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_locale', newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aether',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: Locale(_currentLocale),
      supportedLocales: const [
        Locale('en', ''),
        Locale('fa', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(
                config: _config,
                vpnController: _vpnController,
                currentLocale: _currentLocale,
                onLocaleChanged: _changeLocale,
              ),
              SettingsScreen(
                config: _config,
                locale: _currentLocale,
                onConfigChanged: () => setState(() {}),
              ),
              LogsScreen(
                vpnController: _vpnController,
                locale: _currentLocale,
              ),
              UpdateScreen(
                vpnController: _vpnController,
                locale: _currentLocale,
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: const Color(0xFF0B0E14),
            child: const TabBar(
              indicatorColor: Color(0xFF00E5FF),
              labelColor: Color(0xFF00E5FF),
              unselectedLabelColor: Color(0xFF8B949E),
              tabs: [
                Tab(icon: Icon(Icons.shield_outlined), label: 'Tunnel'),
                Tab(icon: Icon(Icons.tune_rounded), label: 'Config'),
                Tab(icon: Icon(Icons.terminal_rounded), label: 'Logs'),
                Tab(icon: Icon(Icons.system_update_rounded), label: 'Updates'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
