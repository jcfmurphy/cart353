
/*
This is the final prototype for AmmUnicorn 
 
 Level Editor:
 Use the mouse to select tiles and place them in the editor grid.
 Press the 's' key to save the map as a JSON file.
 The up key extends the map to the right.
 The down key cuts off a map column on the right.
 The left key moves the map camera left.
 The right key moves the map camera right.
 
 Game:
 Use WASD keys to move
 SPACE to jump
 Mouse-click to shoot
 */



/*-----------------------IMPORT LIBRARIES--------------------------*/

//import the Minim library
import ddf.minim.*;

/*-----------------------GLOBAL VARIABLES--------------------------*/


//the size of the grid for sprite placement
int gridSize = 100;

//Declare minim variable and audio variables
Minim minim;
AudioSample buttonClick;
AudioSample pop;
AudioSample unicornJump;
AudioSample waterJump;
AudioSample splash;
AudioSample slimeSound;
AudioSample deathGrunt;
AudioSample arcSound;
AudioSample slimeDeath;

AudioPlayer music;

//create an array of sprites
Sprite[] sprites;

//store the selected sprite
Sprite selectedSprite;

//booleans for whether each of the in-game directional keys is being pressed
boolean w, a, s, d;

//declare the text font
PFont bungee;

//Create a new system
System system;

//Create the input controller
Controls controller;


/*-----------------------DEFAULT FUNCTIONS--------------------------*/

void setup() {
  size(1650, 1000);

  //set the frameRate to 30 frames per second
  frameRate(30);

  //fill the sprite array
  sprites = new Sprite[9];
  sprites[0] = new Sprite(0, "empty.png", "empty.png");
  sprites[1] = new Sprite(1, "UnicornIdleRight_000.png", "UnicornIdleRight_000.png");
  sprites[2] = new Sprite(2, "Platform.png", "Platform.png");
  sprites[3] = new Sprite(3, "Grass.png", "Grass.png");
  sprites[4] = new Sprite(4, "WaterTop.png", "WaterTop.png");
  sprites[5] = new Sprite(5, "WaterBottom.png", "WaterBottom.png");
  sprites[6] = new Sprite(6, "SlimeWalkLeft_000.png", "SlimeIcon.png");
  sprites[7] = new Sprite(7, "Dirt.png", "Dirt.png");
  sprites[8] = new Sprite(8, "RainbowDoor.png", "RainbowDoorIcon.png");


  //load buttonClick audio sample
  minim = new Minim(this);
  buttonClick = minim.loadSample("buttonClick.wav", 512);
  pop = minim.loadSample("pop.wav", 512);
  unicornJump = minim.loadSample("UnicornJump.wav", 512);
  waterJump = minim.loadSample("WaterJump.wav", 512);
  splash = minim.loadSample("splash.wav", 512);
  slimeSound = minim.loadSample("slimeSound.wav", 512);
  deathGrunt = minim.loadSample("deathGrunt.wav", 512);
  arcSound = minim.loadSample("arcSound.wav", 512);
  slimeDeath = minim.loadSample("SlimeDeath.wav", 512);

  music = minim.loadFile("music.wav");

  //set the selected sprite
  selectedSprite = sprites[0];

  //initialize the directional booleans
  w = false;
  a = false;
  s = false;
  d = false;

  //load the font
  bungee = createFont("Bungee-Regular.ttf", 40);

  //instantiate the system and contol scheme
  system = new System();
  controller = new Controls(system);
}

void draw() {
  system.run();
}



/*-----------------------CONTROL FUNCTIONS--------------------------*/


void mousePressed() {
  controller.mousePress();
}


void mouseReleased() {
  controller.mouseRelease();
}


void mouseDragged() {
  controller.mouseDrag();
}


void keyPressed() {
  controller.keyPress();
}


void keyReleased() {
  controller.keyRelease();
}

/*-----------------------CUSTOM FUNCTIONS--------------------------*/