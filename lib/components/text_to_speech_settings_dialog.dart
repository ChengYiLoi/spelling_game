import 'package:education_calculator/classes/text_to_speech_settings.dart';
import 'package:education_calculator/components/tTs_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

final String play = 'images/play.svg';
String txt = '';
class TextToSpeechSettingsDialog extends StatelessWidget {
  const TextToSpeechSettingsDialog({
    Key key,
    @required this.tTsSettings,
    @required this.sliderArray,
    @required this.volume,
    @required this.pitch,
    @required this.rate,
    @required this.speak,
    @required this.speakSettings,
  }) : super(key: key);

  final TextToSpeechSettings tTsSettings;
  final List<TextToSpeechSlider> sliderArray;
  final double volume;
  final double pitch;
  final double rate;
  final Function speak;
  final Function speakSettings;

  @override
  Widget build(BuildContext context) {
 
    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.all(12),
      content: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              right: 20,
              child: Container(
                child: GestureDetector(
                  onTap: (){
                    print(txt);
                    speak(txt);
                  },
                                  child: SvgPicture.asset(
                    play,
                    color: Colors.green,
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ChangeNotifierProvider.value(
                value: tTsSettings,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 30,
                            child: TextField(
                              onChanged: (String str) {
                                txt = str;
                                print(txt);
                              },
                              textAlign: TextAlign.center,
                              autofocus: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: sliderArray,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                tTsSettings.updateValues(
                                    volume, pitch, rate);
                                    speakSettings('Volume', volume);
                                    speakSettings('Pitch', pitch);
                                    speakSettings('Rate', rate);
                                Navigator.pop(context);
                              },
                              child: Text('Save')),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}