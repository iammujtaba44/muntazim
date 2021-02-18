import 'package:equatable/equatable.dart';
import 'package:muntazim/core/plugins.dart';

// abstract class State extends Equatable {
//   @override
//   List<Object> get props => [];
// }
abstract class ResponseState {
  @override
  Object get props => Object();
}

class InitState extends ResponseState {}

class Loading extends ResponseState {}

class LoadedState extends ResponseState {
  final Object data;
  LoadedState({this.data});
}

class ListError extends ResponseState {
  final error;
  ListError({this.error});
}
