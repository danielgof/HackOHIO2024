import 'package:app/private/photo_page.dart';
import 'package:app/private/profile_page.dart';
import 'package:app/public/login_page.dart';
import 'package:app/private/messaging_page.dart';
import 'package:app/public/messaging_page.dart';
import 'package:app/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/private/ai_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Wild Health',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 75, 251, 32)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();
    int selectedIndex = appState.pageSate;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = AiPage();
        break;
      case 1:
        page = appState.isAuth == false ? MessagingPagePublic() : ContactsScreen();
        break;
      case 2:
        page = appState.isAuth == false ? LoginPage() : ProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Mobile-friendly layout with BottomNavigationBar
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.auto_awesome),
                        label: 'Ask AI',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.message),
                        label: 'Message',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(appState.isAuth
                            ? Icons.account_circle
                            : Icons.login),
                        label: appState.isAuth ? 'Account' : 'Login',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      appState.setPageSate(value);
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 750,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.auto_awesome),
                        label: Text('Ask AI'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.message),
                        label: Text('Message'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.login),
                        label: Text('Login'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      appState.setPageSate(value);
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
