class UserListTileState {
  final bool isLoading;
  final String? requestStatus;
  final bool areFriends;
  final bool isRequestsender;
  final String? pendingRequestId;

  UserListTileState({
    this.isLoading = false,
    this.requestStatus,
    this.areFriends = false,
    this.isRequestsender = false,
    this.pendingRequestId,
  });

  UserListTileState copyWith({
    bool? isLoading,
    String? requestStatus,
    bool? areFriends,
    bool? isRequestsender,
    String? pendingRequestId,
  }) {
    return UserListTileState(
      isLoading: isLoading ?? this.isLoading,
      requestStatus: requestStatus ?? this.requestStatus,
      areFriends: areFriends ?? this.areFriends,
      isRequestsender: isRequestsender ?? this.isRequestsender,
      pendingRequestId: pendingRequestId ?? this.pendingRequestId,
    );
  }
}
