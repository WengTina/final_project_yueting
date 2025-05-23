import 'package:final_yueting/components/drawer.dart';
import 'package:final_yueting/models/playlist_provider.dart';
import 'package:final_yueting/models/song.dart';
import 'package:final_yueting/screens/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  //go to a song
  void goToSong(BuildContext context, int songIndex) {
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SongScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("Let’s vibe ... ✨💗🐰")),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Consumer<PlaylistProvider>(
            builder: (context, value, child) {
              final List<Song> playlist = value.playlist;

             
              final List<Song> filteredList = playlist.where((song) {
                final query = searchQuery.toLowerCase();
                return song.songName.toLowerCase().contains(query) ||
                    song.artistName.toLowerCase().contains(query);
              }).toList();

              return Column(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search song or artist...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),

                  
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final Song song = filteredList[index];
                        return ListTile(
                          title: Text(song.songName,
                              style: Theme.of(context).textTheme.titleMedium),
                          subtitle: Text(song.artistName,
                              style: Theme.of(context).textTheme.titleMedium),
                          leading: Image.asset(song.albumArtImagePath),
                          onTap: () => goToSong(context, playlist.indexOf(song)),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),

         
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
