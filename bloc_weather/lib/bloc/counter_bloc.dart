import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    on<CounterIncreamentEvent>((event, emit) {
      emit(CounterLoadedState(value: event.value + 1));
    });
    on<CounterdecreamentEvent>((event, emit) {
      emit(CounterLoadedState(value: event.value - 1));
    });
  }
}
