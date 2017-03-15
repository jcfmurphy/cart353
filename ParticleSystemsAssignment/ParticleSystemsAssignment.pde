
/*
Joshua Murphy
 Particle Systems Assignment
 This sketch represents a beachside scene using four particle systems:
 1) Clouds
 2) Waves
 3) Fire
 4) Sparks
 
 */

/*-----------------------IMPORT LIBRARIES--------------------------*/

//import the Iterator class
import java.util.Iterator;


/*-----------------------GLOBAL VARIABLES--------------------------*/

//boolean to determine whether the scene is during the day or at night
boolean day;

//create the particle system for the sketch
ParticleSystem ps;

//create the wind
Wind wind ;
/*-----------------------DEFAULT FUNCTIONS--------------------------*/

void setup() {
  size(1600, 1000);

  //initialize the variables
  day = true;

  //initialize the particle system
  ps = new ParticleSystem();

  //initialize the wind
  wind = new Wind();
}

void draw() {

  //draw the background
  drawBackground();


  //add particles to the particle system
  ps.addParticle();
  //run the particle system
  ps.run();
  
  //update the wind
  wind.update();
}


/*-----------------------CONTROL FUNCTIONS--------------------------*/


void mousePressed() {
  //switch between day and night
  day = !day;
}


/*-----------------------CUSTOM FUNCTIONS --------------------------*/

void drawBackground() {
  if (day) {

    //draw the sky
    background(138, 137, 242);
    
    //draw the sun
    ellipseMode(CENTER);
    noStroke();
    fill(250, 255, 15);
    ellipse(200, 100, 160, 160);

    //draw the water
    rectMode(CORNER);
    noStroke();
    fill(35, 24, 139);
    rect(0, 400, width, 300);

    //draw the sand
    fill(245, 236, 171);
    rect(0, 700, width, 300);
  } else {
    background(18, 17, 90);
  }
}