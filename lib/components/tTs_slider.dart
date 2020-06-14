import 'package:flutter/material.dart';


class TextToSpeechSlider extends StatefulWidget {
  final String sliderText;
  final double sliderValue;
  final double minValue;
  final double maxValue;
  final Function updateValue;
  final Function speakSettings;

  TextToSpeechSlider(this.sliderText, this.sliderValue, this.minValue,
      this.maxValue, this.updateValue, this.speakSettings);

  @override
  _TextToSpeechSliderState createState() => _TextToSpeechSliderState();
}

class _TextToSpeechSliderState extends State<TextToSpeechSlider> {
  double sliderValue;

  @override
  void initState() {
    sliderValue = widget.sliderValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Column(
      children: <Widget>[
        Text(widget.sliderText),
        Row(
          children: <Widget>[
            Text(widget.minValue.toString()),
            Expanded(
              child: Slider(
                min: widget.minValue,
                max: widget.maxValue,
                value: sliderValue,
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                    widget.updateValue(widget.sliderText, value);
                    widget.speakSettings(widget.sliderText, value);
                  });
                },
                divisions: 10,
                label: sliderValue.toString(),
              ),
            ),
            Text(widget.maxValue.toString())
          ],
        ),
      ],
    );
  }
}
