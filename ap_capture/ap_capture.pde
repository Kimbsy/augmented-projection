import processing.video.*;
import processing.net.*;

Client ap_client;
Capture cam;
int cameraCount;
int camIndex = 0;

color trackColor1;
color trackColor2;
float colorThresh = 10;
float distanceThresh = 2;
ArrayList<Blob> blobs1;
ArrayList<Blob> blobs2;

public void setup() {
  size(640, 480);
  
  ap_client = new Client(this, "localhost", 1920);
  
  //String[] cameras = Capture.list();
  //for (int i = 0; i < cameras.length; i++) {
  //  println(cameras[i]);
  //}
  
  initCam();
  
  blobs1 = new ArrayList<Blob>();
  blobs2 = new ArrayList<Blob>();
}

public void initCam() {
  String[] cameras = Capture.list();
  cameraCount = cameras.length;
  
  if (cameraCount == 0) {
    println("No cameras found");
    exit();
  } else {
    println(cameras[camIndex]);
    cam = new Capture(this, cameras[camIndex]);
    cam.start();
  }
}

public void draw() {
  blobs1.clear();
  blobs2.clear();
  background(0);
  
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  
  cam.loadPixels();
  
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      findBlobs(x, y, trackColor1, blobs1);
      findBlobs(x, y, trackColor2, blobs2);
    }
  }
  
  Blob bMax1 = displayMaxBlob(blobs1);
  Blob bMax2 = displayMaxBlob(blobs2);
  
  ap_client.write("AP_CAPTURE|" + createData(bMax1.getPos(), bMax2.getPos()) + ";");
}

void findBlobs(int x, int y, color trackColor, ArrayList<Blob> blobs) {
  int location = x + (y * cam.width);
  color currentColor = cam.pixels[location];
      
  float c_r = red(currentColor);
  float c_g = green(currentColor);
  float c_b = blue(currentColor);
      
  float t_r = red(trackColor);
  float t_g = green(trackColor);
  float t_b = blue(trackColor);

  float colorDistance = distSq(c_r, c_g, c_b, t_r, t_g, t_b);
  
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

Blob displayMaxBlob(ArrayList<Blob> blobs) {
  Blob bMax = new Blob(0, 0);
  for (Blob b : blobs) {
    if (b.size() > bMax.size()) {
      bMax = b;
    }
  }
  bMax.display();
  return bMax;
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
  switch (key) {
    case 'a':
      distanceThresh++;
      println(distanceThresh);
      break;
    case 'z':
      distanceThresh--;
      println(distanceThresh);
      break;
    case ' ':
      camIndex = (++camIndex) % cameraCount;
      println(camIndex);
      cam.stop();
      initCam();
      break;
    default:
  }
}

void mousePressed() {
  int location = mouseX + (mouseY * cam.width);
  
  switch (mouseButton) {
    case LEFT:
      trackColor1 = cam.pixels[location];
      break;
    case RIGHT:
      trackColor2 = cam.pixels[location];
      break;
    default:
  }
  
}
