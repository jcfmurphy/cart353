This sketch reads from the default video camera and draws colored cubes in 3D space based on the colors of the video pixels. 

The pixels to be drawn as cubes each frame are chosen using a Gaussian distribution. This distribution is centered in the video image's center with a standard deviation equal to 1/6 of the image's dimensions (height/width). This means that pixels are updated more often if they are closer to the center of the screen. 

The z-position of each cube is determined using Perlin noise.
