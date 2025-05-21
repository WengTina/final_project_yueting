import '../../models/song.dart';

abstract class MusicDumpEvent {}

class LoadDumpsForDate extends MusicDumpEvent {
  final DateTime date;
  LoadDumpsForDate(this.date);
}

class AddDump extends MusicDumpEvent {
  final DateTime date;
  final Song song;
  AddDump({required this.date, required this.song});
}
class LoadDumpsForMonth extends MusicDumpEvent {
  final DateTime month;
  LoadDumpsForMonth(this.month);
}