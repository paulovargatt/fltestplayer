import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IjkMediaController controller = IjkMediaController();
  List<String> videos = [
    "https://player.vimeo.com/external/310124015.m3u8?s=69bf81c9a1b2b43895d68deccef7a08170d98221",
    "https://player.vimeo.com/external/297369952.m3u8?s=c4c8a5e8819dffdd7f784bf5c91a2d4dbbf80947",
    "https://player.vimeo.com/external/299251934.m3u8?s=6b0d5f8150e0e2850a1c97e19793fb68fd849ef5",
  ];
  var playing;

  void _nextVideo() {
    setState(() async {
      var v = videos.length;
      var n = videos.indexOf(playing) + 1;
      playing = videos[n == v ? 0 : n];
      _setPlay();
    });
  }

  void _setPlay() async{
    await controller.reset();
    await controller.stop();
    await controller.setNetworkDataSource(playing, autoPlay: true);
    await controller.playOrPause();
  }


  Widget buildStatusWidget(BuildContext context,
      IjkMediaController controller,
      IjkStatus status,)  {
    if (status == IjkStatus.noDatasource) {
      print('no data');
    }
    if (status == IjkStatus.pause) {
      print(' pause ');
    }
    if (status == IjkStatus.playing) {
      print(' tocando ');
    }
    if (status == IjkStatus.complete) {
      _nextVideo();
      print(' complete ');
    }
  }

  @override
  void initState() {
    super.initState();
    playing = videos[0];
    print('vai resolver state');
    print(playing);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: ListView(
          children: <Widget>[
            buildIjkPlayer(),
            Padding(
               padding: EdgeInsets.only(top: 15),
               child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () async {
                          VideoInfo info = await controller.getVideoInfo();
                          print(info);
                          var c = info.currentPosition;
                          await controller.seekTo(c + 5);
                          await controller.play();
                        },
                        child: Text("Seek d"),
                      ),

                      FlatButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () async {
                          _nextVideo();
                        },
                        child: Text("Next"),
                      )
                    ])),
          ],
        ),
        padding: EdgeInsets.all(0),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () async {
          _setPlay();
        },
      ),
    );
  }

  Widget buildIjkPlayer() {
    return Container(
      height: 230,
      child: IjkPlayer(
        mediaController: controller,
        statusWidgetBuilder: buildStatusWidget,
      ),
    );
  }
}
