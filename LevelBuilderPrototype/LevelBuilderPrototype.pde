
/*
This is the prototype for the Ammunicorn Level Builder.
 Use the mouse to select tiles and place them in the editor grid.
 Press the 's' key to save the map as a JSON file.
 The up key extends the map to the right.
 The down key cuts off a map column on the right.
 The left key moves the map camera left.
 The right key moves the map camera right.
 */



/*-----------------------IMPORT LIBRARIES--------------------------*/

//import the Minim library
import ddf.minim.*;

/*-----------------------GLOBAL VARIABLES--------------------------*/

//Declare editor window
Editor editor;

//Declare the heads-up display
Hud hud;

//the size of the grid for sprite placement
int gridSize = 100;

//Declare minim variable and audio variables
Minim minim;
AudioSample buttonClick;
AudioSample pop;

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

  //instantiate editor window with an empty map
  editor = new Editor();

  ////instantiate editor window with a map loaded from a JSON file
  //editor = new Editor("gridSquares13;22;9.json");

  //instantiate the heads-up display
  hud = new Hud();

  //load buttonClick audio sample
  minim = new Minim(this);
  buttonClick = minim.loadSample("buttonClick.wav", 512);
  pop = minim.loadSample("pop.wav", 512);

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
  if (key == CODED) {
    if (keyCode == LEFT) {
      //left key moves camera left      
      editor.cameraLeft();
    } else if (keyCode == RIGHT) {
      //right key moves camera right
      editor.cameraRight();
    } else if (keyCode == UP) {
      //up key extends the map
      editor.extendMap();
    } else if (keyCode == DOWN) {
      //down key cuts a column off the right side of the map
      editor.cutMap();
    }
  } else if (key == 's' || key == 'S') {
    editor.saveMap();
  }
}

/*-----------------------CUSTOM FUNCTIONS--------------------------*/