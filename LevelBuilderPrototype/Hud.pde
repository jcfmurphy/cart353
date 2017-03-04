//define the class for the heads-up display

class Hud {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the hud
  PVector origin = new PVector(0, 0);
  //the width of the hud
  int hudWidth = 150;
  //the height of the hud
  int hudHeight = height;
  //the background color of the hud
  color bgColor = color(80, 100, 100);

  //array of buttons
  Button[] buttons;

  //button images
  PImage left, right, plus, minus, erase;


  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Hud() {
    //load button images
    left = loadImage("left.png");
    right = loadImage("right.png");
    plus = loadImage("plus.png");
    minus = loadImage("minus.png");
    erase = loadImage("erase.png");

    //fill buttons array
    buttons = new Button[9];
    buttons[0] = new Button(0, 0, 150, 150, erase);
    buttons[1] = new Button(0, 150, sprites[1]);
    buttons[2] = new Button(0, 400, sprites[2]);
    buttons[3] = new Button(0, 550, sprites[3]);
    buttons[4] = new Button(0, 700, sprites[4]);
    buttons[5] = new Button(hudWidth, 0, 50, height, left);
    buttons[6] = new Button(width - 50, 300, 50, 400, right);
    buttons[7] = new Button(width - 50, 0, 50, 300, plus);
    buttons[8] = new Button(width - 50, 700, 50, 300, minus);
  }

  //method to display the hud
  void display() {
    //draw the background
    rectMode(CORNER);
    fill(bgColor);
    stroke(0);
    strokeWeight(2);
    rect(origin.x, origin.y, hudWidth, hudHeight);


    //draw the buttons
    for (Button b : buttons) {
      b.display();
    }

    //write the current mapWidth on the editor window
    fill(200, 150);
    textFont(bungee);
    textSize(32);
    textAlign(CENTER, CENTER);
    float textX = editor.getOrigin().x + (editor.getEditorWidth() * 0.5);
    String text = "Map Width: " + editor.getMapWidth() + "   Camera Offset: " + editor.getCameraOffset();
    text(text, textX, 50);
  }


  //method to check if a button was pressed and trigger it
  void triggerButton() {
    //record the index of the button
    int buttonIndex = 1000000;

    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].mouseInButton()) {
        buttonIndex = i;
      }
    }

    //trigger the appropriate action based on the button
    switch(buttonIndex) {
    case 0:
      selectedSprite = sprites[buttonIndex];
      buttonClick.trigger();
      break;
    case 1:
      selectedSprite = sprites[buttonIndex];
      buttonClick.trigger();
      break;
    case 2:
      selectedSprite = sprites[buttonIndex];
      buttonClick.trigger();
      break;
    case 3:
      selectedSprite = sprites[buttonIndex];
      buttonClick.trigger();
      break;
    case 4:
      selectedSprite = sprites[buttonIndex];
      buttonClick.trigger();
      break;
    case 5:
      editor.cameraLeft();
      buttonClick.trigger();
      break;
    case 6:
      editor.cameraRight();
      buttonClick.trigger();
      break;
    case 7:
      editor.extendMap();
      buttonClick.trigger();
      break;
    case 8:
      editor.cutMap();
      buttonClick.trigger();
      break;
    }
  }
}