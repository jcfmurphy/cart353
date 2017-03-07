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

  //the background color of the button
  color bgColor = color(80, 100, 100);
  //the hover color of the button
  color hoverColor = color(160, 200, 200);

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructors
  Button(int x, int y, int tempWidth, int tempHeight, PImage tempImage) {
    position = new PVector (x, y);
    buttonWidth = tempWidth;
    buttonHeight = tempHeight;
    buttonImage = tempImage;
  }
  Button(int x, int y, Sprite sprite) {
    position = new PVector (x, y);
    buttonWidth = sprite.spriteImage.width + 50;
    buttonHeight = sprite.spriteImage.height + 50;
    buttonImage = sprite.spriteImage;
  }


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

    rect(position.x, position.y, buttonWidth, buttonHeight);

    imageMode(CENTER);
    image(buttonImage, position.x + 0.5 * buttonWidth, position.y + 0.5 * buttonHeight);
  }


  //method to check if the mosue is hovering over the button
  boolean mouseInButton() {
    if (mouseX >= position.x && mouseX < position.x + buttonWidth &&
      mouseY >= position.y && mouseY < position.y + buttonHeight) {
      return true;
    } else {
      return false;
    }
  }
}