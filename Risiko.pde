/*****
 * Building interaction interface 
 * Eduard Margulies, Stefan Paula, Gerfried Mikusch
 * Copyright (C) 2013
 *****/
 

/** In Game States */
static class InGameState {
  public static final int NO_STATE              = 0;
  public static final int INTRO_SCREEN          = 1; 
  public static final int PLAYER1_TURN          = 2; 
  public static final int PLAYER2_TURN          = 3;
  public static final int ATTACK                = 4;  

  public static int current = INTRO_SCREEN;
}


class Risiko {

  /** Load game graphics */
  PImage imgAttack;                             //Image for attack scene
  PImage imgMenu;                               //Menu - intro screen
  PImage imgBoard;                              //Actual gaming board
  PImage p1, p2;                                //Tokens for player1 and player2
  PImage p1_idle, p2_idle;                      //Inactive tokens for player1 and player2

  /** Load missioncards */
  Missioncard p1_m, p2_m;

  
  /** Load game movies */
  Movie canonfire;                              //Canonfire movie
  Movie cavalary;                                //Cavalry movie
  Movie gunfire;                                //Gunfire movie
  
  Movie theMov;                                 // current attack video
  
  /** Canvas settings */
  PFont f;                                      //Font settings
  float ANI_TIME = 0.5;                         //Animation setting
  int time_millis = 0;
  boolean isPlaying = false;  
  
  
  /** Game vars */
  int activePlayer = 1;                          //The active player
  String p1_name = "Gerfried";                   //Name of player1
  String p2_name = "Stefan";                     //Name of player2
  int p1_conquered = 14;                         //Countries conquered by player1
  int p2_conquered = 14;                         //Countries conquered by player2
  boolean revealed = false;                      //Missioncard open or not
  
  /**Debug */
  int x = 0;
  int y = 0;

  Risiko(ScoreBeam sb) {
 
    /**Initialize images */
    imgBoard = loadImage("risiko788.jpg");
    imgMenu = loadImage("risk_menu.png");
    
    /**Initialize gameplay images */
    p1 = getImg("cone_yellow.png");
    p2 = getImg("cone_red.png");
    p1_idle = getImg("cone_yellow_idle.png");
    p2_idle = getImg("cone_red_idle.png");
    imgAttack = getImg("attack.jpg");
    
    /**Initialize font settings */
    f = createFont("Arial",20,true); 
    
    /**Initialize movies */
    canonfire = new Movie(sb, "videos/canonfire.m4v");
    cavalary = new Movie(sb, "videos/cavalry.m4v");
    gunfire = new Movie(sb, "videos/gunfires.m4v");
    
    
    /**Initialize missioncards */
    p1_m = new Missioncard("gameplay/mc_yellow");
    p2_m = new Missioncard("gameplay/mc_red");
   
    p1_m.position.set(0.0 - 0.0, 0.0, 75.0);
    p1_m.rotationY = 0.0;
    p1_m.setCardState(CardState.ACTIVE);
    
    p2_m.position.set(0.0 - 0.0, 0.0, 75.0);
    p2_m.rotationY = 0.0;
    p2_m.setCardState(CardState.INACTIVE);
  

    
  }
  
  public PImage getImg(String name) {
    return loadImage("gameplay/"+name);
  }
  
  public void draw(){
    
    switch(InGameState.current)
    {
      case InGameState.INTRO_SCREEN:
       drawMenu();
      break; 
      case InGameState.PLAYER1_TURN:
        drawBoard();
      break;
      case InGameState.PLAYER2_TURN:
        drawBoard();
      break;
      case InGameState.ATTACK:
        drawBoard();   
      break;
    }
    
  }
  
  public void drawMenu() {
    
    /** Mocked menu image -> more logic coming */
    image(imgMenu,  0, 0, 1024, 768);

  }
  
  public void drawBoard() {

    if(activePlayer == 1) {
      
      p2_m.setCardState(CardState.INACTIVE);
      pushMatrix();
      translate(512, 598); 
      p2_m.drawMissioncard();
      popMatrix();  
      
      image(p2_idle, 175, 690, 25, 50);                  //Display the red inactive cone
      //image(p2_mc_idle, 473.5, 588, 77, 100);            //Display the red inactive missioncard
      image(p1, 805, 30, 58, 100);                       //Display the yellow active cone
      
      if(revealed) {
        p1_m.setCardState(CardState.REVEALED);
      } else {
        p1_m.setCardState(CardState.ACTIVE);
      }
      pushMatrix();
      translate(512, 170); 
      p1_m.drawMissioncard();
      popMatrix();  
      
      //image(p1_mc, 473.5, 80, 77,100);                   //Display the yellow active missioncard
      
      textFont(f,20);                                    //Set font settings     
      fill(255);                                         //White font
      
      //move to the center and rotate by 180°
      pushMatrix();
      translate(width / 2, height/2 ); 
      rotate(PI);
      translate(width / 2, height/2 ); 
      text("Countries conquered "+p1_conquered,-330,-103); //Conquered countries
      text(hour()+":"+minute()+":"+second(), -330,-68);
      text(p1_name,-780,-40);                              //Playername
      rotate(-PI);  
      popMatrix();  

    } else if(activePlayer == 2) {
      
      p1_m.setCardState(CardState.INACTIVE);
      pushMatrix();
      translate(512, 170); 
      p1_m.drawMissioncard();
      popMatrix();  
      
      image(p1_idle, 820, 38, 25, 50);                   //Display the yellow inactive cone
      //image(p1_mc_idle, 473.5, 80, 77, 100);             //Display the yellow inactive missioncard
      image(p2, 160, 638, 58, 100);                      //Display the red active cone
      //image(p2_mc, 473.5, 588, 77,100);                  //Display the red active missioncard
      
      if(revealed) {
        p2_m.setCardState(CardState.REVEALED);
      } else {
        p2_m.setCardState(CardState.ACTIVE);
      }
      pushMatrix();
      translate(512, 598); 
      p2_m.drawMissioncard();
      popMatrix();  
      
      textFont(f,20);                                    //Set font settings     
      fill(255);                                         //White font
      
      text("Countries conquered "+p2_conquered,694,665); //Conquered countries
      text(hour()+":"+minute()+":"+second(), 694,700);
      text(p2_name,247,728);                              //Playername
      
    }
    


    hint(DISABLE_DEPTH_TEST);
    /** Draw gaming board */ 
    image(imgBoard, 118.5, 123.5, 788, 521);
    hint(ENABLE_DEPTH_TEST);
    
    
    // GAME STATES
    switch(InGameState.current){
      case InGameState.ATTACK:
       //if( millis() - time_millis > theMov.duration() * 1000){
       if(millis()-time_millis > 2000) {         
          if(activePlayer == 1){
            InGameState.current = InGameState.PLAYER1_TURN;
          } else {
            InGameState.current = InGameState.PLAYER2_TURN;
          }  
        } else {
          int movWidth = theMov.width; 
          int movHeight = theMov.height; 
          int mX = width/2 - movWidth/2;
          int mY = height/2 - movHeight/2; 
        
          //image(theMov,mX,mY);
          image(imgAttack, width/2-imgAttack.width/2, height/2-imgAttack.height/2);
        } 
        
      break;
    }
    
  }
  
  public void playAnimation() {
    
    if(activePlayer == 1) {
      
        if(!revealed) {
        
        Ani.to(p1_m.position, ANI_TIME, "y", 0.0-70.0, Ani.CIRC_OUT);
        Ani.to(p1_m, ANI_TIME, "rotationY", PI*2, Ani.CIRC_OUT);
        revealed = true;
      } else {
        
        Ani.to(p1_m, ANI_TIME, "rotationY", -PI*2, Ani.CIRC_OUT);
        Ani.to(p1_m.position, ANI_TIME, "y", 0.0-0.0, Ani.CIRC_OUT);
        revealed = false;
      }
    
    } else if(activePlayer == 2) {
      
      if(!revealed) {
        
        Ani.to(p2_m.position, ANI_TIME, "y", 0.0+70.0, Ani.CIRC_OUT);
        Ani.to(p2_m, ANI_TIME, "rotationY", PI*2, Ani.CIRC_OUT);
        p2_m.rotationY = 0;
        revealed = true;
      } else {
        
        Ani.to(p2_m, ANI_TIME, "rotationY", -PI*2, Ani.CIRC_OUT);
        Ani.to(p2_m.position, ANI_TIME, "y", 0.0-0.0, Ani.CIRC_OUT);
        revealed = false;
      }

    }
    


  }
  
  public void keyPressed(int keyCode){
    switch(InGameState.current)
    {
      case InGameState.INTRO_SCREEN:
        if(keyCode == ENTER) {
           InGameState.current = InGameState.PLAYER1_TURN; 
         }  
         break; 
      case InGameState.PLAYER1_TURN:
         if(keyCode == ENTER) {
           if(revealed) {
             playAnimation();
           }
           InGameState.current = InGameState.PLAYER2_TURN;
           activePlayer = 2;
         } else if(keyCode == UP) {
           p1_conquered++;
         } else if(keyCode == DOWN) {
           p1_conquered--;
         } else if(keyCode == RIGHT) {
           playAnimation();
         }  else if(keyCode == BACKSPACE){
           InGameState.current = InGameState.ATTACK; 
           theMov = gunfire; 
           time_millis = millis();
         }
         break;
      case InGameState.PLAYER2_TURN:
          if(keyCode == ENTER) {
           if(revealed) {
             playAnimation();
           }
           InGameState.current = InGameState.PLAYER1_TURN; 
           activePlayer = 1;
         } else if(keyCode == UP) {
           p2_conquered++;
         } else if(keyCode == DOWN) {
           p2_conquered--;
         } else if(keyCode == RIGHT) {
           playAnimation();
         } else if(keyCode == BACKSPACE){
           InGameState.current = InGameState.ATTACK;
           // later random
           theMov = gunfire; 
           time_millis = millis();
         }     
         break;
      case InGameState.ATTACK:
        // DO NOTHING ... FOR NOW ;D
        break;
    }
  }
  


}

