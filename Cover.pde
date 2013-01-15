/**
 Quick Cover Flow in Processing
 by Adrià Navarro http://adrianavarro.net 
 USING: 3D (openGL), events (controlp5) and animation (ani)
 TODO: image resize, background image loading
 */

class Cover {
  PVector position;
  float rotationY;
  int transparency;
  PImage img;

  Cover( String name ) {
    this.position = new PVector(0.0, 0.0, 0.0);
    this.rotationY = 0.0;
    this.transparency = 255;
    // this.img = resizeImage(loadImage(name));
    this.img = loadImage(name);
  }

  public void drawCover() {

    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(rotationY);

    // Main quad
    noTint();
    beginShape();
      textureMode(NORMAL);
      texture(img);
      vertex(-100, -100, 0, 0, 0);
      vertex(100, -100, 0, 1, 0);
      vertex(100, 100, 0, 1, 1);
      vertex(-100, 100, 0, 0, 1);
    endShape();

    // Reflection
    tint(50);
    beginShape();
      textureMode(NORMAL);
      texture(img);
      vertex(-100, 100, 0, 0, 1);
      vertex(100, 100, 0, 1, 1);
      vertex(100, 300, 0, 1, 0);
      vertex(-100, 300, 0, 0, 0);
    endShape();

    noTint();
    popMatrix();
  }

  // Function to call if images are not square
  // Not being used at the moment, might need some tweaking
  public void resizeImage(PImage img) {
    float ratio = 0.0;
    int newWidth = 0;
    int newHeight = 0;

    ratio = (float)img.width / (float)img.height;

    if( ratio > 1 ) {   // img is wider than tall
      newWidth = 255;
      newHeight = (int) (255.0/ratio);
    }
    else {              // img is taller than wide
      newHeight = 255;
      newHeight = (int)(255.0*ratio);
    }
    println ("width: " + newWidth + "height: " + newHeight + "ratio: " + ratio);
    img.resize(newWidth,newHeight);
  }
}

