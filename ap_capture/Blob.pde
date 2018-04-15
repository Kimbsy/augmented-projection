class Blob {

  float minx;
  float maxx;
  float miny;
  float maxy;
  
  float d = 40;
  ArrayList<PVector> points;
  
  Blob(float x, float y) {
    minx = x;
    maxx = x;
    miny = y;
    maxy = y; 
    
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
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
    
    points.add(new PVector(x, y));
  }
  
  boolean contains(float x, float y) {
    return x < maxx  
        && x > minx
        && y < maxy
        && y > miny;
  }
  
boolean isNear(float x, float y) {
  for (PVector p : points) {
    if (distSq(p.x, p.y, x, y) < distanceThresh * distanceThresh) {
      return true;
    }
  }
  return false;
  
    //float cx = (minx + maxx) / 2;
    //float cy = (miny + maxy) / 2;
    
    //float distance = distSq(cx, cy, x, y);
    //return distance < distanceThresh * distanceThresh;
  }
  
  float size() {
    return (maxx - minx) * (maxy - miny);
  }
    
  void display() {
    rectMode(CORNERS);
    fill(255);
    rect(minx, miny, maxx, maxy);
    
    fill(0, 0, 255);
    for (PVector p : points) {
      point(p.x, p.y);
    }
  }
}
