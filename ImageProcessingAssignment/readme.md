This program allows the user to employ three different image processing techniques to combine two images:
  1.  A raindrop-like effect where spots appear on a background image and fade away. The color of each spot 
      is determined by the the color of the pixel at the same location in the other source image.
  2.  A differencing effect where a user controls a circular area of effect with the mouse cursor. The affected area 
      displays the absolute value of the difference between the color channels of the two source images.
  3.  The background is created by interlacing the two images by switching between the two images for each 
      adjacent pixel. The user then controls a square area of effect with the mouse cursor. The affected area
      displays a blurred image by using a 5 X 5 convolution matrix.
