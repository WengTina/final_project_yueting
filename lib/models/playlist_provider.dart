import 'package:audioplayers/audioplayers.dart';
import 'package:final_yueting/models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class PlaylistProvider extends ChangeNotifier {
  //playlist of songs
  final List<Song> _playlist = [];

  //current song playing index
  int? _currentSongIndex;

  void setCurrentSong(int index) {
    currentSongIndex = index;
    notifyListeners();
  }


  final AudioPlayer _audioPlayer = AudioPlayer();
  //durations
  Duration _CurrentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  //constructor
  PlaylistProvider() {
    listenToDuration();
    loadSongFromJson();
  }
  Future<void> loadSongFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/songs.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _playlist.clear();
      _playlist.addAll(jsonData.map((item) => Song.fromJson(item)));
      notifyListeners();
    } catch (e) {
      print('Failed to load songs from JSON: $e');
    }
  }
 
  bool _isPlaying = false;

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path)); 
    _isPlaying = true;
    notifyListeners();
  }

  //pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        //go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        //if it's the last song, look back to the first song
        currentSongIndex = 0;
      }
    }
  }

  //play previous song
  void playPreviousSong() async {
    
    if (_CurrentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    
    else {
      if (currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
      
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //list to duration
  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _CurrentDuration = newPosition;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
  //dispose audio player

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _CurrentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); 
    }

    
    notifyListeners();
  }
}
