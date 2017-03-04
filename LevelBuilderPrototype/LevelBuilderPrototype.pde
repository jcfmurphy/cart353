
/*
This is the prototype for the Ammunicorn Level Builder.
 Use the mouse to select tiles and place them in the editor grid.
 Press the 's' key to save the map as a JSON file.
 Use the '+' buttons on the left and right of the map editor window
 to extend the map to the left or right.
 */



/*-----------------------IMPORT LIBRARIES--------------------------*/

//import the Minim library
import ddf.minim.*;

/*-----------------------GLOBAL VARIABLES--------------------------*/

//Declare editor window
Editor editor;

//Declare the heads-up display
Hud hud;

//the erase button image
PImage eraseImage;

//the size of the grid for sprite placement
int gridSize = 100;

//Declare minim variable and audio variables
Minim minim;
AudioSample buttonClick;

//create an array of sprites
Sprite[] sprites;

//store the selected sprite
Sprite selectedSprite;

//declare the text font
PFont bungee;


/*-----------------------DEFAULT FUNCTIONS--------------------------*/

void setup() {
  size(1650, 1000);

  //fill the sprite array
  sprites = new Sprite[5];
  sprites[0] = new Sprite(0, "empty.png");
  sprites[1] = new Sprite(1, "unicorn.png");
  sprites[2] = new Sprite(2, "red_0.png");
  sprites[3] = new Sprite(3, "green_0.png");
  sprites[4] = new Sprite(4, "blue_0.png");

  //instantiate editor window and hud
  editor = new Editor();
  hud = new Hud();

  //load the erase image
  eraseImage= loadImage("erase.png");

  //load buttonClick audio sample
  minim = new Minim(this);
  buttonClick = minim.loadSample("buttonClick.wav", 512);

  //set the selected sprite
  selectedSprite = sprites[0];

  //load the font
  bungee = createFont("Bungee-Regular.ttf", 40);
}

void draw() {
  editor.display();
  hud.display();
}



/*-----------------------CONTROL FUNCTIONS--------------------------*/


void mousePressed() {
  //if in the map editor window...
  if (editor.inEditor(mouseX, mouseY)) {
    //fill the grid square with the selected sprite
    editor.fillGridSquare();
  } else {
    hud.triggerButton();
  }
}


void mouseDragged() {
  //if in the map editor window...
  if (editor.inEditor(mouseX, mouseY)) {
    //fill the grid square with the selected sprite
    editor.fillGridSquare();
  }
}


void keyPressed() {
  if (key == 's' || key == 'S') {
    saveMap();
  }
}

/*-----------------------CUSTOM FUNCTIONS--------------------------*/

//save the map to a JSON file
void saveMap() {
  //create a JSONArray to hold the gridsquares
  JSONArray jsonGridSquares = new JSONArray();

  //fill the JSONArray
  for (int i = 0; i < editor.gridSquares.size(); i++) {

    //get the gridSquare
    GridSquare tempSquare = editor.gridSquares.get(i);

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
}