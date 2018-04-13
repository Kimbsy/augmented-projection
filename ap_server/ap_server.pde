import processing.net.*;
import java.io.*;

Server ap_server;
Client client;

float[] pos1 = {0, 0};
float[] pos2 = {0, 0};

void setup() {
  size(640, 480);
  ap_server = new Server(this, 1920);
}

void draw() {
  background(0);

  client = ap_server.available();

  if (client != null) {
    if (client.available() > 0) {
      String data = client.readStringUntil(';');

      if (data != null) {
        processData(data);
      }
    }
  }

  fill(100);
  rect(pos1[0], pos1[1], 10, 10);
  fill(200);
  rect(pos2[0], pos2[1], 10, 10);
}

void processData(String data) {
  String[] split_data = split(data, '|');
  String source = split_data[0];
  data = split_data[1];

  switch (source) {
    case "AP_CAPTURE":
      processCaptureData(data);
      break;
    default:
      println("Source not implemented: " + source);
  }
}

void processCaptureData(String data) {
  String clean = data.replaceFirst(";", "");
  float[] split_data = float(split(clean, ','));
  pos1 = subset(split_data, 0, 2);
  pos2 = subset(split_data, 2, 2);
}
