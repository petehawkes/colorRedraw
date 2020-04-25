/**
 * 
 * based off
 * ASCII Video
 * by Ben Fry. 
 *
 * GSVideo version by Andres Colubri. 
 * 
 * Text characters have been used to represent images since the earliest computers.
 * This sketch is a simple homage that re-interprets live video as ASCII text.
 * See the keyPressed function for more options, like changing the font size.
 */

import processing.video.*;

Capture video;
boolean cheatScreen;

int clr;

public void setup() {
  //size(640, 480, P3D);
  // Or run full screen, more fun! Use with Sketch -> Present
  size(800, 600, OPENGL);

  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, 160, 120);
  video.start();  
  int count = video.width * video.height;
  println(count);
  
  noStroke();
}


public void captureEvent(Capture c) {
  c.read();
}


void draw() {
  background(0);

  pushMatrix();

  int index = 0;
  int inc = 1;
  
  scale(width/video.width, height/video.height);
  //scale(-1,1);
  
  video.loadPixels();
  for (int y = 0; y < video.height; y+=inc) {

    for (int x = 0; x < video.width; x+=inc) {

      int pixelColor = video.pixels[index];
      // Faster method of calculating r, g, b than red(), green(), blue() 
      int r = (pixelColor >> 16) & 0xff;
      int g = (pixelColor >> 8) & 0xff;
      int b = pixelColor & 0xff;

      // Another option would be to properly calculate brightness as luminance:
      // luminance = 0.3*red + 0.59*green + 0.11*blue
      // Or you could instead red + green + blue, and make the the values[] array
      // 256*3 elements long instead of just 256.
      int pixelBright = max(r, g, b);
      
      fill(pixelColor);
      if (x==0 && y==0) clr = pixelColor;
      rect(x, y, inc, inc);

      index++;
      
    }

  }

  popMatrix();

  if (cheatScreen) {
    //image(video, 0, height - video.height);
    // set() is faster than image() when drawing untransformed images
    set(0, height - video.height, video);
  }
}


/**
 * Handle key presses:
 * 'c' toggles the cheat screen that shows the original image in the corner
 * 'g' grabs an image and saves the frame to a tiff image
 * 'f' and 'F' increase and decrease the font size
 */
public void keyPressed() {
  switch (key) {
    case 'g': saveFrame(); break;
    case 'c': cheatScreen = !cheatScreen; break;
    case ' ': println(clr);
  }
}
