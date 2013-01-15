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

import processing.opengl.*;
import de.looksgood.ani.*;
import processing.video.*;

Risiko risiko;
Cover[] covers;
String[] names = { 
  "00.jpg", "01.jpg", "02.jpg", "03.jpg", "04.jpg", "05.jpg", "06.jpg", "07.jpg"
};
PImage imgMask;

Ani coverAnimation;

float ANI_TIME = 0.5;
int selectedCover = 0;

boolean isPlaying;
Movie theMov; 
boolean isLooping;
boolean showimage;

int time_millis = 0;


// graphics 
PImage imgLogo;
PImage imgDark; 

int fade_time = 2; // seconds  
int tintVal = 0; 

/*****
* GAME STATES 
******/
static class GameState {
  public static final int NO_STATE        = 0;
  public static final int INTRO_MOVIE     = 1; 
  public static final int CREDITS_MOVIE   = 2; 
  public static final int GAME_SELECT     = 3;
  public static final int GAME_ACTIVE     = 4;
  public static final int GAME_SELECTED   = 5;
  public static final int INTRO_GAMES     = 6; 

  public static int current = NO_STATE;
}

/*****
* GAMES 
******/
static class Game{
  public static final int RISIKO        = 6;
  public static final int OTHER         = -1;
  public static final int NO_SELECTED   = 0;  

  public static int current = NO_SELECTED;
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
  Game.current = Game.NO_SELECTED;
  theMov = new Movie(this, "intro.mov");

  theMov.play();  //plays the movie once
  GameState.current = GameState.INTRO_MOVIE;
  time_millis = millis();
  isPlaying = true;
  
  imgMask  = loadImage("mask.png");
  imgLogo  = loadImage("logo.png");
  imgDark  = loadImage("dark.jpg");
  tintVal = 0; 
  fade_time = 2;

  // Init Ani
  Ani.init(this);

  //gameobject
  risiko = new Risiko();
  
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
      // display the logo
      int imgWidth  = imgLogo.width;
      int imgHeight = imgLogo.height; 
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

      break; 
      
      case GameState.INTRO_MOVIE: 
        if( millis() - time_millis > theMov.duration() * 1000){
          isPlaying = false;
          GameState.current = GameState.GAME_SELECT;  
          time_millis = millis();
        }
        
        int movWidth = theMov.width; 
        int movHeight = theMov.height; 
        x = width/2 - movWidth/2;
        y = height/2 - movHeight/2; 
        
        if(isPlaying)image(theMov,x,y);
  
        //if(!showimage)rect(0, 0, 800, 600);
      break; 
      case GameState.GAME_SELECTED:
         switch(Game.current){
           case Game.RISIKO:
               risiko.draw();
           break;
         }
      break; 
  }
}


/* -------------- EVENT MANAGEMENT -------------- */
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
  
  controlEvent(3);
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
  
  switch(GameState.current)
  {
    case GameState.GAME_SELECT:
     if(keyCode == LEFT) {
      controlEvent(-1);
      //println("Left key toggled");
     } else if(keyCode == RIGHT) {
      controlEvent(1);
      // println("Right key toggled");
     } else if(keyCode == ENTER) {
       GameState.current = GameState.GAME_SELECTED; 
      Game.current = selectedCover; 
       //println("ENTER key toggled");
     }  
    break; 
    case GameState.GAME_SELECTED:
       switch(Game.current){
           case Game.RISIKO:
               risiko.keyPressed(keyCode);
           break;
         }    
    break;
  }
}

boolean sketchFullScreen() {
  return true;
}
