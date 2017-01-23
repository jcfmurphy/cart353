class Differentiator {

  /*----------------------------------- Properties -------------------------------------*/
  float x;
  float y;
  int radius;
  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Differentiator() {
    x = 0;
    y = 0;
    radius = 80;
  }

  void activate() {

    //set the x and y positions to follow the mouse
    x = mouseX;
    y = constrain(mouseY, 0, orange1.height);

    //Load the pixels of the source images and the canvas
    orange1.loadPixels();
    orange2.loadPixels();
    loadPixels();

    for (int i = 0; i < orange1.width; i++) {
      for  (int j = 0; j < orange1.height; j++) {
        //if the distance of the pixel is less than the radius of the differentiator
        if (dist(x, y, i, j) <= radius) {
          //find the pixel location in the array
          int loc = i + j * orange1.width;
          loc = constrain(loc, 0, orange1.pixels.length - 1);
          
          //get the absolute value of the difference between the color values
          //for the two source images at that pixel location
          float diffR = abs(red(orange1.pixels[loc]) - red(orange2.pixels[loc]));
          float diffG = abs(green(orange1.pixels[loc]) - green(orange2.pixels[loc]));
          float diffB = abs(blue(orange1.pixels[loc]) - blue(orange2.pixels[loc]));
          
          //set the pixel of the canvas to the color values of these differences
          pixels[loc] = color(diffR, diffG, diffB);
        }
      }
    }
    
    //update the canvas pixels
    updatePixels();
  }
}