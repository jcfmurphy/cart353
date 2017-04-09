//define the Button class

class Button {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the button
  PVector position;
  //the width of the button
  int buttonWidth;
  //the height of the button
  int buttonHeight;
  //the image on the button
  PImage buttonImage;
  //the text on the button
  String buttonText;
  //boolean to determine if this is a button in the editor's sprite menu
  boolean spriteButton = false;

  //the background color of the button
  color bgColor = color(80, 100, 100);
  //the hover color of the button
  color hoverColor = color(160, 200, 200);

  /*----------------------------------- Constructors ----------------------------------------*/

  //Constructor for a button using a plain image 
  Button(float x, float y, int tempWidth, int tempHeight, PImage tempImage) {
    position = new PVector (x, y);
    buttonWidth = tempWidth;
    buttonHeight = tempHeight;
    buttonImage = tempImage;
  }

  //Constructor for a button using a sprite for its image
  Button(float x, float y, Sprite sprite) {
    position = new PVector (x, y);
    buttonWidth = 150;
    buttonHeight = sprite.spriteImage.height + 50;
    buttonImage = sprite.spriteImage;
    spriteButton = true;
  }

  //Constuctor for a button using text
  Button(float x, float y, int tempWidth, int tempHeight, String _text) {
    position = new PVector (x, y);
    buttonWidth = tempWidth;
    buttonHeight = tempHeight;
    buttonText = _text;
  }


  /*----------------------------------- Methods ----------------------------------------*/

  void display() {
    rectMode(CORNER);
    stroke(0);
    strokeWeight(2);

    //button changes color with mouse hover
    if (mouseInButton()) {
      fill(hoverColor);
    } else {
      fill(bgColor);
    }

    //display the button image if there is one, or the button text if there is not an image
    if (buttonImage != null) {
      rect(position.x, position.y, buttonWidth, buttonHeight);
      imageMode(CENTER);
      image(buttonImage, position.x + 0.5 * buttonWidth, position.y + 0.5 * buttonHeight);
    } else {
      rect(position.x, position.y, buttonWidth, buttonHeight, 15);
      textFont(bungee);
      textSize(55);
      textAlign(CENTER, CENTER);
      fill(0);
      text(buttonText, position.x + 0.5 * buttonWidth, position.y + 0.4 * buttonHeight);
    }
  }


  //method to check if the mouse is hovering over the button
  boolean mouseInButton() {
    if (spriteButton) {
      if (mouseX >= position.x && mouseX < position.x + buttonWidth &&
        mouseY >= position.y - system.editor.hud.getYOffset() + 50 && mouseY < position.y + buttonHeight - system.editor.hud.getYOffset() + 50) {
        return true;
      } else {
        return false;
      }
    } else {
      if (mouseX >= position.x && mouseX < position.x + buttonWidth &&
        mouseY >= position.y && mouseY < position.y + buttonHeight) {
        return true;
      } else {
        return false;
      }
    }
  }

  float getX() {
    return position.x;
  }

  float getY() {
    return position.y;
  }

  int getHeight() {
    return buttonHeight;
  }
}