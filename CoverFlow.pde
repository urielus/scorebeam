/*****
 * Building interaction interface 
 * Eduard Margulies, Stefan Paula, Gerfried Mikusch
 * Copyright (C) 2013
 *****/

/**
 Quick Cover Flow in Processing
 by Adrià Navarro http://adrianavarro.net 
 USING: 3D (openGL), events (controlp5) and animation (ani)
 TODO: image resize, background image loading
 */

import controlP5.*;
import processing.opengl.*;
import de.looksgood.ani.*;
import processing.video.*;


ControlP5 controlP5;
Button bNext, bPrev;
Slider slider;

Cover[] covers;
String[] names = { 
  "00.jpg", "01.jpg", "02.jpg", "03.jpg", "04.jpg", "05.jpg", "06.jpg", "07.jpg"
};
PImage imgMask;
PImage imgShadow;   
Ani coverAnimation;

float ANI_TIME = 0.5;
int selectedCover = 0;

boolean isPlaying;
Movie theMov; 
boolean isLooping;
boolean showimage;

int time_millis = 0;


// graphics 
PImage imgLogo = loadImage("logo.png");

/*****
* GAME STATES 
******/
static class GameState {
  public static final int NO_STATE        = 0;
  public static final int INTRO_MOVIE     = 1; 
  public static final int CREDITS_MOVIE   = 2; 
  public static final int GAME_SELECT     = 3;
  public static final int GAME_ACTIVE     = 4; 

  public static int current = NO_STATE;
}


/* -------------- INIT -------------- */
void setup() {
  
  showimage = true;
  size(1024, 768, OPENGL);
  //size(2880, 1800, OPENGL);
  smooth();
  noStroke();


  // current game state is no state .... 
  GameState.current = GameState.NO_STATE;
  theMov = new Movie(this, "intro.mov");


  theMov.play();  //plays the movie once
  GameState.current = GameState.INTRO_MOVIE;
  time_millis = millis();
  isPlaying = true;
  
  imgMask = loadImage("mask.png");
  imgShadow = loadImage("shadow.png");

  // Init interface controlP5
 // controlP5 = new ControlP5(this);
//  bPrev =    controlP5.addButton("Prev",-1, 20, 360, 80, 20);     // ((theName, theValue, theX, theY, theW, theH);
 // bNext =    controlP5.addButton("Next", 1, width-100, 360, 80, 20);
 // slider =   controlP5.addSlider("slider", 0, names.length-1, selectedCover, 120, 360, width - 240, 20); // (theName, theMin, theMax, theDefaultValue, theX, theY, theW, theH);
  //slider.setLabelVisible(false);
  //controlP5.setAutoDraw(false);

  // Init Ani
  Ani.init(this);

  // Init covers
  covers = new Cover[names.length];
  for (int i=0; i<covers.length; i++ ) {
    covers[i] = new Cover(names[i]);
  }
  initCovers();
}

/* -------------- DRAW LOOP -------------- */
void draw() {
  int x;
  int y;
  background(0);
  
  // evaluate game states and perform actions 
  switch(GameState.current){
    case GameState.GAME_SELECT:
      //hint(ENABLE_DEPTH_TEST);
      
      // display the logo
      int imgWidth  = imgLogo.width / 10;
      int imgHeight = imgLogo.height / 10; 
      x = width/2 - imgWidth/2; 
      y = 0; 
      image(imgLogo, x, y, imgWidth, imgHeight);
      
      // move to the center to have easier coordinates
      pushMatrix();
      translate(width / 2, height/2 ); 
      for( int i=0; i<covers.length; i++ ) {
        covers[i].drawCover();
      }
      popMatrix();  

      // disable depth test to draw control interface on top of everything
      //hint(DISABLE_DEPTH_TEST);
      // add here shadow if needed
      //image(imgShadow, 0.0, 0.0);
      //controlP5.draw(); //needed if we draw with p3d
      break; 
      
      case GameState.INTRO_MOVIE: 
        //isPlaying = false;
        if( millis() - time_millis > theMov.duration() * 1000){
          isPlaying = false;
          GameState.current = GameState.CREDITS_MOVIE;  
        }
        
        int movWidth = theMov.width; 
        int movHeight = theMov.height; 
        x = width/2 - movWidth/2;
        y = height/2 - movHeight/2; 
        
        //if(showimage)image(theMov,0,0);
        if(isPlaying)image(theMov,x,y);
  
        if(!showimage)rect(0, 0, 800, 600);
      break; 
      
      case GameState.CREDITS_MOVIE:
         GameState.current = GameState.GAME_SELECT; 
      break; 
  }
}


/* -------------- EVENT MANAGEMENT -------------- */
public void controlEvent(ControlEvent theEvent) {

  // Check where the event comes from
  if (theEvent.controller().name() == "slider" ) {           // slider
    selectedCover = round(theEvent.controller().value());
  }
  else {                                                    // buttons
    selectedCover += (int) theEvent.controller().value();
    slider.setValue(selectedCover);
  }

  // Lock buttons if we are in the first or last cover
  if ( selectedCover == names.length ) {
    selectedCover --;
    bNext.lock();
  }
  else if ( selectedCover < 0 ) {
    selectedCover ++;
    bPrev.lock();
  }
  else {
    bNext.unlock();
    bPrev.unlock();
  }

  //Call Animation
  moveCovers();
}

public void controlEvent(int value) {
  
                                            // buttons
    selectedCover += value;

  // Lock buttons if we are in the first or last cover
  if ( selectedCover == names.length ) {
    selectedCover --;

  }
  else if ( selectedCover < 0 ) {
    selectedCover ++;
  }


  //Call Animation
  moveCovers();
}

/* -------------- ANIMATION TWEENS -------------- */
public void initCovers() {
  covers[0].position.set(0.0 - 0.0, 0.0, 75.0);
  covers[0].rotationY = 0.0;
  for (int i=1; i<covers.length; i++ ) {
    covers[i].position.set(150.0 + 25.0*i, 0.0, 0.0);
    covers[i].rotationY = -QUARTER_PI;
  }
}

public void moveCovers() {

  // left covers
  for (int i=0; i<selectedCover; i++ ) {
    Ani.to(covers[i].position, ANI_TIME, "x", -150.0 - 25.0*(selectedCover-i), Ani.CIRC_OUT);
    Ani.to(covers[i].position, ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
    Ani.to(covers[i].position, ANI_TIME, "z", 0.0, Ani.CIRC_OUT);
    Ani.to(covers[i], ANI_TIME, "rotationY", QUARTER_PI, Ani.CIRC_OUT);
  }

  // central cover
  coverAnimation = Ani.to(covers[selectedCover].position, 0.5, "x", 0.0, Ani.CIRC_OUT);
  Ani.to(covers[selectedCover].position, ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
  Ani.to(covers[selectedCover].position, ANI_TIME, "z", 75.0, Ani.CIRC_OUT);
  Ani.to(covers[selectedCover], ANI_TIME, "rotationY", 0.0, Ani.CIRC_OUT);

  // right covers
  for (int i=selectedCover + 1; i<covers.length; i++ ) {
    Ani.to(covers[i].position, ANI_TIME, "x", 150.0 + 25.0*(i-selectedCover), Ani.CIRC_OUT);
    Ani.to(covers[i].position, ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
    Ani.to(covers[i].position, ANI_TIME, "z", 0.0, Ani.CIRC_OUT);
    Ani.to(covers[i], ANI_TIME, "rotationY", -QUARTER_PI, Ani.CIRC_OUT);
  }
}

void movieEvent(Movie m) { 
  m.read(); 
} 

void keyPressed() {
  if (key == 'p') {
    // toggle pausing
    if (isPlaying) {
      theMov.pause();
    } else {
      theMov.play();
    }
    isPlaying = !isPlaying;

  } else if (key == 'l') {
    // toggle looping
    if (isLooping) {
      theMov.noLoop();
    } else {
      theMov.loop();
    }
    isLooping = !isLooping;

  } else if (key == 41) {
    // stop playing
    theMov.stop();
    isPlaying = false;
    showimage = false;

  } else if (key == 'j') {
    // jump to a random time
    theMov.jump(random(theMov.duration()));
  } else if(keyCode == LEFT) {
    controlEvent(-1);
    println("Left key toggled");
  } else if(keyCode == RIGHT) {
    controlEvent(1);
     println("Right key toggled");
  }  
}
boolean sketchFullScreen() {
  return true;
}
