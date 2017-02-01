This sketch reads from the default video camera and draws colored cubes in 3D space based on the colors of the video pixels. 

The pixels become cubes are chosen using a Gaussian distribution centered in the image's center, and with a standard deviation of 1/6 of the image's dimensions (height/width). 

This means that pixels are updated more often if they are closer to the center of the screen. The z-position of each cube is determine using Perlin noise.
