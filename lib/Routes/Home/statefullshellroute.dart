import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:collection/collection.dart';

part 'statefullshellroute.g.dart';

class Notification {
  static final routes = $appRoutes;
}

void statefullshellroute() => runApp(App());

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: _router,
      );

  final GoRouter _router = GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: true,
    initialLocation: '/home',
  );
}

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRouteData>(
          path: '/home',
        ),
      ],
    ),
    TypedStatefulShellBranch<NotificationsShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<NotificationsRouteData>(
          path: '/notifications/:section',
        ),
      ],
    ),
    TypedStatefulShellBranch<OrdersShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<OrdersRouteData>(
          path: '/orders',
        ),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  static const String $restorationScopeId = 'restorationScopeId';

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainPageView(
      navigationShell: navigationShell,
    );
  }

  // static Widget $navigatorContainerBuilder(
  //     BuildContext context, StatefulNavigationShell navigationShell, List<Widget> children) {
  //   return ScaffoldWithNavBar(
  //     navigationShell: navigationShell,
  //     children: children,
  //   );
  // }

  static Widget $navigatorContainerBuilder(
      BuildContext context, StatefulNavigationShell navigationShell, List<Widget> children) {
    return TabbedScaffold(
      key: ValueKey(navigationShell.currentIndex),
      navigationShell: navigationShell,
      children: children,
    );
  }

  // static Widget $navigatorContainerBuilder(
  //     BuildContext context, StatefulNavigationShell navigationShell, List<Widget> children) {
  //   return children[navigationShell.currentIndex];
  // }
}

class HomeShellBranchData extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = _sectionANavigatorKey;
  static const String $restorationScopeId = 'restorationScopeId';
  const HomeShellBranchData();
}

class NotificationsShellBranchData extends StatefulShellBranchData {
  const NotificationsShellBranchData();

  static String $initialLocation = '/notifications/old';
}

class OrdersShellBranchData extends StatefulShellBranchData {
  const OrdersShellBranchData();
}

class HomeRouteData extends GoRouteData {
  const HomeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePageView(label: 'Home page');
  }
}

enum NotificationsPageSection {
  latest,
  old,
  archive,
}

class NotificationsRouteData extends GoRouteData {
  const NotificationsRouteData({
    required this.section,
  });

  final NotificationsPageSection section;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NotificationsPageView(
      key: ValueKey(section),
      section: section,
    );
  }
}

class OrdersRouteData extends GoRouteData {
  const OrdersRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OrdersPageView(label: 'Orders page');
  }
}

class MainPageView extends StatelessWidget {
  const MainPageView({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text(label),
        onPressed: () {
          context.go('/notifications/archive');
        },
      ),
    );
  }
}

class NotificationsPageView extends StatefulWidget {
  const NotificationsPageView({
    super.key,
    required this.section,
  });

  final NotificationsPageSection section;

  @override
  State<NotificationsPageView> createState() => _NotificationsPageViewState();
}

class _NotificationsPageViewState extends State<NotificationsPageView> with SingleTickerProviderStateMixin {
  late final TabController tabcon;

  @override
  void initState() {
    tabcon = TabController(
      length: 3,
      initialIndex: NotificationsPageSection.values.indexWhere((element) => element == widget.section),
      vsync: this,
    );

    print(
        '---------${widget.section}  ${NotificationsPageSection.values.indexWhere((element) => element == widget.section)}');

    tabcon.addListener(goTo);

    super.initState();
  }

  void goTo() {
    if (!tabcon.indexIsChanging) {
      context.go('/notifications/${NotificationsPageSection.values[tabcon.index].name}');
    }
  }

  @override
  void dispose() {
    tabcon.removeListener(goTo);
    tabcon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: tabcon,
          tabs: <Tab>[
            Tab(
              child: Text(
                'Latest',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            Tab(
              child: Text(
                'Old',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            Tab(
              child: Text(
                'Archive',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabcon,
            children: <Widget>[
              NotificationsSubPageView(
                label: 'Latest notifications',
              ),
              NotificationsSubPageView(
                label: 'Old notifications',
              ),
              NotificationsSubPageView(
                label: 'Archived notifications',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NotificationsSubPageView extends StatefulWidget {
  const NotificationsSubPageView({
    required this.label,
    super.key,
  });

  final String label;

  @override
  State<NotificationsSubPageView> createState() => _NotificationsSubPageViewState();
}

class _NotificationsSubPageViewState extends State<NotificationsSubPageView> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            count++;
          });
        },
        child: Text('${widget.label} $count'),
      ),
    );
  }
}

class OrdersPageView extends StatelessWidget {
  const OrdersPageView({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label),
    );
  }
}

///////////////////

final GlobalKey<NavigatorState> _sectionANavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'sectionANav',
);

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  /// The children (branch Navigators) to display in a custom container
  /// ([AnimatedBranchContainer]).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBranchContainer(
        currentIndex: navigationShell.currentIndex,
        children: children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Here, the items of BottomNavigationBar are hard coded. In a real
        // world scenario, the items would most likely be generated from the
        // branches of the shell route, which can be fetched using
        // `navigationShell.route.branches`.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Section A'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Section B'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Section C'),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

/// Custom branch Navigator container that provides animated transitions
/// when switching branches.
class AnimatedBranchContainer extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer({super.key, required this.currentIndex, required this.children});

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children.mapIndexed(
        (int index, Widget navigator) {
          return AnimatedScale(
            scale: index == currentIndex ? 1 : 1.5,
            duration: const Duration(milliseconds: 400),
            child: AnimatedOpacity(
              opacity: index == currentIndex ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: _branchNavigatorWrapper(index, navigator),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}

class TabbedScaffold extends StatefulWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const TabbedScaffold({
    required this.navigationShell,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  /// The children (branch Navigators) to display in a custom container
  /// ([AnimatedBranchContainer]).
  final List<Widget> children;

  @override
  State<TabbedScaffold> createState() => _TabbedScaffoldState();
}

class _TabbedScaffoldState extends State<TabbedScaffold> with SingleTickerProviderStateMixin {
  late final TabController tabcon;

  @override
  void initState() {
    tabcon = TabController(
      length: 3,
      initialIndex: widget.navigationShell.currentIndex,
      vsync: this,
    );

    print('+++++++');

    tabcon.addListener(goTo);

    super.initState();
  }

  void goTo() {
    if (!tabcon.indexIsChanging) {
      widget.navigationShell.goBranch(
        tabcon.index,
        initialLocation: tabcon.index == widget.navigationShell.currentIndex,
      );
    }
  }

  @override
  void dispose() {
    tabcon.removeListener(goTo);
    tabcon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.children.length.toString()),
          Text(widget.navigationShell.route.branches.map((e) => e.defaultRoute?.path.toString() ?? '-').toString()),
          // Expanded(
          //   child: widget.children[widget.navigationShell.currentIndex],
          // ),
          // TabBar(
          //   controller: tabcon,
          //   tabs: widget.navigationShell.route.branches
          //       .map(
          //         (e) => Tab(
          //           child: Text(e.defaultRoute?.path ?? '-'),
          //         ),
          //       )
          //       .toList(),
          // ),
          Expanded(
            child: TabBarView(
              controller: tabcon,
              children: widget.children,
            ),
          )
        ],
      ),
    );
  }
}
