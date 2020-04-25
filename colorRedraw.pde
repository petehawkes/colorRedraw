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

boolean[] redraw;

float hue;

public void setup() {
  //size(640, 480, P3D);
  // Or run full screen, more fun! Use with Sketch -> Present
  size(800, 600, OPENGL);

  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, 160, 120);
  video.start();  
  int count = video.width * video.height;
  redraw = new boolean[count];
  
  println(count);
  
  noStroke();
}


public void captureEvent(Capture c) {
  c.read();
}


void draw() {
  //background(0);

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
      int _r = (pixelColor >> 16) & 0xff;
      int _g = (pixelColor >> 8) & 0xff;
      int _b = pixelColor & 0xff;

      // Another option would be to properly calculate brightness as luminance:
      // luminance = 0.3*red + 0.59*green + 0.11*blue
      // Or you could instead red + green + blue, and make the the values[] array
      // 256*3 elements long instead of just 256.
      int pixelBright = max(_r, _g, _b);
      
      int xFlip = video.width-x-(video.width%inc);
      if (video.width%inc == 0) {
        xFlip -= inc;
      } 
      
      if (x==0 && y==0) hue = saturation(pixelColor);
     
      if (hueWithinRange(pixelColor, 23, 1)) redraw[index] = true;
      if (!redraw[index]) {
        fill(pixelColor);
        rect(xFlip, y, inc, inc);
      }

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

boolean hueWithinRange (int clr, float midhue, float range) {
  float h = hue(clr);
  if (h > midhue - range && h < midhue + range) {
    if (saturation(clr) > 80) {
      return true;
    } else {
      return false;
    }
  } else {
    return false; 
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
    case ' ': println(hue);
  }
}
