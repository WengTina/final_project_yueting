import 'package:flutter/material.dart';
import '../models/song.dart';
import '../screens/song_screen.dart';
import '../models/playlist_provider.dart';
import 'package:provider/provider.dart';
class SearchScreen extends StatefulWidget {
  final List<Song> allSongs;

  const SearchScreen({Key? key, required this.allSongs}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    List<Song> filteredSongs =
        widget.allSongs.where((song) {
          return song.songName.toLowerCase().contains(searchText) ||
              song.artistName.toLowerCase().contains(searchText);
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Search Songs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by song or artist',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return ListTile(
                  leading: Image.asset(song.albumArtImagePath, width: 50),
                  title: Text(song.songName),
                  subtitle: Text(song.artistName),
                  onTap: () {
                    final playlistProvider = Provider.of<PlaylistProvider>(
                      context,
                      listen: false,
                    );
                    final songIndex = playlistProvider.playlist.indexOf(song);

                    if (songIndex != -1) {
                      playlistProvider.setCurrentSong(songIndex);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SongScreen()),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
