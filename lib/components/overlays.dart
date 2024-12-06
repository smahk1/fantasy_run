import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext, Game)> overlays = {
  'score': (context, game) {
    final FantasyRun fantasyRun = game as FantasyRun;

    return Positioned(
      top: 20,
      right: 30,
      child: ValueListenableBuilder<int>(
        valueListenable: fantasyRun.score,
        builder: (context, score, child) {
          return Text(
            'Score: $score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontFamily: 'arcadeclassic',
            ),
          );
        },
      ),
    );
  },
  'health': (context, game) {
    final FantasyRun fantasyRun = game as FantasyRun;

    return Positioned(
      top: 20,
      left: 30,
      child: ValueListenableBuilder<int>(
        valueListenable: fantasyRun.lives,
        builder: (context, lives, child) {
          return Row(
            children: List.generate(
              lives,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Image.asset(
                  'assets/images/health.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          );
        },
      ),
    );
  },

  'signIn': (context, game) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 300,
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontFamily: 'arcadeclassic',
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    content: Text(
                      'You have signed in successfully!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  },

  // Sign Up Overlay
  'signUp': (context, game) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 300,
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontFamily: 'arcadeclassic',
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    content: Text(
                      'You have registered successfully!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  },

  'startMenu': (context, game) {
    final FantasyRun fantasyRun = game as FantasyRun;

    return Stack(
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  fantasyRun.startGame();
                },
                child: const Text(
                  'Play',
                  style: TextStyle(fontSize: 24, fontFamily: 'arcadeclassic'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  fantasyRun.overlays.add('signIn'); // Show Sign In overlay
                  fantasyRun.overlays.remove('startMenu');
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 24, fontFamily: 'arcadeclassic'),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  fantasyRun.overlays.add('signUp'); // Show Sign Up overlay
                  fantasyRun.overlays.remove('startMenu');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24, fontFamily: 'arcadeclassic'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  },
  'pauseButton': (context, game) {
    final FantasyRun fantasyRun = game as FantasyRun;

    return Positioned(
      top: 20,
      right: 30,
      child: GestureDetector(
        onTap: () {
          fantasyRun
              .pauseGame(); // Call pauseGame() to pause the game and show the pause menu
        },
        child: Image.asset(
          'assets/pause_icon.png', // Your sprite/image for the pause button
          width: 50,
          height: 50,
        ),
      ),
    );
  },
  'pauseMenu': (context, game) {
    final FantasyRun fantasyRun = game as FantasyRun;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Paused',
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontFamily: 'arcadeclassic'),
          ),
          const SizedBox(height: 20),
          // Resume Button
          ElevatedButton(
            onPressed: () {
              fantasyRun.resumeGame(); // Resume the game
            },
            child: const Text(
              'Resume',
              style: TextStyle(fontSize: 24, fontFamily: 'arcadeclassic'),
            ),
          ),
          const SizedBox(height: 20),
          // Home Button
          ElevatedButton(
            onPressed: () {
              fantasyRun.resetGame(); // Reset and go to home screen
            },
            child: const Text(
              'Home',
              style: TextStyle(fontSize: 24, fontFamily: 'arcadeclassic'),
            ),
          ),
        ],
      ),
    );
  },
  'gameOver': (context, game) {
    final FantasyRun fantasyRun = game as FantasyRun;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'arcadeclassic'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              fantasyRun.restartGame(); // Restart the game
            },
            child: const Text(
              'Restart',
              style: TextStyle(fontSize: 24, fontFamily: 'arcadeclassic'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              fantasyRun.returnToHome(); // Go to home screen
            },
            child: const Text(
              'Home',
              style: TextStyle(fontSize: 24, fontFamily: 'arcadeclassic'),
            ),
          ),
        ],
      ),
    );
  },
};
