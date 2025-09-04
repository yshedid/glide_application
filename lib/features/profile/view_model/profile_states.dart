class ProfileStates {
}
class ProfileInitial extends ProfileStates {}
class ProfileLoading extends ProfileStates {}
class ProfileSuccess extends ProfileStates {}
class ProfileFailure extends ProfileStates {
  final String errorMessage;
  ProfileFailure(this.errorMessage);
}