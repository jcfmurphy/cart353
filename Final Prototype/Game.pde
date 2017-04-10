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

  //arraylist of projectiles
  ArrayList<Projectile> projectiles;

  //the force of gravity
  PVector gravity = new PVector(0, 1.5);
  PVector waterGravity = new PVector(0, 0.3);

  //coefficient of drag in water
  float dragC = 0.03;

  //coefficient of friction of the ground
  float frictionC = 0.35;

  //boolean to track whether the game is over
  boolean gameOver = false;

  //tracks the unicorn's current weapon
  String currentWeapon = "ArcShot";



  /*--------------------------------- Constructors -------------------------------------*/

  //Constructor for creating a new game
  Game() {

    //initialize the arraylists
    gridSquares = new ArrayList<GridSquare>();
    enemies = new ArrayList<Enemy>();
    projectiles = new ArrayList<Projectile>();

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
      Enemy e = enemies.get(i);
      e.update();
      e.hitUnicorn(unicorn);
      if (e.getDead()) {
        enemies.remove(i);
      } else {
        e.display();
      }
    }

    for (int i = projectiles.size() - 1; i >= 0; i--) {
      Projectile p = projectiles.get(i);
      p.update();
      
      //hit intersecting enemies (if it is a enemy-hitter)
      for (Enemy e : enemies) {
        p.hitEnemy(e);
      }
      
      //hit the unicorn if it is intersecting and a unicorn-hitter
      p.hitUnicorn(unicorn);

      if (p.getActive()) {
        p.display();
      } else {
        projectiles.remove(i);
      }
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

  //find a position where the unicorn can respawn after dying
  PVector safePosition() {

    for (int i = gridSquares.size() - 1; i >=0; i--) {
      GridSquare g = gridSquares.get(i);

      if (g.getXPos() <= unicorn.getXPos() &&
        g.getYPos() >= 200 &&
        (g.getBarrier() || g.getPlatform())) {
        if (!checkForBarrier(g.getXPos(), g.getYPos() - 100) && !checkForBarrier(g.getXPos(), g.getYPos() - 200)) {
          return new PVector(g.getXPos(), g.getYPos() - 190);
        }
      }
    }

    //fallback in case no safe position was found
    return new PVector(0, 0);
  }

  //check whether there is a barrier-type tile at a given location
  boolean checkForBarrier(float x, float y) {

    for (GridSquare g : gridSquares) {
      if (g.getXPos() == int(x * 0.01) * 100 && 
        g.getYPos() == int(y * 0.01) * 100 &&
        g.getBarrier()) {
        return true;
      }
    }

    return false;
  }

  void shoot() {
    if (!unicorn.getHit()) {
      if (currentWeapon == "ArcShot") {
        projectiles.add(new ArcShot(unicorn.getShotXPos(), unicorn.getShotYPos(), unicorn.getFaceRight()));
        arcSound.trigger();
      }
    }
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
  
  void setCurrentWeapon(String weapon) {
    currentWeapon = weapon;
  }
}