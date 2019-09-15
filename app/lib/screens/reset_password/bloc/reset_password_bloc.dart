import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tic_tac_toe/repositories/user_repository.dart';
import 'package:tic_tac_toe/util/validator.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final UserRepository _userRepository;

  ResetPasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ResetPasswordState get initialState => ResetPasswordState.empty();

  @override
  Stream<ResetPasswordState> transformEvents(
    Stream<ResetPasswordEvent> events,
    Stream<ResetPasswordState> Function(ResetPasswordEvent event) next,
  ) {
    final observableStream = events as Observable<ResetPasswordEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<ResetPasswordState> mapEventToState(
    ResetPasswordEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email);
    }
  }

  Stream<ResetPasswordState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validator.isValidEmail(email),
    );
  }

  Stream<ResetPasswordState> _mapFormSubmittedToState(
    String email,
  ) async* {
    yield ResetPasswordState.loading();
    try {
      await _userRepository.forgotPasswordEmail(email);
      yield ResetPasswordState.success();
    } catch (_) {
      yield ResetPasswordState.failure();
    }
  }
}
