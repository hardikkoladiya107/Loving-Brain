import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/brainy_home/bloc/brainy_home_cubit.dart';
import 'package:loving_brain/ui/brainy_home/brainy_home_screen.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';
import 'package:loving_brain/ui/parent_profile_v2/parent_profile_screen.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/today_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreference.init();
  });

  void setPhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('parent profile button opens the profile route', (
    WidgetTester tester,
  ) async {
    setPhoneSurface(tester);
    final TodayCubit todayCubit = TodayCubit();
    todayCubit.changeProps(childName: 'UT12Child', parentName: 'USERTEST12');

    final GoRouter router = GoRouter(
      initialLocation: RoutePaths.base,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.base,
          builder: (BuildContext context, GoRouterState state) {
            return const TodayScreen();
          },
        ),
        GoRoute(
          path: RoutePaths.parentProfile,
          builder: (BuildContext context, GoRouterState state) {
            return const ParentProfileScreen();
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<TodayCubit>.value(value: todayCubit),
          BlocProvider<ParentProfileV2Cubit>(
            create: (BuildContext context) => ParentProfileV2Cubit(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(389, 780),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.face));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Your profile'), findsOneWidget);
  });

  testWidgets('history and saved buttons open their routes', (
    WidgetTester tester,
  ) async {
    setPhoneSurface(tester);
    final GoRouter router = GoRouter(
      initialLocation: RoutePaths.base,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.base,
          builder: (BuildContext context, GoRouterState state) {
            return const BrainyHomeScreen();
          },
        ),
        GoRoute(
          path: RoutePaths.brainyHistory,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: Text('history-opened'));
          },
        ),
        GoRoute(
          path: RoutePaths.brainySaved,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: Text('saved-opened'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      BlocProvider<BrainyHomeCubit>(
        create: (BuildContext context) => BrainyHomeCubit(),
        child: ScreenUtilInit(
          designSize: const Size(389, 780),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('History'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('history-opened'), findsOneWidget);

    router.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Saved'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('saved-opened'), findsOneWidget);
  });

  testWidgets('hidden journey tab does not steal the profile tap', (
    WidgetTester tester,
  ) async {
    setPhoneSurface(tester);
    final TodayCubit todayCubit = TodayCubit();
    todayCubit.changeProps(childName: 'UT12Child', parentName: 'USERTEST12');
    int stolenTaps = 0;

    final GoRouter router = GoRouter(
      initialLocation: RoutePaths.base,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.base,
          builder: (BuildContext context, GoRouterState state) {
            return IndexedStack(
              index: 0,
              children: <Widget>[
                const TodayScreen(),
                const BrainyHomeScreen(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => stolenTaps++,
                  child: const ColoredBox(
                    color: Color(0x01000000),
                    child: SizedBox.expand(),
                  ),
                ),
              ],
            );
          },
        ),
        GoRoute(
          path: RoutePaths.parentProfile,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: Text('profile-opened'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<TodayCubit>.value(value: todayCubit),
          BlocProvider<BrainyHomeCubit>(
            create: (BuildContext context) => BrainyHomeCubit(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(389, 780),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.face));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(stolenTaps, 0);
    expect(find.text('profile-opened'), findsOneWidget);
  });
}
