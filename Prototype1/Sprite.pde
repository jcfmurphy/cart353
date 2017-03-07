//define the Sprite class

class Sprite {
  /*----------------------------------- Properties -------------------------------------*/

  //the image for the sprite
  PImage spriteImage;
  //the number of the sprite
  int spriteNum;
  //the button of the sprite
  Button spriteButton;


  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Sprite(int index, String fileName) {
    spriteImage = loadImage(fileName);
    spriteNum = index;
  }


  void display(float x, float y) {
    imageMode(CORNER);
    image(spriteImage, x, y);
  }
  
  
  int getSpriteNum() {
    return spriteNum;
  }

}