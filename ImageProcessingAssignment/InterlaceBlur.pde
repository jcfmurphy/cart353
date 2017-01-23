class InterlaceBlur {

  /*----------------------------------- Properties -------------------------------------*/
  //position and size of the blur window
  int xStart;
  int xEnd;
  int yStart;
  int yEnd;
  int size;
  
  float matrixValue = 1f / 25f;

  //the convolution matrix
  float[][] blurMatrix = 
    {{matrixValue, matrixValue, matrixValue, matrixValue, matrixValue}, 
    {matrixValue, matrixValue, matrixValue, matrixValue, matrixValue}, 
    {matrixValue, matrixValue, matrixValue, matrixValue, matrixValue},
    {matrixValue, matrixValue, matrixValue, matrixValue, matrixValue},
    {matrixValue, matrixValue, matrixValue, matrixValue, matrixValue}};
  ;
  int matrixSize = 5;

  //an intermediate image to hold the interlaced pixels from the source images
  PImage intermediate;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  InterlaceBlur() {
    xStart = 0;
    xEnd = 0;
    yStart = 0;
    yEnd = 0;
    size = 100;

    //create the interlaced image
    intermediate = createImage(orange1.width, orange1.height, RGB);

    //create a temporary boolean to flip between the two source images and interlace their pixekls
    boolean sourceImage = true;

    //fill the intermediate image
    for (int i = 0; i < intermediate.width; i++) {
      for  (int j = 0; j < intermediate.height; j++) {

        //find the pixel location in the array
        int loc = i + j * intermediate.width;
        loc = constrain(loc, 0, intermediate.pixels.length - 1);

        //get the pixel from either source image, determined by the boolean
        if (sourceImage) {

          float R = red(orange1.pixels[loc]);
          float G = green(orange1.pixels[loc]);
          float B = blue(orange1.pixels[loc]);

          //set the pixel of the intermediate image
          intermediate.pixels[loc] = color(R, G, B);
        } else {

          float R = red(orange2.pixels[loc]);
          float G = green(orange2.pixels[loc]);
          float B = blue(orange2.pixels[loc]);

          //set the pixel of the intermediate image
          intermediate.pixels[loc] = color(R, G, B);
        }

        //flip the sourceImage boolean
        sourceImage = !sourceImage;
      }
      //flip the sourceImage boolean between lines to get the checkerboard effect instead of lines
      sourceImage = !sourceImage;
    }
  }


  void activate() {
    //display the interlaced image
    image(intermediate, 0, 0);

    //set the borders of the blurring square
    xStart = constrain(mouseX - size/2, 0, intermediate.width);
    xEnd = constrain(mouseX + size/2, 0, intermediate.width);
    yStart = constrain(mouseY - size/2, 0, intermediate.height);
    yEnd = constrain(mouseY + size/2, 0, intermediate.height);

    //Load the pixels of the canvas
    loadPixels();

    for (int i = xStart; i < xEnd; i++) {
      for  (int j = yStart; j < yEnd; j++) {

        //find the pixel location in the array
        int loc = i + j * intermediate.width;
        loc = constrain(loc, 0, intermediate.pixels.length - 1);

        //blur the pixel at position i, j
        blur(i, j);
      }
    }

    //update the canvas pixels
    updatePixels();

    //draw a square around the blurring region
    rectMode(CENTER);
    stroke(0);
    noFill();
    rect(mouseX, mouseY, size, size);
  }


  void blur(int iCenter, int jCenter) {
    //create variables to hold the average color channels of the pixels being blurred
    float rTotal = 0.0;
    float gTotal = 0.0;
    float bTotal = 0.0;
    //an offset variable used to set the limits of the area being blurred
    int offset = matrixSize / 2;

    //loop through the convolution matrix
    for (int i = 0; i < matrixSize; i++) {
      for  (int j = 0; j < matrixSize; j++) {
        //find the pixel in the canvas being examined
        int xloc = iCenter + i - offset;
        int yloc = jCenter + j - offset;
        int loc = xloc + intermediate.width * yloc;

        //constrain the loc to the area of the image
        loc = constrain(loc, 0, intermediate.pixels.length - 1);

        //calculate the blurred color channels
        rTotal += (red(intermediate.pixels[loc]) * blurMatrix[i][j]);
        gTotal += (green(intermediate.pixels[loc]) * blurMatrix[i][j]);
        bTotal += (blue(intermediate.pixels[loc]) * blurMatrix[i][j]);
      }
    }
    //send the blurred color to the canvas
    int canvasLoc = iCenter + intermediate.width * jCenter;
    pixels[canvasLoc] = color(rTotal, gTotal, bTotal);
  }
}