//define the Sprite class

class Sprite {
  /*----------------------------------- Properties -------------------------------------*/

  //the image for the sprite
  PImage spriteImage;
  //The icon used for the sprite button
  PImage spriteIcon;
  //the number of the sprite
  int spriteNum;


  /*----------------------------------- Constructors -----------------------------------*/

  //Constructor
  Sprite(int index, String ImageName, String IconName) {
    spriteImage = loadImage(ImageName);
    spriteIcon = loadImage(IconName);
    spriteNum = index;
  }


  /*----------------------------------- Methods ----------------------------------------*/

  //method to display the sprite image
  void displayImage(float x, float y) {
    imageMode(CORNER);
    image(spriteImage, x, y);
  }

  //method to display the sprite icon
  //method to display the sprite image
  void displayIcon(float x, float y) {
    imageMode(CORNER);
    image(spriteIcon, x, y);
  }

  int getSpriteNum() {
    return spriteNum;
  }
}