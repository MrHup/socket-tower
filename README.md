# Socket Tower

![Banner](https://i.imgur.com/ixOwq3Z.png)

**Socket Tower** is a game where you stack up home appliances on top of each other while trying not to tip your creation over. Find out just how much electricity these everyday items consume and better visualize them with the collectible system powered by Google Wallet!


## Prerequisites

### Firebase configuration

In order to run this project you will first need to connect it to your firebase project. It makes use of a firestore database to initialize the leaderboard state. 
Alternatively, simply remove the following from `main.dart`:
```
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
```

If you do plan to run with firebase, you will need a firestore database with a collection called `top10` and a document inside it called `top`.

### Installing dependencies & run

Run the following to install all required dependencies:
```
flutter pub get
```

Run the application:
```
flutter run
```


## Project structure

The application was built for the [Global Gamers Challenge](https://devpost.com/software/socket-showdown) hackathon, therefore the structure is not as per standards. However you can find your way around using the following:
- `components`: contains all custom Flame components. Each falling object inherits from `components/falling_box.dart`, which is the main physics components used throughout the project;
- `screens/game_loop.dart`: handles the core game loop of the application and ties everything together;
- `overlays`: contains all the UI views, including leaderboard system, replay menu and more;
- `static` and `utils` ultimately played a role for miscellaneous components. One contains different structures used throughout the application and the other offers some utilities.
