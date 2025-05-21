import 'package:final_yueting/models/playlist_provider.dart';
import 'package:final_yueting/screens/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        if (playlistProvider.currentSongIndex == null) {
          return const SizedBox.shrink();
        }

        final currentSong =
            playlistProvider.playlist[playlistProvider.currentSongIndex!];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SongScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    currentSong.albumArtImagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.songName,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong.artistName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onPressed: playlistProvider.playPreviousSong,
                ),

                IconButton(
                  icon: Icon(
                    playlistProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onPressed: playlistProvider.pauseOrResume,
                ),

                IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  onPressed: playlistProvider.playNextSong,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
