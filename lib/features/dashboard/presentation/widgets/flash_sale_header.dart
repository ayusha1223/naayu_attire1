import 'dart:async';
import 'package:flutter/material.dart';

class FlashSaleHeader extends StatefulWidget {
  const FlashSaleHeader({super.key});

  @override
  State<FlashSaleHeader> createState() =>
      _FlashSaleHeaderState();
}

class _FlashSaleHeaderState
    extends State<FlashSaleHeader> {
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

    _timer =
        Timer.periodic(const Duration(seconds: 1),
            (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final difference =
        _endDate.difference(DateTime.now());

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

  Widget _timeBox(String value, String label) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
              horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff6C6A8D),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Flash Sale",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              _timeBox(
                  _timeLeft.inDays.toString(), "Day"),
              const SizedBox(width: 6),
              _timeBox(
                  _timeLeft.inHours
                      .remainder(24)
                      .toString(),
                  "Hour"),
              const SizedBox(width: 6),
              _timeBox(
                  _timeLeft.inMinutes
                      .remainder(60)
                      .toString(),
                  "Minutes"),
              const SizedBox(width: 6),
              _timeBox(
                  _timeLeft.inSeconds
                      .remainder(60)
                      .toString(),
                  "Second"),
            ],
          ),
        ],
      ),
    );
  }
}
