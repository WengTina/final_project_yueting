import '../../models/song.dart';

abstract class MusicDumpState {}

class MusicDumpInitial extends MusicDumpState {}

class MusicDumpLoading extends MusicDumpState {}

class MusicDumpError extends MusicDumpState {
  final String message;
  MusicDumpError(this.message);
}


class MusicDumpLoaded extends MusicDumpState {
  final Map<DateTime, List<Song>> dumpsByDate;
  MusicDumpLoaded({required this.dumpsByDate});
}
