import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key, required this.songModel, required this.audioPlayer}) : super(key: key);

  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {

  Duration _duration = const Duration();
  Duration _position = const Duration();


  //final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  void initState(){
    super.initState();

    playSong();
  }

  void playSong(){
    try{
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
            Uri.parse(widget.songModel.uri!),
          // tag: MediaItem(
          //   // Specify a unique ID for each media item:
          //   id: '${widget.songModel.id}',
          //   // Metadata to display in the notification:
          //   album: "${widget.songModel.album}",
          //   title: widget.songModel.displayNameWOExt,
          //   artUri: Uri.parse('https://example.com/albumart.jpg'),
          // ),
        ),
      );
      widget.audioPlayer.play();
      _isPlaying = true;
    }catch(e){
      print(e);
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 100.0,
                      child: Icon(
                        Icons.music_note_outlined,
                        size: 90.0,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      widget.songModel.displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.songModel.artist.toString() == "<unknown>" ? "Unknown Artist" : widget.songModel.artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          _position.toString().split(".")[0]
                        ),
                        Expanded(
                          child: Slider(
                            min: const Duration(microseconds: 0).inSeconds.toDouble(),
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value){
                              setState(() {
                                changeToSeconds(value.toInt());
                                value = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          _duration.toString().split(".")[0]
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: (){

                          },
                          icon: const Icon(
                              Icons.skip_previous,
                              size: 40.0,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            setState((){
                              if(_isPlaying){
                                widget.audioPlayer.pause();
                              }else{
                                widget.audioPlayer.play();
                              }
                              _isPlaying = !_isPlaying;
                            });

                          },
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40.0,
                          ),
                        ),
                        IconButton(
                          onPressed: (){

                          },
                          icon: const Icon(
                            Icons.skip_next,
                            size: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              )
            ],
          )
        ),
      )
    );
  }

  void changeToSeconds(int seconds){
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
