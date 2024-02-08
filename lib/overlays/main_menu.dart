import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_showdown/screens/game_loop.dart';
import 'package:socket_showdown/socket_tower.dart';

// ignore: must_be_immutable
class MainMenu extends StatefulWidget {
  MainMenu(this.game, {super.key});
  Object? game;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: const Color.fromARGB(0, 5, 139, 222),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: SizedBox(
                      width: 400, // Adjust the width as needed

                      child: Column(
                        children: [
                          Image.asset('assets/images/logo.png'),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'TAP TO START',
                              style: TextStyle(
                                fontSize: 24,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        (widget.game as FlameGame).overlays.remove('menu');
        ((widget.game as SocketTower).world.children.first as GameLoop)
            .startGame();
        // (widget.game as SocketTower).overlays.add('tap-overlay');
      },
    );
  }
}
