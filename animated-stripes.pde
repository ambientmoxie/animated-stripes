/* ----------

Name: Animated stripes
Code: Maxime Benoit
Original idea: Sanders Sturing
Last revision: 19/12/2023

Steps:

1 - A random image is loaded from an external link and displayed on the canvas.
2 - The user can create a selection area by clicking and dragging the mouse.
3 - Upon mouse release:
    a. An array of colors is created based on the selected area.
    b. A Shape consisting of lines is generated and immediately added to an ArrayList.
    c. The shapes stored in the ArrayList are rendered onto the canvas.
4 - If the user presses "ENTER", an animation is triggered using the array index and the modulo operator.

---------- */


// Color blocks related var.
ArrayList<Shape> shapes;
int middlePickerX;
int middlePickerY;
int rectWidth;
int rectHeight;

// Selector related var.
boolean selection = false;
int mouseStartPosX;
int mouseStartPosY;
int mouseEndPosX;
int mouseEndPosY;

// Images related var.
PImage seed;
String url = "https://picsum.photos/512";

// Color array related var.
int pixelIndex;
color[] colors;
boolean isHorizontal;

// Animation related var.
boolean isAnimated;

void setup() {
  size(512, 512);
  //pixelDensity(displayDensity()); // Too laggy when activated
  colorMode(RGB, 255, 255, 255, 100);
  seed = loadImage(url, "jpg");

  // Init array list
  shapes = new ArrayList<Shape>();
}

void draw() {
  image(seed, 0, 0);

  // Draw the shapes

  for (int i = 0; i < shapes.size(); i++) {
    Shape shape = shapes.get(i);
    shape.display();
    if (isAnimated) {
      shape.animate();
    }
  }

  // Draw the selector

  if (selection) {
    drawSelector();
  }

}

void createArrayOfColors(boolean isHorizontal) {
  seed.loadPixels();

  if (rectWidth > 0) { // Prevent sketch from from crashing if shape is drawn backward.
    if (isHorizontal) {
      colors = new color[rectWidth];
      for (int i = 0; i < rectWidth; ++i) {
        pixelIndex = (mouseStartPosX + i) + (mouseStartPosY + rectHeight / 2) * seed.width;
        if (pixelIndex >= 0 && pixelIndex < seed.pixels.length) {
          colors[i] = seed.pixels[pixelIndex];
        }
      }
    } else {
      colors = new color[rectHeight];
      for (int i = 0; i < rectHeight; ++i) {
        pixelIndex = (mouseStartPosX + rectWidth / 2) + (mouseStartPosY + i) * seed.width;
        if (pixelIndex >= 0 && pixelIndex < seed.pixels.length) {
          colors[i] = seed.pixels[pixelIndex];
        }
      }
    }
  }
}

void drawSelector() {

  // Draw the rectangle selector
  fill(0, 0, 0, 20);
  strokeWeight(1);
  stroke(255, 255, 255, 100);
  beginShape();
  vertex(mouseStartPosX, mouseStartPosY);
  vertex(mouseX, mouseStartPosY);
  vertex(mouseX, mouseY);
  vertex(mouseStartPosX, mouseY);
  endShape(CLOSE);

  // Draw the pointer
  fill(255, 0, 0, 100);
  noStroke();
  ellipse(mouseX, mouseY, 10, 10);
}

class Shape {

  // Variable that defines block size and position
  int blk_width;
  int blk_height;
  int blk_mouseStartPosX;
  int blk_mouseStartPosY;
  int blk_mouseEndPosX;
  int blk_mouseEndPosY;
  boolean isHorizontal;

  color[] blk_color;
  
  int incr;
  int speed = 2;

  Shape(int w, int h, int mspX, int mspY, int mepX, int mepY, boolean orientation, color[] colors) {
    blk_width = w;
    blk_height = h;
    blk_mouseStartPosX = mspX;
    blk_mouseStartPosY = mspY;
    blk_mouseEndPosX = mepX;
    blk_mouseEndPosY = mepY;
    isHorizontal = orientation;
    blk_color = colors;
  }
  
  void animate() {
    incr += speed;
  }

  void display() {

    noFill();
    strokeWeight(2);

    if (isHorizontal) {
      for (int i = 0; i < blk_width; i++) {
        stroke(blk_color[(i + incr) % blk_width]);
        line(blk_mouseStartPosX + i, blk_mouseStartPosY, blk_mouseStartPosX + i, blk_mouseEndPosY);
        //beginShape();
        //vertex(blk_mouseStartPosX + i, blk_mouseStartPosY);
        //vertex(blk_mouseStartPosX + i, blk_mouseEndPosY);
        //endShape();
      }
    } else {
      for (int i = 0; i < blk_height; i++) {
        stroke(blk_color[(i + incr) % blk_height]);
        line(blk_mouseStartPosX, blk_mouseStartPosY + i, blk_mouseEndPosX, blk_mouseStartPosY + i);
        //beginShape();
        //vertex(blk_mouseStartPosX, blk_mouseStartPosY + i);
        //vertex(blk_mouseEndPosX, blk_mouseStartPosY + i);
        //endShape();
      }
    }
  }
}

void mousePressed() {
  mouseStartPosX = mouseX;
  mouseStartPosY = mouseY;
  selection = true;
}

void mouseReleased() {
  mouseEndPosX = mouseX;
  mouseEndPosY = mouseY;
  selection = false;

  rectWidth = mouseEndPosX - mouseStartPosX;
  rectHeight = mouseEndPosY - mouseStartPosY;

  isHorizontal = rectWidth > rectHeight;
  createArrayOfColors(isHorizontal);

  shapes.add(new Shape(rectWidth, rectHeight, mouseStartPosX, mouseStartPosY, mouseEndPosX, mouseEndPosY, isHorizontal, colors));
}


void keyTyped() {
  if (key == ENTER) {
    isAnimated = !isAnimated;
  }
}
