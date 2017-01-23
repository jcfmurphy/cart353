class Raindrop {

  /*----------------------------------- Properties -------------------------------------*/

  //the position
  float x;
  float y;
  //the size
  int radius;
  //the transparency of the raindrop 
  float transparency;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Raindrop() {
    //select random position and size of the raindrop
    x = int(random(orange2.width));
    y = int(random(-20, orange2.height));
    radius = int(random(20, 40));
    transparency = map(mouseX, 0, width, 0, 255);
  }

  void activate() {
    //declare an image to be used for the raindrop effect
    PImage rainPic;

    //use the background boolean to determine which picture 
    //is going to be used for the raindrop effect
    if (background) {
      rainPic = orange2;
    } else {
      rainPic = orange1;
    }

    //Load the pixels of the orange2 source image
    rainPic.loadPixels();

    //determine the location of the raindrop in the pixel array
    int loc = int(x) + int(y) * rainPic.width;
    loc = constrain(loc, 0, rainPic.pixels.length - 1);

    //get the orange2 color at the pixel location
    float r = red(rainPic.pixels[loc]);
    float g = green(rainPic.pixels[loc]);
    float b = blue(rainPic.pixels[loc]);

    //draw the raindrop
    noStroke();
    fill(r, g, b, transparency);
    ellipse(x, y, radius, radius);

    //have the raindrop fall slowly and fade away
    y += 0.5;
    transparency--;
  }

  float getTransparency() {
    return transparency;
  }
}