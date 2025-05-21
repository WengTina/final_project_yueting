import 'package:final_yueting/components/neu_box.dart';
import 'package:final_yueting/models/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({super.key});

  String formatTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        //get playlist
        final playlist = value.playlist;
        //get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        final List<String> availableHashtags = [
          'Workout',
          'Relax',
          'Emotional',
          'Focus',
          'Party',
          'Sleep',
          'Chill',
        ];

        //return scaffold UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          //appBar: AppBar(title: Text('Song Screen')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      //title
                      const Text('P L S Y L I S T'),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const SizedBox(height: 25),
                  //album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        //image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),

                        //song and artist name and icon
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //song and artist name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),

                              //heart icon
                              const Icon(
                                Icons.favorite,
                                color: Color.fromARGB(255, 237, 177, 227),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Hashtag
                  Wrap(
                    spacing: 8,
                    children:
                        availableHashtags.map((tag) {
                          final isSelected = currentSong.hashtags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            selectedColor: Colors.green.shade200,
                            onSelected: (selected) {
                              if (selected) {
                                currentSong.hashtags.add(tag);
                              } else {
                                currentSong.hashtags.remove(tag);
                              }
                              value.notifyListeners();
                            },
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 25),

                  //song duration progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //start time
                            Text(formatTime(value.currentDuration)),

                            //shuffle icon
                            Icon(Icons.shuffle),
                            //repeat iocn
                            Icon(Icons.repeat),
                            //end time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),
                      //song duration progress
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 0,
                          ),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (double double) {
                            //during when the user is sliding around
                          },
                          onChangeEnd: (double double) {
                            //sliding has finished, go to that
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  //playback controls
                  Row(
                    children: [
                      //skip pervious
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: const NeuBox(child: Icon(Icons.skip_previous)),
                        ),
                      ),
                      const SizedBox(width: 20),

                      //play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      //skip forward
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NeuBox(child: Icon(Icons.skip_next)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
