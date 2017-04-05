import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import org.openkinect.processing.*;

import processing.video.*;
Movie mov;
//float easing = 0.15;

Capture video;

Kinect2 kinect2;
int number;
float minThresh = 200;
float maxThresh = 2000;
PImage img;

boolean cap = false;


void setup() {
  size(640, 360);
  //video = new Capture(this, 640/2, 480/2);

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);


  mov = new Movie(this, "wind_480_eon.mov");
  mov.play();
  mov.jump(0);
  mov.pause();
}

void draw() { //1 - 230

  img.loadPixels();
  //background(0);
  // image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);

  //if (mov.available()) {
  mov.read();

  PImage dImg = kinect2.getDepthImage();
  //image(dImg, 0, 0);

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

  //int record = 4500;
  int record = kinect2.depthHeight;
  int rx = 0;
  int ry = 0;

  for (int x = 0; x < kinect2.depthWidth; x++) {
    for (int y = 0; y < kinect2.depthHeight; y++) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh && x > 100 && y > 50) {
        img.pixels[offset] = color(255, 0, 150);

        if (y < record) {
          record = y;
          rx = x;
          ry = y;

          number = d;
        }
      } else {
        img.pixels[offset] = dImg.pixels[offset];
      }
    }
  }
  
  img.updatePixels();
  //image(img, 0, 0);
 // image(mov, 0, 0, 640, 360);
  //fill(255);
  //ellipse(rx, ry, 32, 32);
  //fill(0, 102, 153, 204);

  float m = map(number, minThresh, maxThresh, 0, 500);
  text(m, 100, 200);

  float f = map(m, 0, width, 0, 1);
  float t = mov.duration() * f;

  // if ( rx < 150 && rx > 350) {
  mov.play();
  mov.jump(t);
  mov.pause();
  //  }
  //  println(t);
}