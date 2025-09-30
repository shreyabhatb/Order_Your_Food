import 'package:flutter_test/flutter_test.dart';
import 'package:foodexpress/bloc/search_bloc.dart';

void main() {
  group('SearchBloc', () {
    late SearchBloc searchBloc;

    setUp(() {
      searchBloc = SearchBloc();
    });

    test('initial state is SearchInitial', () {
      expect(searchBloc.state, isA<SearchInitial>());
    });

    test('emits [SearchLoading, SearchLoaded] when Search is added', () async {
      final expectedStates = [isA<SearchLoading>(), isA<SearchLoaded>()];
      final states = <SearchState>[];
      final subscription = searchBloc.stream.listen(states.add);
      searchBloc.add(Search('dosa'));
      await Future.delayed(const Duration(seconds: 2));
      expect(states.length, 2);
      expect(states[0], expectedStates[0]);
      expect(states[1], expectedStates[1]);
      subscription.cancel();
    });

    test('emits SearchHistoryLoaded when LoadSearchHistory is added', () async {
      searchBloc.add(Search('dosa'));
      await Future.delayed(const Duration(seconds: 2));
      searchBloc.add(LoadSearchHistory());
      await Future.delayed(const Duration(milliseconds: 100));
      expect(searchBloc.state, isA<SearchHistoryLoaded>());
    });
  });
}
