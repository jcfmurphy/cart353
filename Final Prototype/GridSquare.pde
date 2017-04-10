//define the class for the GridSquare, the basic building-block for the level map

class GridSquare {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the GridSquare
  PVector position;
  //the sprite occupying the GridSquare
  Sprite sprite;

  //store whether the sprite is a barrier, water
  boolean barrier = false;
  boolean water = false;
  boolean platform = false;


  /*----------------------------------- Constructors -----------------------------------*/

  //The basic constructor defaults to the empty sprite
  GridSquare(float x, float y) {
    position = new PVector(x, y);
    sprite = sprites[0];
  }


  //Constructor that sets a specified sprite
  GridSquare(float x, float y, Sprite tempSprite) {
    position = new PVector(x, y);
    sprite = tempSprite;
    //set the tile as a platform, obstacle, or water tile based on spriteNum
    if (sprite.getSpriteNum() == 2) {
      platform = true;
    } else if (sprite.getSpriteNum() == 3 || sprite.getSpriteNum() == 7) {
      barrier = true;
    } else if (sprite.getSpriteNum() == 4 || sprite.getSpriteNum() == 5) {
      water = true;
    }
  }


  /*----------------------------------- Methods ----------------------------------------*/

  //method to display the gridSquare in the editor window based on the sprite it contains
  void editorDisplay(int cameraOffset, int editorWidth) {
    if (position.x >= cameraOffset && position.x < cameraOffset + editorWidth) {
      //display the stored sprite
      sprite.displayImage(position.x, position.y);

      //if the mouse is over this gridSquare, display the selected sprite over the stored one
      if (mouseX - system.editor.origin.x + cameraOffset >= position.x && mouseX - system.editor.origin.x + cameraOffset < position.x + gridSize &&
        mouseY >= position.y && mouseY < position.y + gridSize) {
        selectedSprite.displayImage(position.x, position.y);
      }
    }
  }

  //method to display the gridSquare in the game window based on the sprite it contains
  void gameDisplay(int cameraOffset, int gameWidth) {
    if (position.x >= cameraOffset - 100 && position.x < cameraOffset + gameWidth) {
      //display the stored sprite
      sprite.displayImage(position.x, position.y);
    }
  }

  //method to check whether a position is within a grid square
  boolean inGridSquare(float x, float y) { 
    if (x - system.editor.origin.x >= position.x && x - system.editor.origin.x < position.x + gridSize &&
      y >= position.y && y < position.y + gridSize) {
      return true;
    } else {
      return false;
    }
  }


  void setSprite(Sprite tempSprite) {
    sprite = tempSprite;
  }


  Sprite getSprite() {
    return sprite;
  }

  boolean getBarrier() {
    return barrier;
  }

  boolean getWater() {
    return water;
  }

  boolean getPlatform() {
    return platform;
  }

  float getXPos() {
    return position.x;
  }

  float getYPos() {
    return position.y;
  }
}