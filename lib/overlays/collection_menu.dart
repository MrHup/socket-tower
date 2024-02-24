import 'package:carousel_slider/carousel_slider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:socket_showdown/overlays/utils/hover_image.dart';
import 'package:socket_showdown/overlays/utils/leaderboard_title.dart';
import 'package:socket_showdown/static/sound_player.dart';

// ignore: must_be_immutable
class CollectionMenu extends StatefulWidget {
  CollectionMenu(this.game, {this.score = 0, super.key});
  Object? game;
  int score;

  @override
  State<CollectionMenu> createState() => _CollectionMenuState();
}

class _CollectionMenuState extends State<CollectionMenu> {
  List<Widget> valuesWidget = [
    Image.asset("assets/images/cards/lamp_card.png"),
    Image.asset("assets/images/cards/tv_card.png"),
    Image.asset("assets/images/cards/toaster_card.png"),
    Image.asset("assets/images/cards/unknown_card.png"),
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(127, 0, 0, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Card(
                  elevation: 20,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: SizedBox(
                    width: 400,
                    // height: MediaQuery.of(context).size.height * 0.75,
                    height: 650,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        const LeaderboardTitle(title: "Collection"),
                        CarouselSlider(
                          items: valuesWidget,
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                        ),
                        HoverImage(
                          normalImage:
                              'assets/images/buttons/google_wallet.png',
                          hoverImage: 'assets/images/buttons/google_wallet.png',
                          onPressed: () {
                            setState(() {
                              _current = (_current + 1) % valuesWidget.length;
                            });
                          },
                          landScape: true,
                        ),
                        DotStepper(
                            activeStep: _current,
                            dotCount: valuesWidget.length,
                            dotRadius: 6,
                            spacing: 8,
                            fixedDotDecoration: const FixedDotDecoration(
                              color: Color.fromARGB(57, 33, 149, 243),
                            ),
                            indicatorDecoration: const IndicatorDecoration(
                                color: Colors.blue, strokeWidth: 0)),
                        // image button
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -50, // Adjust this value according to your preference
                  child: Image.asset("assets/images/logo_blue.png"),
                ),
              ],
            ),

            // back button
            Material(
              color: Colors.transparent,
              child: HoverImage(
                normalImage: 'assets/images/buttons/back_up.png',
                hoverImage: 'assets/images/buttons/back_down.png',
                onPressed: () {
                  (widget.game as FlameGame).overlays.remove('collections');
                  (widget.game as FlameGame).overlays.add('replay-menu');
                  SoundPlayer.playDrop();
                },
                landScape: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
