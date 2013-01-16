/**
 Quick Cover Flow in Processing
 by Adrià Navarro http://adrianavarro.net 
 USING: 3D (openGL), events (controlp5) and animation (ani)
 TODO: image resize, background image loading
 */
static class CardState {
  public static final int NO_STATE              = 0;
  public static final int ACTIVE                = 1; 
  public static final int INACTIVE              = 2; 
  public static final int REVEALED              = 3;

  public static int current = NO_STATE;
}


class Missioncard {
  PVector position;
  float rotationY;
  int transparency;
  PImage active, inactive, revealed;

  Missioncard( String path ) {
    this.position = new PVector(0.0, 0.0, 0.0);
    this.rotationY = 0.0;
    this.transparency = 255;
    this.active = loadImage(path+".png");
    this.inactive = loadImage(path+"_idle.png");
    this.revealed = loadImage(path+"_open.png");
  }

  public void drawMissioncard() {

    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(rotationY);
    
        // Main rectangle
    noTint();
    beginShape();
      textureMode(NORMAL);

    switch(CardState.current)
    {
      case CardState.ACTIVE:
       texture(active);
      break; 
      case CardState.INACTIVE:
       texture(inactive);
      break; 
      case CardState.REVEALED:
       texture(revealed);
      break; 
    }

      vertex(-38.5, -50, 0, 0, 0);
      vertex(38.5, -50, 0, 1, 0);
      vertex(38.5, 50, 0, 1, 1);
      vertex(-38.5, 50, 0, 0, 1);
    endShape();

    noTint();
    popMatrix();
  }
  
  public void setCardState(int cs) {
    println("CardState: "+cs);
    CardState.current = cs;
  }

}

