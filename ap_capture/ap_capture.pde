import processing.net.*;

Client ap_client;
int[] pos1 = {0, 0};
int[] pos2 = {0, 0};

public void setup() {
  size(200, 200);
  ap_client = new Client(this, "localhost", 1920);
}

public void draw() {
  pos1[0] = (pos1[0] + 1) % width;
  pos1[1] = (pos1[1] + 1) % height;

  pos2[0] = (pos2[0] + 1) % width;
  pos2[1] = (pos2[1] + 2) % height;

  println(createData(pos1, pos2));

  ap_client.write("AP_CAPTURE|" + createData(pos1, pos2) + ";");
}

String createData(int[] pos1, int[] pos2) {
  return join(str(pos1), ",") + "," + join(str(pos2), ",");
}
