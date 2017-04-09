//define the Sprite class

class Sprite {
  /*----------------------------------- Properties -------------------------------------*/

  //the image for the sprite
  PImage spriteImage;
  //the number of the sprite
  int spriteNum;


  /*----------------------------------- Constructors -----------------------------------*/

  //Constructor
  Sprite(int index, String fileName) {
    spriteImage = loadImage(fileName);
    spriteNum = index;
  }


  /*----------------------------------- Methods ----------------------------------------*/

  //method to display the sprite
  void display(float x, float y) {
    imageMode(CORNER);
    image(spriteImage, x, y);
  }
  
  
  int getSpriteNum() {
    return spriteNum;
  }

}