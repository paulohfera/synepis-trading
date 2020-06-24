import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String pair;
  final double value;
  final DateTime time;

  Quote(this.pair, this.value, this.time);

  @override
  List<Object> get props => [pair, value, time];
}
