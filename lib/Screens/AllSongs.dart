import 'package:flutter/material.dart';
import 'package:musicsd/Screens/NowPlaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  void initState(){
    super.initState();
    requestPermission();
  }

  void requestPermission(){
    Permission.storage.request();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final _audioQuery = new OnAudioQuery();


  playSong(String? uri){
    try{
      _audioPlayer.setAudioSource(
        AudioSource.uri(
            Uri.parse(uri!)
        ),
      );
      _audioPlayer.play();
    }catch(e){
      print(e);
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music SD 2023'),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item){
          if(item.data == null){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(item.data!.isEmpty){
            return const Center(
              child: Text(
                  'No Songs found'
              ),
            );
          }
          return  ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index){
                return ListTile(
                  //leading: const Icon(Icons.music_note_outlined),
                  //title: Text(item.data![index].displayNameWOExt),
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Subtitle"),
                  trailing: const Icon(Icons.more_horiz),
                  // leading: const CircleAvatar(
                  //   child: Icon(Icons.music_note_outlined),
                  // ),
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: CircleAvatar(child: const Icon(Icons.music_note_outlined)),
                  ),
                  onTap: (){
                    // playSong(item.data![index].uri);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>NowPlaying(songModel: item.data![index], audioPlayer: _audioPlayer,),
                      ),
                    );
                  },
                );
              }
          );
        },
      ),
    );
  }
}
