class Blob {

  float minx;
  float maxx;
  float miny;
  float maxy;
  
  float d = 40;
  
  Blob(float x, float y) {
    minx = x;
    maxx = x + 10;
    miny = y;
    maxy = y + 10; 
  }
  
  float[] getPos() {
    float cx = (minx + maxx) / 2;
    float cy = (miny + maxy) / 2;
    
    float[] pos = {cx, cy};
    return pos;
  }
  
  void add(float x, float y) {
    minx = min(minx, x);
    maxx = max(maxx, x);
    miny = min(miny, y);
    maxy = max(maxy, y);
  }
  
  boolean isNear(float x, float y) {
    float cx = (minx + maxx) / 2;
    float cy = (miny + maxy) / 2;
    
    float distance = distSq(cx, cy, x, y);
    return distance < distanceThresh * distanceThresh;
  }
  
  float size() {
    return (maxx - minx) * (maxy - miny);
  }
    
  void display() {
    rectMode(CORNERS);
    fill(255);
    rect(minx, miny, maxx, maxy);
  }
}
