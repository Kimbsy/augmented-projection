import processing.video.*;
import processing.net.*;

Client ap_client;
Capture cam;

color trackColor;
float colorThresh = 20;
float distanceThresh = 20;
ArrayList<Blob> blobs;

public void setup() {
  size(640, 480);
  
  ap_client = new Client(this, "localhost", 1920);
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("No cameras found");
    exit();
  } else {
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
  
  blobs = new ArrayList<Blob>();
  Blob b = new Blob(20, 20);
  blobs.add(b);
}

public void draw() {
  blobs.clear();
  background(0);
  
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  
  cam.loadPixels();
  
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      int location = x + (y * cam.width);
      
      color currentColor = cam.pixels[location];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      
      float colorDistance = distSq(r1, g1, b1, r2, g2, b2);
      
      if (colorDistance < colorThresh * colorThresh) {
        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }
          
        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }
  
  Blob bMax = new Blob(0, 0);
  
  for (Blob b : blobs) {
    if (b.size() > bMax.size()) {
      bMax = b;
    }
  }
  
  bMax.display();

  ap_client.write("AP_CAPTURE|" + createData(bMax.getPos(), bMax.getPos()) + ";");
}

String createData(float[] pos1, float[] pos2) {
  return join(str(pos1), ",") + "," + join(str(pos2), ",");
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1);
  return d;
}

void keyPressed() {
  if (key == 'a') {
    distanceThresh++;
  } else if (key == 'z') {
    distanceThresh--;
  }
  println(distanceThresh);
}

void mousePressed() {
  int location = mouseX + (mouseY * cam.width);
  trackColor = cam.pixels[location];
}
