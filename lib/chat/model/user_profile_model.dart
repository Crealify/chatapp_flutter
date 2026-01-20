// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileState {
  final String? photoUrl;
  final String? name;
  final String? email;
  final bool isLoading;
  final bool isUploading;
  final DateTime? createdAt;
  final String? userId; // == ADD USERiD TO TRACK CURRENT USER
  ProfileState({
    this.photoUrl,
    this.name,
    this.email,
    this.isLoading = false,
    this.isUploading = false,
    this.createdAt,
    this.userId,
  });

  ProfileState copyWith({
    String? photoUrl,
    String? name,
    String? email,
    bool? isLoading,
    bool? isUploading,
    DateTime? createdAt,
    String? userId,
  }) {
    return ProfileState(
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}

