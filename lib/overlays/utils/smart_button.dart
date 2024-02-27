import 'package:flutter/widgets.dart';
import 'package:socket_showdown/overlays/utils/hover_image.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/static/wallet.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartButton extends StatefulWidget {
  const SmartButton(this.index, {super.key});

  final int index;

  @override
  State<SmartButton> createState() => _SmartButtonState();
}

class _SmartButtonState extends State<SmartButton> {
  bool condition(int _index) {
    if (GameState.bestScore < (walletObjects[widget.index]["score"] as int)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return condition(widget.index)
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                "Achieve best score ${walletObjects[widget.index]["score"]} to unlock",
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "TitleFont",
                    color: Color.fromARGB(61, 0, 0, 0))),
          )
        : HoverImage(
            normalImage: 'assets/images/buttons/google_wallet.png',
            hoverImage: 'assets/images/buttons/google_wallet.png',
            onPressed: () async {
              final String link = walletObjects[widget.index]["url"] as String;
              if (link.isNotEmpty) {
                // ignore: avoid_print
                print("Opening link: $link");
                final Uri _url = Uri.parse(link);
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              }
            },
            landScape: true,
          );
  }
}
