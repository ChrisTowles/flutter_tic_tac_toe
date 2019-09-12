import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class ResetPasswordEvent extends Equatable {
  ResetPasswordEvent([List props = const []]) : super(props);
}

class EmailChanged extends ResetPasswordEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}



class Submitted extends ResetPasswordEvent {
  final String email;

  Submitted({@required this.email})
      : super([email]);

  @override
  String toString() {
    return 'Submitted { email: $email }';
  }
}