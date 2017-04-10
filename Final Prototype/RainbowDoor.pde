//define the RainbowDoor class

class RainbowDoor {

  /*----------------------------------- Properties -------------------------------------*/

  PVector position;
  int doorWidth = 300;
  int doorHeight = 300;

  PImage doorImage = loadImage("RainbowDoor.png");

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  RainbowDoor(float x, float y) {
    position = new PVector(x, y);
  }



  //method to draw the RainbowDoor
  void display() {    
    image(doorImage, position.x, position.y);
  }

  //method to end the level if the unicorn touches the rainbow door
  void intersectUnicorn(Unicorn u) {
    if (!u.getHit() &&
      position.y + doorHeight > u.getYPos() &&
      position.y < u.getYPos() + u.getHeight() &&
      position.x + doorWidth > u.getXPos() &&
      position.x < u.getXPos() + u.getWidth()) {
        system.game.setEndLevel(true);
      }
    }
  }