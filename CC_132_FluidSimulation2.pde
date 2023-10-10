import processing.net.*;

final int N = 128;
final int iter = 16;
final int SCALE = 6;
float t = 0;
int Y_AXIS = 1;

int prev_my = 0;
int prev_mx = 0;
int prevPoints[] = new int[4];

color b1, b2, b3, b4, b5, b6, b7, b8;

Client myClient;
byte[] byteBuffer = new byte[1024];
JSONObject json;

Fluid fluid;


void settings() {
  size(N * SCALE, N * SCALE);
  fullScreen();
}

void setup() {
  myClient = new Client(this, "127.0.0.1", 5000);
   
  fluid = new Fluid(0.15, 0, 0.0000001);
  
  // Define colors
  b1 = color(79, 0, 112);
  b2 = color(0, 79, 112);
  b3 = color(0, 203, 216);
  b4 = color(35, 148, 0);
  b5 = color(148,224,0);
  b6 = color(255, 228, 0);
  b7 = color(242, 132, 13);
  b8 = color(216,0,0);
  
}

void mouseMoved() {
  fluid.addDensity(mouseX/SCALE, mouseY/SCALE, 800);
  float amtX = mouseX - pmouseX;
  float amtY = mouseY - pmouseY;
  fluid.addVelocity(mouseX/SCALE, mouseY/SCALE, amtX, amtY);
}

void draw() {
  background(0, 10);
  
  if (myClient.available() > 0) { 
    
    int byteCount = myClient.readBytesUntil('\n', byteBuffer);
    //myClient.clear();
    
    if (byteCount > 0 ) {
      String myString = new String(byteBuffer);
      json = parseJSONObject(myString);
      
      if (json != null) {
        JSONObject[] points = new JSONObject[2];
        
        points[0] = json.getJSONObject("left_wrist");
        points[1] = json.getJSONObject("right_wrist");
        //points[2] = json.getJSONObject("nose");

        for (int i = 0; i < points.length; i++) {
          JSONObject point = points[i];
          
          // retrieve prevPoint
          if (i == 0) {
            prev_mx = prevPoints[0];
            prev_my = prevPoints[1];
          } else if (i == 1) {
            prev_mx = prevPoints[2];
            prev_my = prevPoints[3];
          } else if (i == 2) {
            prev_mx = prevPoints[4];
            prev_my = prevPoints[5];
          }
                    
          int mx = (int)(point.getFloat("x") * N * 1.1);
          int my = (int)(point.getFloat("y") * N * 1.1);
          
          push();
          stroke(0);
          strokeWeight(50);
          noFill();
          circle(mx, my, 20);
          pop();
          
          mx = constrain(mx, 0, N);
          my = constrain(my, 0, N);
        
          float gradient;
          float yIntercept;
          int j, k; // pair of coordinates between (mx, my) and (prevMouseX, prevMouseY)
        
          // to avoid division by zero
          if (mx - prev_mx == 0) {
            gradient = 0.1;
          } else {
            gradient = (my - prev_my) / (mx - prev_mx);
          }
        
          yIntercept = my - (gradient * mx);
        
          if (mx < prev_mx) {
            for (float x = prev_mx; x >= mx; x -= 0.2) {
              j = (int)x;
              k = (int)((gradient * x) + yIntercept);
              
              fluid.addDensity(j, k, 800);
              float amtX = mx - prev_mx;
              float amtY = my - prev_my;
              fluid.addVelocity(j, k, amtX, amtY);
            }
          } else {
            for (float x = prev_mx; x <= mx; x += 0.5) {
              j = (int)x;
              k = (int)((gradient * x) + yIntercept);
              
              fluid.addDensity(j, k, 800);
              float amtX = mx - prev_mx;
              float amtY = my - prev_my;
              fluid.addVelocity(j, k, amtX, amtY);
            }
          }
        
          // store prevPoint
          if (i == 0) {
            prevPoints[0] = mx;
            prevPoints[1] = my;
          } else if (i == 1) {
            prevPoints[2] = mx;
            prevPoints[3] = my;
          } else if (i == 2) {
            prevPoints[4] = mx;
            prevPoints[5] = my;
          }
        }
      }
    }
    byteBuffer = new byte[1024];
  }
  
  fluid.step();
  fluid.renderD();
  fluid.fadeD();
  //fluid.renderV();
}
