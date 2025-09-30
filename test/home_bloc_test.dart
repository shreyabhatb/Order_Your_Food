import 'package:flutter_test/flutter_test.dart';
import 'package:foodexpress/bloc/home_bloc.dart';

void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = HomeBloc();
    });

    test('initial state is HomeInitial', () {
      expect(homeBloc.state, isA<HomeInitial>());
    });

    test('emits [HomeLoading, HomeLoaded] when LoadHome is added', () async {
      final expectedStates = [isA<HomeLoading>(), isA<HomeLoaded>()];
      final states = <HomeState>[];
      final subscription = homeBloc.stream.listen(states.add);
      homeBloc.add(LoadHome());
      await Future.delayed(const Duration(seconds: 2));
      expect(states.length, 2);
      expect(states[0], expectedStates[0]);
      expect(states[1], expectedStates[1]);
      subscription.cancel();
    });
  });
}
