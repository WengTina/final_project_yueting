import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/calendar_bloc.dart';
import '../logic/bloc/calendar_event.dart';
import '../logic/bloc/calendar_state.dart';
import '../models/playlist_provider.dart';


class MusicDumpScreen extends StatefulWidget {
  const MusicDumpScreen({Key? key}) : super(key: key);

  @override
  State<MusicDumpScreen> createState() => _MusicDumpScreenState();
}

class _MusicDumpScreenState extends State<MusicDumpScreen> {
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<MusicDumpBloc>().add(LoadDumpsForMonth(_currentMonth));
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final days = List.generate(
      DateUtils.getDaysInMonth(month.year, month.month),
      (index) => DateTime(month.year, month.month, index + 1),
    );
    return days;
  }

  void _showSongPickerDialog(DateTime selectedDate) {
    final playlistProvider = context.read<PlaylistProvider>();
    final playlist = playlistProvider.playlist;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            final song = playlist[index];
            return ListTile(
              leading: Image.asset(song.albumArtImagePath, width: 50),
              title: Text(song.songName),
              subtitle: Text(song.artistName),
              onTap: () {
                Navigator.pop(context);
                context.read<MusicDumpBloc>().add(AddDump(date: selectedDate, song: song));
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_currentMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Dump"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
              context.read<MusicDumpBloc>().add(LoadDumpsForMonth(_currentMonth));
            },
          ),
          Center(child: Text("${_currentMonth.year} / ${_currentMonth.month}", style: const TextStyle(fontSize: 16))),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
              context.read<MusicDumpBloc>().add(LoadDumpsForMonth(_currentMonth));
            },
          ),
        ],
      ),
      body: BlocBuilder<MusicDumpBloc, MusicDumpState>(
        builder: (context, state) {
          final dumpsByDate = state is MusicDumpLoaded ? state.dumpsByDate : {};
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final dayKey = DateTime(day.year, day.month, day.day);
              final hasDump = dumpsByDate[dayKey]?.isNotEmpty == true;
              final dumpImage = hasDump ? dumpsByDate[dayKey]!.last.albumArtImagePath : null;

              return GestureDetector(
                onTap: () => _showSongPickerDialog(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 235, 247),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${day.day}", style: const TextStyle(color: Color.fromARGB(255, 83, 83, 80),fontWeight: FontWeight.bold)),
                      if (hasDump)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Image.asset(dumpImage!, width: 40, height: 40, fit: BoxFit.cover),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
