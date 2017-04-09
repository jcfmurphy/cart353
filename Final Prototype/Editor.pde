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
  //The hud for the editor
  EditorHud hud;

  //the width of the map
  int mapWidth;
  //x-position offset for the camera
  int cameraOffset;


  /*--------------------------------- Constructors -------------------------------------*/

  //Constructor for creating a new editor
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

    //create a new hud for the editor
    hud = new EditorHud();
  }


  //Constructor for loading a map from a JSON file
  Editor(String fileName) {

    //Initialize arraylist of gridSquares
    gridSquares = new ArrayList<GridSquare>();

    //load the map
    loadMap(fileName);

    //set the mapWidth based on the size of the gridSquares arrayList
    mapWidth = gridSquares.size() * 10;

    //start with the camera offset at zero
    cameraOffset = 0;

    //create a new hud for the editor
    hud = new EditorHud();
  }

  /*----------------------------------- Methods ----------------------------------------*/

  //method to display the editor window
  void display() {

    //translate to the correct map position based on the editor window origin and camera position
    pushMatrix();
    translate(origin.x - cameraOffset, origin.y);

    //draw black background
    rectMode(CORNER);
    noStroke();
    fill(0);
    rect(cameraOffset, 0, editorWidth, editorHeight);

    //display the stored gridSquares
    for (GridSquare g : gridSquares) {
      g.editorDisplay(cameraOffset, editorWidth);
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

    //display the editor hud
    hud.display();
  }


  //method to place the selected sprite into the gridSquare
  void fillGridSquare() {

    //get the gridSquare to be filled
    GridSquare fillSquare = findGridSquare(mouseX + cameraOffset, mouseY);

    //if the selectedSprite is the unicorn... 
    if (selectedSprite.getSpriteNum() == 1) {

      //check all GridSquares
      for (GridSquare g : gridSquares) {
        //empty other unicorn GridSquares
        if (g != fillSquare) {
          if (g.getSprite().getSpriteNum() == 1) {
            g.setSprite(sprites[0]);
          }
        }
        //empty the GridSquare below the one being filled
        if (g.position.x == fillSquare.position.x && g.position.y == fillSquare.position.y + gridSize) {
          g.setSprite(sprites[0]);
        }
      }
    } else {
      //Get the gridSquare above and check if it contains the unicorn sprite...
      if (mouseY >= 100) {
        GridSquare aboveSquare = findGridSquare(mouseX + cameraOffset, mouseY - gridSize);
        if (aboveSquare.getSprite().getSpriteNum() == 1) {
          aboveSquare.setSprite(sprites[0]);
          pop.trigger();
        }
      }
    }

    //if the selected sprite is different from the current sprite in the gridSquare...
    if (selectedSprite.getSpriteNum() != fillSquare.getSprite().getSpriteNum()) {
      //set the gridSquare's sprite to the current selection
      fillSquare.setSprite(selectedSprite);
      //play a sound
      pop.trigger();
    }
  }




  //method to check if a position is in the editor window
  boolean inGrid(float x, float y) {
    if (x >= origin.x && x < origin.x + editorWidth && y >= origin.y && y < height) {
      return true;
    } else {
      return false;
    }
  }


  //method to find the gridSquare at a position
  GridSquare findGridSquare(float x, float y) {
    GridSquare returnSquare = null;

    //check all gridSquares
    for (GridSquare g : gridSquares) {
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


  //method to move the editor window camera to the left
  void cameraLeft() {
    if (cameraOffset >= 100) {
      cameraOffset -= 100;
    }
  }


  //method to move the editor window camera to the right
  void cameraRight() {
    if (cameraOffset < mapWidth - editorWidth) {
      cameraOffset += 100;
    }
  }


  //function to save the map to a JSON file
  void saveMap() {
    //check to see if there is a unicorn in the level
    boolean unicornExists = false;
    for (GridSquare g : gridSquares) {
      if (g.getSprite().getSpriteNum() == 1) {
        unicornExists = true;
      }
    }

    //only save the map if there is a unicorn in there
    if (unicornExists) {
      //create a JSONArray to hold the gridsquares
      JSONArray jsonGridSquares = new JSONArray();

      //fill the JSONArray
      for (int i = 0; i < gridSquares.size(); i++) {

        //get the gridSquare
        GridSquare tempSquare = gridSquares.get(i);

        //create a new JSONObject and fill it with gridSquare info
        JSONObject jGridSquare = new JSONObject();
        jGridSquare.setFloat("x", tempSquare.position.x);
        jGridSquare.setFloat("y", tempSquare.position.y);
        if (tempSquare.sprite != null) {
          jGridSquare.setInt("spriteNum", tempSquare.sprite.spriteNum);
        } else {
          jGridSquare.setInt("spriteNum", 0);
        }

        //add the JSONObject to the JSONArray
        jsonGridSquares. setJSONObject(i, jGridSquare);
      }

      saveJSONArray(jsonGridSquares, "data/gridSquares" + hour() + ";" + minute() + ";" + second() + ".json");
    } else {
      hud.setSaveMessage(frameCount);
    }
  }


  //function to load a map from a JSON file
  void loadMap(String fileName) {
    //create a JSONArray to hold the map
    JSONArray mapArray = new JSONArray();
    //fill the mapArray from the JSON file using the fileName
    mapArray = loadJSONArray(fileName);

    //create the individual gridSquare from each JSONObject
    for (int i = 0; i < mapArray.size(); i++) {
      //load the JSON object
      JSONObject jsonSquare = mapArray.getJSONObject(i);

      //unpack the variables
      float jsonX = jsonSquare.getFloat("x");
      float jsonY = jsonSquare.getFloat("y");
      int jsonNum = jsonSquare.getInt("spriteNum");

      //Create a new gridSquare and add it to the listArray
      gridSquares.add(new GridSquare(jsonX, jsonY, sprites[jsonNum]));
    }
  }


  int getMapWidth() {
    return mapWidth;
  }

  PVector getOrigin() {
    return origin;
  }

  int getEditorWidth() {
    return editorWidth;
  }

  int getCameraOffset() {
    return cameraOffset;
  }
}