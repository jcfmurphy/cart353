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
  color bgColor = color(20, 25, 25);
  PImage unicornIcon = loadImage("UnicornIdleRight_000.png");
  PImage title = loadImage("Title.png");
  
  color textColor = color(255, 105, 180);

  //array of rainbow colors for arcShot display
  color[] colors = {color(255, 0, 0), 
    color(255, 127, 0), 
    color(255, 255, 0), 
    color(0, 255, 0), 
    color(0, 0, 255), 
    color(75, 0, 130), 
    color(143, 0, 255)};


  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  GameHud() {
    unicornIcon.resize(75, 151);
    title.resize(220, 68);
  }

  //method to display the hud
  void display() {
    //draw the background
    rectMode(CORNER);
    fill(bgColor);
    stroke(0);
    strokeWeight(2);
    rect(position.x, position.y, hudWidth, hudHeight);

    //display the title
    image(title, 15, 50);

    //show the player's score
    fill(textColor);
    textFont(bungee);
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Score:", 125, 210);
    textSize(56);
    text(nf(system.game.getScore(), 6), 125, 280);

    //show the number of lives left
    image(unicornIcon, 20, 420);
    textSize(60);
    text("X", 125, 495);
    textSize(100);
    text(system.game.getLives(), 200, 490);

    //show the current weapon
    textSize(48);
    text("Weapon:", 125, 700);
    stroke(textColor);
    strokeWeight(8);
    noFill();
    rectMode(CENTER);
    rect(125, 850, 200, 200, 15);

    if (system.game.getCurrentWeapon() == "ArcShot") {
      ellipseMode(CENTER);
      noStroke();
      for (int i = 0; i < colors.length; i++) {
        fill(colors[i]);
        arc(125, 850, 180, 180, i * 0.25 * PI, (i + 1) * 0.25 * PI);
      }
    } else if (system.game.getCurrentWeapon() == "SquareShot") {
      
    }
  }
}