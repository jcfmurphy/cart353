/*

Joshua Murphy

This sketch reads from the default video camera and draws colored cubes in 3D space based 
on the colors of the video pixels. 

The pixels to be drawn as cubes each frame are chosen using a Gaussian distribution. 
This distribution is centered in the video image's center with a standard deviation 
equal to 1/6 of the image's dimensions (height/width). This means that pixels are 
updated more often if they are closer to the center of the screen. 

The z-position of each cube is determined using Perlin noise.

*/

import processing.video.*;

//ratio between window size and video resolution
int videoScale;

//number of pixels in the video
int cols, rows;

//a time variable that will be incremented for the noise function
float time;

//Declare a Capture object
Capture video;



void setup() {
  size(1280, 720, P3D);
  background(0);

  videoScale = 4;
  cols = 320;
  rows = 180;
  time = 0;

  //list available cameras and settings in the console
  printArray(Capture.list());

  //Initialize Capture object
  video = new Capture(this, cols, rows);

  //start capturing images
  video.start();
}



void draw() {

  //load the video image pixel array
  video.loadPixels();
  
  //rotate the camera position so that the depth of the image is more visible
  translate(640, 360, 0);
  rotateY(radians(30));
  rotateX(radians(30));
  translate(-440, -360, 0);


  //update 1000 video pixels to the canvas per frame
  for ( int i = 0; i < 1000; i++) {

    //select the pixel to update using the Gaussian distribution centered around the middle of the image
    int xPixel = int((randomGaussian() * cols / 6.0) + cols / 2);
    xPixel = constrain(xPixel, 0, cols - 1);
    int yPixel = int((randomGaussian() * rows / 6.0) + rows / 2);
    yPixel = constrain(yPixel, 0, rows - 1);

    //find the specified position in the pixels array
    int position = (video.width - xPixel - 1) + yPixel * video.width;
    //get the color of this pixel of the video image
    color pixelColor = video.pixels[position];
    
    //find the x and y positions on the canvas for the video pixel
    int x = xPixel * videoScale;
    int y = yPixel * videoScale;
    
    //get a z position based on 2D perlin noise
    int z = int(noise(xPixel / 100.0, yPixel / 100.0, time) * 250);
    
    //draw a box with the z-position based on the Perlin noise
    fill(pixelColor);
    noStroke();
    pushMatrix();
    translate(x, y, z);
    box(videoScale);
    popMatrix();
  }
  
  //increment the time variable for the next frame
  time += 0.01;
  
}



//Whenever a new frame is available...
void captureEvent(Capture video) {
  //Read the image from the camera.
  video.read();
}