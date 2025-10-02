import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(
        isDarkMode: _isDarkMode,
        toggleTheme: toggleTheme,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  HomePage({required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        FadingTextAnimation(
          duration: Duration(seconds: 1),
          isDarkMode: isDarkMode,
          toggleTheme: toggleTheme,
        ),
        FadingTextAnimation(
          duration: Duration(seconds: 3),
          isDarkMode: isDarkMode,
          toggleTheme: toggleTheme,
        ),
      ],
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final Duration duration;
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  FadingTextAnimation({
    required this.duration,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.blue;
  bool _showRoundedImage = false;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
// change color for the text 
  void changeColor() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _textColor;
        return AlertDialog(
          title: Text("Pick a color"),
          content: BlockPicker(
            pickerColor: _textColor,
            onColorChanged: (color) {
              tempColor = color;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _textColor = tempColor;
                });
                Navigator.pop(context);
              },
              child: Text("Select"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fading Text Animation"),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: changeColor,
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: widget.duration,
              child: Text(
                "Hello, Flutter!",
                style: TextStyle(fontSize: 28, color: _textColor),
              ),
            ),
          ),
          SizedBox(height: 20),
          SwitchListTile(
            title: Text("Show Rounded Image"),
            value: _showRoundedImage,
            onChanged: (val) {
              setState(() {
                _showRoundedImage = val;
              });
            },
          ),
          if (_showRoundedImage)
           AnimatedOpacity(
    opacity: _showRoundedImage ? 1.0 : 1.0,   // fade in/out
    duration: Duration(seconds: 4),           // adjust duration as you like
    child: ClipRRect(
      borderRadius: BorderRadius.circular(200), // controls roundness
      child: Image.asset(
        "assets/images/image4.png",  // switched to asset since it's local
        height: 300,
        width: 300,
      ),
    ),
  ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
