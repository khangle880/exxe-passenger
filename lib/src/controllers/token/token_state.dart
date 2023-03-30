part of 'token_cubit.dart';

abstract class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object> get props => [];
}

class TokenInitial extends TokenState {}

class TokenInvalid extends TokenState {}

class TokenHas extends TokenState {}

class TokenNeedRegister extends TokenState {}

class TokenNeedPassword extends TokenState {}

class TokenNeedVerifyAccount extends TokenState {}
