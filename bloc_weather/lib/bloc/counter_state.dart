part of 'counter_bloc.dart';

abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object> get props => [];
}

class CounterInitial extends CounterState {}

class CounterLoadedState extends CounterState {
  final int value;

  const CounterLoadedState({required this.value});

  @override
  List<Object> get props => [value];
}
