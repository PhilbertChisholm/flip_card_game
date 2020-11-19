import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

void main() async =>{
  WidgetsFlutterBinding.ensureInitialized(),
await  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  runApp(new MyApp())
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
String cardOne;
String cardTwo;
int previous;
int level;
int levelGrid;
int numberMatched = 0;
bool winner = false;
Timer _time;
int start = 0;
List<String> choose = ["Easy", "Moderate", "Hard"];
List<GlobalKey<FlipCardState>> levelCardKey = [GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),];
List<GlobalKey<FlipCardState>> cardKey = [GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),
  GlobalKey<FlipCardState>(),];

List<bool> matched = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];
List<String> values;
ConfettiController _confettiController = new ConfettiController();
@override

void reset(){
 matched = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];
 numberMatched = 0;
 _time.cancel();
}
void startTimer(){
  start = 0;
  const oneSec = Duration(seconds: 1);
  _time = new Timer.periodic(
    oneSec,
      (Timer timer) => setState((){
        start++;
      })
  );
}
Widget youWon(){
  //_confettiController.play();

    return SimpleDialog(elevation: 100,
    title: Text("Congrats, You've won\nin: ${start}s", textAlign: TextAlign.center,),
     children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
       FlatButton(onPressed: (){
         _confettiController.play();
       },
       child: Text("Press me"),),
     ],);

}


@override
  Widget build(BuildContext context) {
  if(level != null)

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Timer: ${start}s"),
      ),

      body:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.1 , vertical: 0.5),
          child: GridView.count(
            crossAxisCount: levelGrid,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children:
              List.generate(level, (index) {
                return FlipCard(
                  key: cardKey[index],
                  flipOnTouch: matched[index],

                  direction: FlipDirection.VERTICAL,
                  front: Container(
                    color: Colors.blue[100],
                      child:
                  FlutterLogo(colors: Colors.blue, size: double.maxFinite),),
                  back: Container(
                    color: matched[index]? Colors.red[100]: Colors.green[100],
                    child: Text("card ${values[index]}", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
                  ),
                  onFlip: () {
                    print("flip");
                    if(previous == index)
                    {
                      if(!cardKey[index].currentState.isFront){
                        print("i 3");
                      cardTwo =null;
                      cardOne = null;
                      }
                      else
                        {cardOne = values[index];}
                    }
                      else if (cardOne == null) {
                        cardOne = values[index];
                      }
                      else {
                        cardTwo = values[index];
                      }

                  },
                  onFlipDone: (val) {
    if (cardOne == cardTwo && cardTwo != null) {
      setState(() {
        matched[index] = false;
        matched[previous] = false;
        numberMatched ++;
        if (numberMatched == level / 2) {
          winner = true;
          reset();
          level = null;
          levelGrid = null;
        }
      });
      cardOne = null;
      cardTwo = null;
      previous = null;
    }
    else if (cardTwo != null && cardOne != null) {
      cardKey[previous].currentState.toggleCard();
      cardKey[index].currentState.toggleCard();

      cardOne = null;
      cardTwo = null;
    }
    else {
      if(!cardKey[index].currentState.isFront)
      previous = index;
    }


                  },
                );
              }),
          ),
        ),
    );
  else
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Flutter Matcher"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: Text("CHOOSE DIFFICULTY")),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              height: 200,
              width: 400,
              child: Container(
              //elevation: 1,

              child:
              Center(
                child: Container(
                  height: 180,
                  width: 280,
                  child: Card(
                  child:
                    GridView.count(
                      crossAxisCount: 3,
                      children:
                        List.generate(3, (index){
                          return FlipCard(
                            key: levelCardKey[index],
                            direction: FlipDirection.HORIZONTAL,
                            front: Center(
                              child: Card(elevation: 5,
                              borderOnForeground: true,
                           color: Colors.yellowAccent,
                              child: Text(choose[index], style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),)),
                            ),
                            back: Center(
                              child: Card(elevation: 2,
                                  borderOnForeground: true,
                                  color: Colors.yellowAccent[300],
                                  child: Text("Let's GO", style: TextStyle(fontSize: 14,fontStyle: FontStyle.italic),)),
                            ),
                            onFlipDone: (val){

                              setState(() {
                                if(index == 0){
                                  level = 4;
                                  levelGrid =2;
                                }
                                else if(index == 1){
                                  level = 12;
                                  levelGrid =3;
                                }
                                else if(index == 2){
                                level = 20;
                                levelGrid =5;
                                }
                                values = numberGenerator(level);
                                startTimer();
                              });
                            },
                          );
                        }),
                    )
                  ),
                ),
              ),
            ),
            ),
          ),
          winner ? youWon(): Text("How to Play:\nTap to choose difficulty \nTap on cards to flip and attemp to match two hidden number"),
        ],
      ),
    );
  }
}

List<String> numberGenerator(int length)
{
  List<String> numbers = [];
  Random ran = new Random();
  for(int i=0; i<length/2; i++)
    {

      int num = ran.nextInt(100);
      numbers.add(num.toString());
      numbers.add(num.toString());
      print("added");
    }
  numbers.shuffle();

  return numbers;
}