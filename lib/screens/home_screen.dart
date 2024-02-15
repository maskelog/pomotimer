import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalSeconds = 1500; // 초기 설정 값 25분
  bool isRunning = false;
  int pomodorosCompleted = 0; // 완료된 Pomodoro 수
  int roundsCompleted = 0; // 완료된 Round 수
  int goal = 12; // 목표 Round 수
  late Timer timer;
  final List<int> timerOptions = [15, 20, 25, 30, 35]; // 분 단위
  static const int pomodoroLength = 25 * 60; // Pomodoro 기본 시간 (25분)
  static const int shortBreakLength = 5 * 60; // 짧은 휴식 시간 (5분)
  static const int pomodorosPerRound = 4; // ROUND 당 Pomodoro 수

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  void onTick(Timer timer) {
    if (isRunning) {
      if (totalSeconds > 0) {
        setState(() => totalSeconds--);
      } else {
        setState(() {
          pomodorosCompleted++;
          if (pomodorosCompleted % pomodorosPerRound == 0) {
            roundsCompleted++;
            if (roundsCompleted >= goal) {
              // 목표 달성 로직 (예: 사용자에게 알림)
            }
            totalSeconds = shortBreakLength; // 휴식 시간 시작
          } else {
            totalSeconds = pomodoroLength; // 다음 Pomodoro 시작
          }
          isRunning = false;
        });
      }
    }
  }

  void startTimer() {
    if (!isRunning && totalSeconds > 0) {
      setState(() => isRunning = true);
      timer = Timer.periodic(const Duration(seconds: 1), onTick);
    }
  }

  void pauseTimer() {
    if (isRunning) {
      timer.cancel();
      setState(() => isRunning = false);
    }
  }

  void resetTimer() {
    timer.cancel();
    setState(() {
      totalSeconds = pomodoroLength; // 25분으로 리셋
      isRunning = false;
      pomodorosCompleted = 0;
      roundsCompleted = 0;
    });
  }

  void selectTime(int minutes) {
    if (!isRunning) {
      setState(() {
        totalSeconds = minutes * 60;
      });
    }
  }

  String format(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          'pomotimer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFE7626C),
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timerOptions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap:
                      !isRunning ? () => selectTime(timerOptions[index]) : null,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      color: !isRunning
                          ? Theme.of(context).cardColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${timerOptions[index]}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          IconButton(
            iconSize: 120,
            color: Theme.of(context).cardColor,
            onPressed: isRunning ? pauseTimer : startTimer,
            icon: Icon(
              isRunning
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
            ),
          ),
          IconButton(
            iconSize: 30,
            color: Theme.of(context).cardColor,
            onPressed: resetTimer,
            icon: const Icon(Icons.refresh_outlined),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${pomodorosCompleted % pomodorosPerRound}/$pomodorosPerRound',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const Text(
                        'ROUND',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$roundsCompleted/$goal',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const Text(
                        'GOAL',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
