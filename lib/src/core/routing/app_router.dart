import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake/fake_repository.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/shell/shell_scaffold.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/pages/page_detail_screen.dart';
import '../../features/pages/pages_list_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/tasks/task_detail_screen.dart';
import '../../features/tasks/tasks_list_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final repo = ref.watch(fakeRepositoryProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _GoRouterRefresh(ref),
    redirect: (context, state) {
      final loggedIn = repo.currentUser != null;
      final loc = state.uri.path;

      final isAuthRoute = loc == '/login' || loc == '/register' || loc == '/splash';
      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && (loc == '/login' || loc == '/register')) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            redirect: (context, state) => '/dashboard',
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/pages',
            builder: (context, state) => const PagesListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => PageDetailScreen(pageId: int.parse(state.pathParameters['id']!)),
              ),
            ],
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => TaskDetailScreen(taskId: int.parse(state.pathParameters['id']!)),
              ),
            ],
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

class _GoRouterRefresh extends ChangeNotifier {
  _GoRouterRefresh(this.ref) {
    _sub = ref.listen<FakeRepositoryState>(fakeRepositoryProvider, (prev, next) => notifyListeners());
  }

  final Ref ref;
  late final ProviderSubscription<FakeRepositoryState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

