
import 'package:audioplayers/audioplayers.dart';
import 'package:ausa_flutter/modelview/record_page_mv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  
  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _recorderBody(),
      ),
    );
  }

  Widget _recorderBody() {

    RecordPageModelView mv = context.read<RecordPageModelView>();

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            mv.onPressButton();
          },
          child: Text(context.watch<RecordPageModelView>().buttonText),
        ),
        ElevatedButton(onPressed: () async {
          await player.play(DeviceFileSource(context.read<RecordPageModelView>().getFileName()));
        }, child: const Text("Play Audio"))
      ],
    );
  }
}
