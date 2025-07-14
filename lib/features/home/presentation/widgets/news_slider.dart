import 'package:flutter/material.dart';

class NewsSlider extends StatefulWidget {
  const NewsSlider({super.key});

  @override
  State<NewsSlider> createState() => _NewsSliderState();
}

class _NewsSliderState extends State<NewsSlider> {
  final List<String> updates = [
    "🔔 New push notification system added!",
    "💡 Dark mode improvements and bug fixes.",
    "📈 Dashboard performance boosted by 25%.",
    "🛡️ Security patch for login screen.",
    "🎨 UI cleanup in profile section.",
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startUpdateCycle();
  }

  void _startUpdateCycle() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % updates.length;
      });
      _startUpdateCycle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
        },
        child: Container(
          key: ValueKey(_currentIndex),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Text(
            updates[_currentIndex],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
