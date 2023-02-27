part of 'counter_bloc.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class CounterIncreamentEvent extends CounterEvent {
  final int value;

  const CounterIncreamentEvent({required this.value});
  @override
  List<Object> get props => [value];
}

class CounterdecreamentEvent extends CounterEvent {
  final int value;

  const CounterdecreamentEvent({required this.value});
  @override
  List<Object> get props => [value];
}
