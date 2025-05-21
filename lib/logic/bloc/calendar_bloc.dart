import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';
import '../../models/song.dart';

class MusicDumpBloc extends Bloc<MusicDumpEvent, MusicDumpState> {
  final Map<DateTime, List<Song>> _storage = {}; 

  MusicDumpBloc() : super(MusicDumpInitial()) {
    on<LoadDumpsForMonth>((event, emit) async {
      emit(MusicDumpLoading());

      try {
        final start = DateTime(event.month.year, event.month.month, 1);
        final end = DateTime(event.month.year, event.month.month + 1, 0);

        final result = <DateTime, List<Song>>{};
        for (int i = 0; i < end.day; i++) {
          final day = DateTime(event.month.year, event.month.month, i + 1);
          result[day] = _storage[day] ?? [];
        }

        emit(MusicDumpLoaded(dumpsByDate: result));
      } catch (e) {
        emit(MusicDumpError('Failed to load music dumps'));
      }
    });

    on<AddDump>((event, emit) {
      final current = _storage[event.date] ?? [];
      current.add(event.song);
      _storage[event.date] = current;

      // refresh the whole month
      final month = DateTime(event.date.year, event.date.month);
      add(LoadDumpsForMonth(month));
    });
  }
}
