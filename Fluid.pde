int IX(int x, int y) {
  x = constrain(x, 0, N-1);
  y = constrain(y, 0, N-1);
  return x + (y * N);
}


class Fluid {
  int size;
  int numOfSections;
  float sectionSize;
  float dt;
  float diff;
  float visc;

  float[] s;
  float[] density;

  float[] Vx;
  float[] Vy;

  float[] Vx0;
  float[] Vy0;

  Fluid(float dt, float diffusion, float viscosity) {

    this.size = N;
    this.numOfSections = 8;
    this.sectionSize = (this.size * SCALE) / this.numOfSections;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;

    this.s = new float[N*N];
    this.density = new float[N*N];

    this.Vx = new float[N*N];
    this.Vy = new float[N*N];

    this.Vx0 = new float[N*N];
    this.Vy0 = new float[N*N];
  }

  void step() {
    int N          = this.size;
    float visc     = this.visc;
    float diff     = this.diff;
    float dt       = this.dt;
    float[] Vx      = this.Vx;
    float[] Vy      = this.Vy;
    float[] Vx0     = this.Vx0;
    float[] Vy0     = this.Vy0;
    float[] s       = this.s;
    float[] density = this.density;

    diffuse(1, Vx0, Vx, visc, dt);
    diffuse(2, Vy0, Vy, visc, dt);

    project(Vx0, Vy0, Vx, Vy);

    advect(1, Vx, Vx0, Vx0, Vy0, dt);
    advect(2, Vy, Vy0, Vx0, Vy0, dt);

    project(Vx, Vy, Vx0, Vy0);

    diffuse(0, s, density, diff, dt);
    advect(0, density, s, Vx, Vy, dt);
  }

  void addDensity(int x, int y, float amount) {
    int index = IX(x, y);
    this.density[index] += amount;
  }

  void addVelocity(int x, int y, float amountX, float amountY) {
    int index = IX(x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;
  }

  void renderD() {
    colorMode(RGB, 255);
    
    for (int i = 0; i < N; i++) {
      float x = i * SCALE;
      for (int j = 0; j < N; j++) {
        float y = j * SCALE;
        float d = this.density[IX(i, j)];
        float amt = map(j, 0, this.sectionSize, 0, 1);
        color col;
        
        fill(0); 
        push();
        
        if (d > 10) {
          
          if (y >= 0 && y <= this.sectionSize * 0.75) {
            fill(b8, d);
          } else if (y > this.sectionSize * 0.75 && y < this.sectionSize * 1.25) {
            amt = map(y, this.sectionSize * 0.75, this.sectionSize * 1.25, 0, 1);
            col = lerpColor(b8, b7, amt);
            fill(col, d);
          } else if (y >= this.sectionSize * 1.25 && y <= this.sectionSize * 1.75) {
            fill(b7, d);
          } else if (y > this.sectionSize * 1.75 && y < this.sectionSize * 2.25) {
            amt = map(y, this.sectionSize * 1.75, this.sectionSize * 2.25, 0, 1);
            col = lerpColor(b7, b6, amt);
            fill(col, d);
          } else if (y >= this.sectionSize * 2.25 && y <= this.sectionSize * 2.75) {
            fill(b6, d);
          } else if (y > this.sectionSize * 2.75 && y < this.sectionSize * 3.25) {
            amt = map(y, this.sectionSize * 2.75, this.sectionSize * 3.25, 0, 1);
            col = lerpColor(b6, b5, amt);
            fill(col, d);
          } else if (y >= this.sectionSize * 3.25 && y <= this.sectionSize * 3.75) {
            fill(b5, d);
          } else if (y > this.sectionSize * 3.75 && y < this.sectionSize * 4.25) {
            amt = map(y, this.sectionSize * 3.75, this.sectionSize * 4.25, 0, 1);
            col = lerpColor(b5, b4, amt);
            fill(col, d);
          } else if (y >= this.sectionSize * 4.25 && y <= this.sectionSize * 4.75) {
            fill(b4, d);
          } else if (y > this.sectionSize * 4.75 && y < this.sectionSize * 5.25) {
            amt = map(y, this.sectionSize * 4.75, this.sectionSize * 5.25, 0, 1);
            col = lerpColor(b4, b3, amt);
            fill(col, d);
          } else if (y >= this.sectionSize * 5.25 && y <= this.sectionSize * 5.75) {
            fill(b3, d);
          } else if (y > this.sectionSize * 5.75 && y < this.sectionSize * 6.25) {
            amt = map(y, this.sectionSize * 5.75, this.sectionSize * 6.25, 0, 1);
            col = lerpColor(b3, b2, amt);
            fill(col, d);
          } else if (y >= this.sectionSize * 6.25 && y <= this.sectionSize * 6.75) {
            fill(b2, d);
          } else if (y > this.sectionSize * 6.75 && y < this.sectionSize * 7.25) {
            amt = map(y, this.sectionSize * 6.75, this.sectionSize * 7.25, 0, 1);
            col = lerpColor(b2, b1, amt);
            fill(col, d);
          } else if (y >= this.sectionSize * 7.25 && y <= this.sectionSize * 8) {
            fill(b1, d);
          }
        }
       
        noStroke();
        square(x, y, SCALE);

        pop();     
      }
    }
  }

  void renderV() {

    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        float x = i * SCALE;
        float y = j * SCALE;
        float vx = this.Vx[IX(i, j)];
        float vy = this.Vy[IX(i, j)];
        stroke(255);

        if (!(abs(vx) < 0.1 && abs(vy) <= 0.1)) {
          line(x, y, x+vx*SCALE, y+vy*SCALE );
        }
      }
    }
  }

  void fadeD() {
    for (int i = 0; i < this.density.length; i++) {
      density[i] = density[i] - 1.5;
      
      if (density[i] < -10) {
        density[i] = 0;
      }
    }
  }
}
