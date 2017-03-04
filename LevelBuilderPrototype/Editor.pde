//define the class for the editor window

class Editor {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the editor window
  PVector origin = new PVector(200, 0);
  //the width of the editor window
  int editorWidth = 1400;
  //the height of the editor 
  int editorHeight = height;
  //arraylist of gridSquares
  ArrayList<GridSquare> gridSquares;

  //the width of the map
  int mapWidth;
  //x-offset for the camera
  int cameraOffset;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Editor() {

    //Initialize and fill arraylist of gridSquares
    gridSquares = new ArrayList<GridSquare>();

    for (int x = 0; x < width - origin.x - 50; x += gridSize) {
      for (int y = 0; y < height - origin.y; y += gridSize) {
        gridSquares.add(new GridSquare(x, y));
      }
    }

    //start the map at the same width as the editor window
    mapWidth = editorWidth;
    //start with the camera offset at zero
    cameraOffset = 0;
  }

  //method to display the editor window
  void display() {

    pushMatrix();
    translate(origin.x - cameraOffset, origin.y);

    //draw black background
    rectMode(CORNER);
    noStroke();
    fill(0);
    rect(cameraOffset, 0, editorWidth, editorHeight);

    //display the stored gridSquares
    for (GridSquare g : gridSquares) {
      g.display(cameraOffset, editorWidth);
    }

    //draw 100 X 100 pixel grid lines for sprite placement
    for (int x = cameraOffset; x < width - origin.x + cameraOffset; x += gridSize) {
      stroke(100);
      line(x, 0, x, height);
    }
    for (int y = 0; y < height; y += gridSize) {
      stroke(100);
      line(cameraOffset, y, cameraOffset + editorWidth, y);
    }

    popMatrix();
  }


  //method to place the selected sprite into the gridSquare
  void fillGridSquare() {

    //get the gridSquare to be filled
    GridSquare fillSquare = getGridSquare(mouseX + cameraOffset, mouseY);

    //if the selectedSprite is the unicorn... 
    if (selectedSprite.spriteNum == 1) {

      //check all GridSquares
      for (GridSquare g : editor.gridSquares) {
        //empty other unicorn GridSquares
        if (g.sprite.spriteNum == 1) {
          g.sprite = sprites[0];
        }
        //empty the GridSquare below the one being filled
        if (g.position.x == fillSquare.position.x && g.position.y == fillSquare.position.y + gridSize) {
          g.sprite = sprites[0];
        }
      }
    }
    //set the gridSquare's sprite to the current selection
    fillSquare.setSprite(selectedSprite);
  }




  //method to check if a position is in the editor window
  boolean inEditor(float x, float y) {
    if (x >= origin.x && x < origin.x + editorWidth && y >= origin.y && y < height) {
      return true;
    } else {
      return false;
    }
  }


  //method to find the gridSquare at a position
  GridSquare getGridSquare(float x, float y) {
    GridSquare returnSquare = null;

    //check all gridSquares
    for (GridSquare g : editor.gridSquares) {
      if (g.inGridSquare(x, y)) {
        returnSquare = g;
      }
    }

    //returns null if no gridSquares are at this position
    return returnSquare;
  }


  //method to add another column of gridSquares to the right of the map
  void extendMap() {
    //add a new column of gridSquares
    for (int y = 0; y < height; y += 100) {
      gridSquares.add(new GridSquare(mapWidth, y));
    }
    //increment the mapWidth and cameraOffset variables
    mapWidth += 100;
    cameraOffset += 100;
  }

  //method to cut a column of gridSquares on the right of the map
  void cutMap() {
    if (mapWidth > editorWidth) {
      //decrement the mapWidth and cameraOffset variables
      mapWidth -= 100;
      if (cameraOffset >= 100) {
        cameraOffset -= 100;
      }

      //remove all the gridsquares that are beyond the new width of the map
      for (int i = gridSquares.size() - 1; i >= 0; i--) {
        GridSquare cutSquare = gridSquares.get(i);
        if (cutSquare.position.x >= mapWidth) {
          gridSquares.remove(i);
        }
      }
    }
  }
}