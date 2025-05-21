import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist_provider.dart';
import '../components/neu_box.dart';
import 'song_screen.dart';

class HashtagScreen extends StatelessWidget {
  final String hashtag;

  const HashtagScreen({super.key, required this.hashtag});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        
        final filteredSongs = playlistProvider.playlist
            .where((song) => song.hashtags.contains(hashtag))
            .toList();

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text('#$hashtag'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: filteredSongs.isEmpty
                ? Center(
                    child: Text(
                      'No songs found for #$hashtag',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return GestureDetector(
                        onTap: () {
                          
                          final originalIndex = playlistProvider.playlist.indexOf(song);
                          playlistProvider.setCurrentSong(originalIndex);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SongScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: NeuBox(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  song.albumArtImagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(song.songName),
                              subtitle: Text(song.artistName),
                              trailing: const Icon(Icons.play_arrow),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
