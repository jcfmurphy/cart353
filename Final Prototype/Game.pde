//define the class for the Game 

class Game {
  /*----------------------------------- Properties -------------------------------------*/
  //the position of the game window
  PVector origin = new PVector(250, 0);
  //the width of the game window
  int gameWidth = 1400;  
  //the in-game heads-up display
  GameHud hud;

  //arraylist of gridSquares
  ArrayList<GridSquare> gridSquares;
  //the width of the map in pixels
  float mapWidth;
  //x-position offset for the camera
  int cameraOffset;
  //The level number
  int level;

  //the unicorn player character
  Unicorn unicorn;
  //number of lives remaining
  int lives;

  //arraylist of enemies
  ArrayList<Enemy> enemies;

  //the force of gravity
  PVector gravity = new PVector(0, 1.5);
  PVector waterGravity = new PVector(0, 0.3);

  //coefficient of drag in water
  float dragC = 0.03;

  //coefficient of friction of the ground
  float frictionC = 0.35;
  
  //boolean to track whether the game is over
  boolean gameOver = false;


  /*--------------------------------- Constructors -------------------------------------*/

  //Constructor for creating a new game
  Game() {

    //initialize the arraylists
    gridSquares = new ArrayList<GridSquare>();
    enemies = new ArrayList<Enemy>();

    //set the string to load the first level
    level = 1;
    String levelString = "level" + level +".json";

    //load the map
    loadMap(levelString);

    //set the starting camera offset
    updateOffset();

    //instantiate the heads-up display
    hud = new GameHud();
  }

  /*----------------------------------- Methods ----------------------------------------*/

  //calls the functions needed to run the game
  void display() {

    //translate to the correct map position based on the editor window origin and camera position
    pushMatrix();
    translate(origin.x - cameraOffset, origin.y);

    //draw black background
    rectMode(CORNER);
    noStroke();
    fill(0, 100, 190);
    rect(cameraOffset, 0, gameWidth, height);

    //display the gridSquares
    for (GridSquare g : gridSquares) {
      g.gameDisplay(cameraOffset, gameWidth);
    }

    //update the unicorn
    unicorn.update();

    for (int i = enemies.size() - 1; i >= 0; i--) {
      enemies.get(i).update();
      enemies.get(i).hitUnicorn(unicorn);
    }

    //display the unicorn
    unicorn.display();

    for (int i = enemies.size() - 1; i >= 0; i--) {
      enemies.get(i).display();
    }

    //update the camera offset
    updateOffset();

    popMatrix();

    hud.display();
  }

  //function to load a level from a JSON file
  void loadMap(String fileName) {
    //create a JSONArray to hold the map
    JSONArray mapArray = new JSONArray();
    //fill the mapArray from the JSON file using the fileName
    mapArray = loadJSONArray(fileName);
    //calculate the mapWidth from the size of the array
    mapWidth = mapArray.size() * 0.1 * 100;

    //create the individual gridSquares from the JSONObjects
    for (int i = 0; i < mapArray.size(); i++) {
      //load the JSON object
      JSONObject jsonSquare = mapArray.getJSONObject(i);

      //unpack the variables
      float jsonX = jsonSquare.getFloat("x");
      float jsonY = jsonSquare.getFloat("y");
      int jsonNum = jsonSquare.getInt("spriteNum");

      if (jsonNum == 0) {
        //do nothing because this is an empty sprite
      } else if (jsonNum == 1) {
        //create the unicorn
        unicorn = new Unicorn(jsonX, jsonY);
      } else if (jsonNum == 6) {
        enemies.add(new Slime(jsonX, jsonY));
      } else {
        //Create a new gridSquare and add it to the listArray
        gridSquares.add(new GridSquare(jsonX, jsonY, sprites[jsonNum]));
      }
    }
  }

  void updateOffset() {
    //the location of the ideal offset given the unicorn's location and direction
    float goalOffset; 
    if (unicorn.getFaceRight()) {
      goalOffset = unicorn.getXPos() - gameWidth * 0.3;
    } else {
      goalOffset = unicorn.getXPos() - gameWidth * 0.7;
    }
    
    //ease toward the ideal offset
    cameraOffset = int(0.9 * cameraOffset + 0.1 * goalOffset);
    cameraOffset = int(constrain(cameraOffset, 0, mapWidth - gameWidth));
  }
  
  void setGameOver(boolean over) {
    gameOver = over;
  }

  PVector getGravity() {
    return gravity;
  }
  PVector getWaterGravity() {
    return waterGravity;
  }

  float getDragC() {
    return dragC;
  }

  float getFrictionC() {
    return frictionC;
  }

  float getMapWidth() {
    return mapWidth;
  }

  float getOffset() {
    return cameraOffset;
  }

  int getGameWidth() {
    return gameWidth;
  }
}