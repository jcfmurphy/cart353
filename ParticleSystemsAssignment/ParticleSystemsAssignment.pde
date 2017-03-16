
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

//The sand image
PImage sand;

//an array of stars
Star[] stars;
/*-----------------------DEFAULT FUNCTIONS--------------------------*/

void setup() {
  size(1600, 1000);

  //initialize the variables
  day = true;

  //initialize the particle system
  ps = new ParticleSystem();

  //initialize the wind
  wind = new Wind();

  //load the sand image
  sand = loadImage("sand_background.png");
  
  //fill the array of stars
  stars = new Star[100];
  for (int i = 0; i < stars.length; i++) {
   stars[i] = new Star();  
  }
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

    //display the sandimage
    image(sand, 0, 700);

    //display the logs
    drawLogs();
  } else {
    background(9, 8, 45);

    //draw the moon
    ellipseMode(CENTER);
    noStroke();
    fill(225);
    ellipse(1400, 100, 160, 160);
    
    //display the stars
    for (Star s : stars) {
     s.display(); 
    }

    //display the sandimage
    image(sand, 0, 700);

    //draw the water
    rectMode(CORNER);
    noStroke();
    fill(9, 6, 35);
    rect(0, 400, width, 300);

    //darken the area outside the radius of the fire using a semi-transparent rectangle with a hole in it
    fill(0, 200);
    noStroke();
    ellipseMode(CENTER);
    beginShape();
    vertex(0, 700);
    vertex(1600, 700);
    vertex(1600, 1000);
    vertex(0, 1000);
    beginContour();
    vertex(650, 850);
    bezierVertex(650, 1000, 950, 1000, 950, 850);
    bezierVertex(950, 700, 650, 700, 650, 850);
    endContour();
    endShape();

    //display the logs
    drawLogs();
  }
}


//function to draw the logs
void drawLogs() {
  pushMatrix();
  translate(700, 800);
  rotate(radians(30));
  fill(149, 98, 15);
  rect(0, 0, 200, 50);
  ellipse(0, 25, 25, 50);
  fill(240, 208, 157);
  ellipse(200, 25, 25, 50);
  popMatrix();

  pushMatrix();
  translate(725, 900);
  rotate(radians(-30));
  fill(149, 98, 15);
  rect(0, 0, 200, 50);
  ellipse(200, 25, 25, 50);
  fill(240, 208, 157);
  ellipse(0, 25, 25, 50);
  popMatrix();
}