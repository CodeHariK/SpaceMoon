import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Helpers/shell_data.dart';
import 'package:spacemoon/Routes/Home/home.dart';

class TabShell extends StatefulWidget {
  const TabShell({
    super.key,
    required this.navigationShell,
    required this.children,
    required this.shellData,
    this.showAppbar = true,
    this.showTabbar = false,
    this.showNavigationBar = true,
    this.showDrawer = false,
    this.showNavigationRail = false,
    this.navRailExtend = true,
    this.actions = const [],
    this.canPop = false,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;
  final List<ShellData> shellData;
  final bool showAppbar;
  final bool showTabbar;
  final bool showNavigationBar;
  final bool showNavigationRail;
  final bool navRailExtend;
  final bool showDrawer;
  final List<Widget> actions;
  final bool canPop;

  @override
  State<TabShell> createState() => _TabShellState();
}

class _TabShellState extends State<TabShell> with SingleTickerProviderStateMixin {
  late final TabController tabcon;

  @override
  void initState() {
    super.initState();
    tabcon = TabController(vsync: this, length: widget.shellData.length, initialIndex: 0);

    // print(navigationShell.route.branches.map((e) => e.defaultRoute?.path.toString() ?? '-').toString());
    // print(widget.navigationShell.route.branches.map((e) => e.defaultRoute?.name.toString() ?? '-').toString());

    if (tabcon.index != widget.navigationShell.currentIndex) {
      tabcon.animateTo(widget.navigationShell.currentIndex);
    }

    tabcon.addListener(goTo);
  }

  @override
  void dispose() {
    tabcon.removeListener(goTo);
    tabcon.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TabShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print('did update tabbed scaffold');
    tabcon.index = widget.navigationShell.currentIndex;
  }

  void goTo() {
    if (!tabcon.indexIsChanging && tabcon.index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(tabcon.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabview = TabBarView(
      controller: tabcon,
      children: widget.children,
    );

    Widget childWithTab = (widget.showTabbar)
        ? Column(
            children: [
              if (widget.showTabbar) widget.shellData.tabBar(context: context, controller: tabcon),
              Expanded(
                child: tabview,
              ),
            ],
          )
        : tabview;

    Widget childWithRail = (widget.showNavigationRail)
        ? Row(
            children: [
              if (widget.showNavigationRail)
                widget.shellData.navigationRail(
                  context: context,
                  controller: tabcon,
                  extended: widget.navRailExtend,
                ),
              Expanded(
                child: childWithTab,
              ),
            ],
          )
        : childWithTab;

    return Scaffold(
      appBar: !widget.showAppbar
          ? null
          : AppBar(
              automaticallyImplyLeading: widget.canPop,
              leading: !widget.canPop
                  ? null
                  : BackButton(
                      onPressed: () {
                        HomeRoute().go(context);
                      },
                    ),
              title: Text(widget.shellData.title(context)),
              actions: [
                ...widget.actions,
                if (widget.showDrawer)
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.menu_open_rounded),
                      );
                    },
                  ),
              ],
            ),
      endDrawer: !widget.showDrawer ? null : widget.shellData.navigationDrawer(context: context, controller: tabcon),
      bottomNavigationBar:
          !widget.showNavigationBar ? null : widget.shellData.bottomNavigationBar(context: context, controller: tabcon),
      body: SafeArea(
        child: childWithRail,
      ),
    );
  }
}
