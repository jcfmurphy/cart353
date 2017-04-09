//define the class for the in-game heads-up display

class GameHud {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the hud
  PVector position = new PVector(0, 0);
  //the width of the hud
  int hudWidth = 250;
  //the height of the hud
  int hudHeight = height;
  //the background color of the hud
  color bgColor = color(80, 100, 100);
  PImage unicornIcon = loadImage("UnicornIdleRight_000.png");


  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  GameHud() {
    unicornIcon.resize(50, 101);
  }

  //method to display the hud
  void display() {
    //draw the background
    rectMode(CORNER);
    fill(bgColor);
    stroke(0);
    strokeWeight(2);
    rect(position.x, position.y, hudWidth, hudHeight);

    //show the number of lives left
    image(unicornIcon, 25, 100);
    fill(0);
    textFont(bungee);
    textSize(60);
    textAlign(CENTER, CENTER);
    text("X", 125, 145);
    textSize(100);
    text(system.game.unicorn.getLives(), 200, 140);
  }
}