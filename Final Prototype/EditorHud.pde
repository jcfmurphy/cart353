//define the class for the in-editor heads-up display

class EditorHud {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the sprite buttons in the hud
  PVector origin = new PVector(0, 50);
  //the width of the sprite portion of the hud
  int hudWidth = 150;
  //the height of the the sprite portion of the hud
  int hudHeight = 900;
  //the background color of the hud
  color bgColor = color(80, 100, 100);

  //arrays of buttons
  Button[] controlButtons;
  Button[] spriteButtons;

  //sum of the heights of all the spriteButtons
  int totalSpriteButtonsHeight = 0;

  //control button images
  PImage left, right, plus, minus, erase, up, down;

  //y-position offset for the hud
  int yOffset;

  //variables for the message when the level is saved
  int saveMessage = -300;
  String message = "This level has been saved as a .json file in the data folder";
  //variables for the message to include a unicorn in the level before saving
  int saveWarning = -300;
  String warning = "The unicorn must be placed in the level before you can save";


  /*----------------------------------- Constructors -----------------------------------*/

  //Constructor
  EditorHud() {
    //load button images
    left = loadImage("left.png");
    right = loadImage("right.png");
    plus = loadImage("plus.png");
    minus = loadImage("minus.png");
    erase = loadImage("erase.png");
    up = loadImage("Up.png");
    down = loadImage("Down.png");


    //fill buttons arrays
    spriteButtons = new Button[8];
    spriteButtons[0] = new Button(0, 0, 150, 150, erase);
    spriteButtons[1] = new Button(0, 150, sprites[1]);
    spriteButtons[2] = new Button(0, 400, sprites[2]);
    spriteButtons[3] = new Button(0, 550, sprites[3]);
    spriteButtons[4] = new Button(0, 700, sprites[4]);
    spriteButtons[5] = new Button(0, 850, sprites[5]);
    spriteButtons[6] = new Button(0, 1000, sprites[6]);
    spriteButtons[7] = new Button(0, 1100, sprites[7]);

    controlButtons = new Button[6];
    controlButtons[0] = new Button(hudWidth, 0, 50, height, left);
    controlButtons[1] = new Button(width - 50, 300, 50, 400, right);
    controlButtons[2] = new Button(width - 50, 0, 50, 300, plus);
    controlButtons[3] = new Button(width - 50, 700, 50, 300, minus);
    controlButtons[4] = new Button(0, 0, hudWidth, 50, up);
    controlButtons[5] = new Button(0, 950, hudWidth, 50, down);

    yOffset = 0;

    for (Button b : spriteButtons) {
      totalSpriteButtonsHeight += b.getHeight();
    }
  }


  /*----------------------------------- Methods ----------------------------------------*/

  //method to display the hud
  void display() {
    //draw the background
    rectMode(CORNER);
    fill(bgColor);
    stroke(0);
    strokeWeight(2);
    rect(origin.x, origin.y, hudWidth, hudHeight);

    //translate to the correct position for the sprite buttons based on the current yOffset
    pushMatrix();
    translate(origin.x, origin.y - yOffset);

    //draw the sprite buttons
    for (Button b : spriteButtons) {
      if (b.getY() >= yOffset && b.getY() < yOffset + hudHeight) {
        b.display();
      }
    }

    popMatrix();

    //draw the control buttons
    for (Button b : controlButtons) {
      b.display();
    }

    //write the current mapWidth and CameraOffset in the editor window
    fill(200, 150);
    textFont(bungee);
    textSize(32);
    textAlign(CENTER, CENTER);
    float textX = system.editor.getOrigin().x + (system.editor.getEditorWidth() * 0.5);
    String text = "Map Width: " + system.editor.getMapWidth() + "   Camera Offset: " + system.editor.getCameraOffset();
    text(text, textX, 50);

    //write the save message to the screen for 150 frames after the user saves the level
    if (frameCount - saveMessage < 150) {
      textSize(52);
      text(message, 200, 0, 1400, 1000);
    }
    //write the save warning to the screen for 150 frames after the user tries to save with no unicorn in the level
    if (frameCount - saveWarning < 150) {
      textSize(52);
      text(warning, 200, 0, 1400, 1000);
    }
  }


  //method to check if a button was pressed and trigger it
  void triggerButton() {
    //record the index of the button
    int buttonIndex = 1000000;
    //record whether the button is from the controlButton array or the indexButton array
    boolean controlButton = false;

    for (int i = 0; i < controlButtons.length; i++) {
      if (controlButtons[i].mouseInButton()) {
        buttonIndex = i;
        controlButton = true;
      }
    }

    if (!controlButton) {
      for (int i = 0; i < spriteButtons.length; i++) {
        if (spriteButtons[i].mouseInButton()) {
          buttonIndex = i;
        }
      }
    }

    //if no buttons were hit, do nothing
    if (buttonIndex == 1000000) {
    } 
    //if a button was hit...
    else {
      //if it's a spriteButton...
      if (!controlButton) {
        //set the selected sprite
        selectedSprite = sprites[buttonIndex];
        buttonClick.trigger();
      } 
      //if it is a control button
      else {
        switch(buttonIndex) {
        case 0:
          system.editor.cameraLeft();
          buttonClick.trigger();
          break;
        case 1:
          system.editor.cameraRight();
          buttonClick.trigger();
          break;
        case 2:
          system.editor.extendMap();
          buttonClick.trigger();
          break;
        case 3:
          system.editor.cutMap();
          buttonClick.trigger();
          break;
        case 4:
          yOffset = constrain(yOffset - 100, 0, totalSpriteButtonsHeight - hudHeight);
          buttonClick.trigger();
          break;
        case 5:
          yOffset = constrain(yOffset + 100, 0, totalSpriteButtonsHeight - hudHeight);
          buttonClick.trigger();
          break;
        }
      }
    }
  }

  void setSaveWarning(int frame) {
    saveWarning = frame;
  }

  void setSaveMessage(int frame) {
    saveMessage = frame;
  }

  int getYOffset() {
    return yOffset;
  }
}