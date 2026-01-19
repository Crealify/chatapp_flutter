// ignore_for_file: public_member_api_docs, sort_constructors_first
class GoogleAuthState {
  final bool isLoading;
  final String? error;
  GoogleAuthState({required this.isLoading, this.error});

  GoogleAuthState copyWith({bool? isLoading, String? error}) {
    return GoogleAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
