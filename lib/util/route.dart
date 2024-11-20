import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/model/story_model.dart';
import '../data/service/cache_service.dart';
import '../module/detail/screen.dart';
import '../module/home/screen.dart';
import '../module/login/screen.dart';
import '../module/post/screen.dart';
import '../module/register/screen.dart';

enum RouteEnum {
  home('/'),
  detail('/detail'),
  login('/login'),
  register('/register'),
  post('/post');

  const RouteEnum(this.name);
  final String name;
}

final routes = GoRouter(
  routes: [
    GoRoute(
      path: RouteEnum.home.name,
      redirect: (context, __) async {
        final isLoggedIn = await context.read<CacheService>().isLoggedIn();
        return isLoggedIn ? null : RouteEnum.login.name;
      },
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteEnum.detail.name,
      builder: (_, state) => DetailScreen(story: (state.extra as Story)),
    ),
    GoRoute(
      path: RouteEnum.login.name,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteEnum.register.name,
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteEnum.post.name,
      builder: (_, __) => const PostScreen(),
    ),
  ],
);
