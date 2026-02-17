import 'dart:async';
import 'package:flutter/material.dart';

class FlashSaleHeader extends StatefulWidget {
  const FlashSaleHeader({super.key});

  @override
  State<FlashSaleHeader> createState() => _FlashSaleHeaderState();
}

class _FlashSaleHeaderState extends State<FlashSaleHeader> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  final DateTime _endDate =
      DateTime.now().add(const Duration(days: 25));

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final difference = _endDate.difference(DateTime.now());

    if (difference.isNegative) {
      _timer.cancel();
      setState(() {
        _timeLeft = Duration.zero;
      });
    } else {
      setState(() {
        _timeLeft = difference;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// 🔥 Fancy Flash Sale Text
          const Text(
            "Flash Sale",
            style: TextStyle(
              fontFamily: "Times New Roman",
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color.fromARGB(255, 20, 20, 20),
            ),
          ),

          /// ⏳ Inline Timer (No Boxes)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 113, 162, 212),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time,
                    color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  "${_timeLeft.inDays}d "
                  "${_timeLeft.inHours.remainder(24)}h "
                  "${_timeLeft.inMinutes.remainder(60)}m "
                  "${_timeLeft.inSeconds.remainder(60)}s",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
