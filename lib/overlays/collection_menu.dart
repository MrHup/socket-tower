import 'package:carousel_slider/carousel_slider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:socket_showdown/overlays/utils/hover_image.dart';
import 'package:socket_showdown/overlays/utils/leaderboard_title.dart';
import 'package:socket_showdown/overlays/utils/smart_button.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/static/sound_player.dart';
import 'package:socket_showdown/static/wallet.dart';

// ignore: must_be_immutable
class CollectionMenu extends StatefulWidget {
  CollectionMenu(this.game, {this.score = 0, super.key});
  Object? game;
  int score;

  @override
  State<CollectionMenu> createState() => _CollectionMenuState();
}

class _CollectionMenuState extends State<CollectionMenu> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    int bestScore = GameState.bestScore;
    List<Image> images = [
      bestScore >= (walletObjects[0]["score"] as int)
          ? Image.asset(walletObjects[0]["img_path"] as String)
          : Image.asset("assets/images/cards/unknown_card.png"),
      bestScore >= (walletObjects[1]["score"] as int)
          ? Image.asset(walletObjects[1]["img_path"] as String)
          : Image.asset("assets/images/cards/unknown_card.png"),
      bestScore >= (walletObjects[2]["score"] as int)
          ? Image.asset(walletObjects[2]["img_path"] as String)
          : Image.asset("assets/images/cards/unknown_card.png"),
      bestScore >= (walletObjects[3]["score"] as int)
          ? Image.asset(walletObjects[3]["img_path"] as String)
          : Image.asset("assets/images/cards/unknown_card.png"),
      bestScore >= (walletObjects[4]["score"] as int)
          ? Image.asset(walletObjects[4]["img_path"] as String)
          : Image.asset("assets/images/cards/unknown_card.png"),
    ];
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
                          items: images,
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 1.05,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DotStepper(
                              shape: Shape.rectangle,
                              activeStep: _current,
                              dotCount: images.length,
                              dotRadius: 6,
                              tappingEnabled: false,
                              spacing: 8,
                              fixedDotDecoration: const FixedDotDecoration(
                                color: Color.fromARGB(57, 33, 149, 243),
                              ),
                              indicatorDecoration: const IndicatorDecoration(
                                  color: Colors.blue, strokeWidth: 0)),
                        ),
                        SmartButton(_current),
                        // image button
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -50, // Adjust this value according to your preference
                  child: Image.asset("assets/images/logo_blue.png"),
                ),
                Positioned(
                  bottom: -20,
                  child: Material(
                    color: Colors.transparent,
                    child: HoverImage(
                      normalImage: 'assets/images/buttons/back_up.png',
                      hoverImage: 'assets/images/buttons/back_down.png',
                      onPressed: () {
                        (widget.game as FlameGame)
                            .overlays
                            .remove('collections');
                        (widget.game as FlameGame).overlays.add('replay-menu');
                        SoundPlayer.playDrop();
                      },
                      landScape: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
