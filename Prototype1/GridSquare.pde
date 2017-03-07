//define the class for the GridSquare

class GridSquare {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the GridSquare
  PVector position;
  //the sprite occupying the GridSquare
  Sprite sprite;


  /*----------------------------------- Methods ----------------------------------------*/

  //Basic constructor
  GridSquare(float x, float y) {
    position = new PVector(x, y);
    sprite = sprites[0];
  }


  //Constructor that sets a sprite
  GridSquare(float x, float y, Sprite tempSprite) {
    position = new PVector(x, y);
    sprite = tempSprite;
  }


  void display(int cameraOffset, int editorWidth) {
    if (position.x >= cameraOffset && position.x < cameraOffset + editorWidth) {
      //display the stored sprite
      sprite.display(position.x, position.y);


      //if the mouse is over this gridSquare, display the selected sprite over the stored one
      if (mouseX - editor.origin.x + cameraOffset >= position.x && mouseX - editor.origin.x + cameraOffset < position.x + gridSize &&
        mouseY >= position.y && mouseY < position.y + gridSize) {
        selectedSprite.display(position.x, position.y);
      }
    }
  }

  //method to check whether a position is within a grid square
  boolean inGridSquare(float x, float y) { 
    if (x - editor.origin.x >= position.x && x - editor.origin.x < position.x + gridSize &&
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
}