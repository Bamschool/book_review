import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadCubit extends Cubit<UploadState> {
  FirebaseStorage storage;
  UploadCubit(this.storage) : super(const UploadState());

  void uploadUserProfile(File file, String uid) {
    emit(state.copyWith(status: UploadStatus.uploading));
    final storageRef = storage.ref();
    var uploadTask = storageRef.child('$uid/profile.jpg').putFile(file);
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.paused:
          break;
        case TaskState.canceled:
          break;

        case TaskState.running:
          final progress =
              100 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          emit(state.copyWith(percent: progress));

        case TaskState.error:
          break;

        case TaskState.success:
          final imageUrl =
              await storageRef.child('$uid/profile.jpg').getDownloadURL();
          emit(state.copyWith(url: imageUrl, status: UploadStatus.success));
      }
    });
  }
}

enum UploadStatus {
  init,
  uploading,
  success,
  fail,
}

class UploadState extends Equatable {
  final UploadStatus status;
  final double? percent;
  final String? url;
  const UploadState({
    this.status = UploadStatus.init,
    this.percent = 0,
    this.url,
  });
  @override
  List<Object?> get props => [status, percent, url];

  UploadState copyWith({
    UploadStatus? status,
    double? percent,
    String? url,
  }) {
    return UploadState(
      status: status ?? this.status,
      percent: percent ?? this.percent,
      url: url ?? this.url,
    );
  }

  @override
  String toString() =>
      'UploadState(status: $status, percent: $percent, url: $url)';
}
