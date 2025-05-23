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
        
        final playlist = value.playlist;
        
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

        
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      
                      const Text('P L S Y L I S T'),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  NeuBox(
                    child: Column(
                      children: [
                        
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),

                        
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
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

                  
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            Text(formatTime(value.currentDuration)),

                            
                            Icon(Icons.shuffle),
                            
                            Icon(Icons.repeat),
                            
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),
                      
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
                            
                          },
                          onChangeEnd: (double double) {
                            
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                 
                  Row(
                    children: [
                      
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: const NeuBox(child: Icon(Icons.skip_previous)),
                        ),
                      ),
                      const SizedBox(width: 20),

                      
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
