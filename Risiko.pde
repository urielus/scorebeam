/**
Risiko Class
*/
/*---- GAME STATES -----*/
static class InGameState {
  public static final int NO_STATE        = 0;
  public static final int INTRO_SCREEN    = 1; 
  public static final int PLAYER1_TURN   = 2; 
  public static final int PLAYER2_TURN     = 3;
  public static final int PLAYER1_MISSIONCARD     = 4;
  public static final int ATTACK   = 5;  

  public static int current = INTRO_SCREEN;
}


class Risiko {



  PFont f;
  PImage imgBoard;
  PImage imgMenu;
  //player graphics active
  PImage player1a;
  PImage player2a;
  //player graphics passive
  PImage player1i;
  PImage player2i;
  //player mission cards
  PImage player1mc;
  PImage player2mc;
 

  Risiko() {
    imgBoard = loadImage("risiko788.jpg");
    imgMenu = loadImage("risk_menu.png");
    
    player2a = loadImage("gameplay/red100.png");
    player1a = loadImage("gameplay/yellow100.png");
    
    f = createFont("Arial",16,true); 
  }

  public void draw(){
    
  switch(InGameState.current)
  {
    case InGameState.INTRO_SCREEN:
     drawMenu();
    break; 
    case InGameState.PLAYER1_TURN:
      drawBoard(1);
    break;
    case InGameState.PLAYER2_TURN:
      drawBoard(2);
    break;
    case InGameState.PLAYER1_MISSIONCARD:

    break;
    case InGameState.ATTACK:

    break;
  }
  
    
  }
  public void drawMenu() {
    
    image(imgMenu,  0, 0, 1024, 768);

  }
  
  public void drawBoard(int player) {
    
    println("Player: "+player);
    
    image(imgBoard, 118.5, 123.5, 788, 521);

    if(player == 1) {
      image(player1a, 100, 20, 58, 100);

    } else if(player == 2) {
      image(player2a, 865, 648, 58, 100);
    }
  }
  
  public void playAnimation() {
    
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
           InGameState.current = InGameState.PLAYER2_TURN; 
         }  
      break;
      case InGameState.PLAYER2_TURN:
          if(keyCode == ENTER) {
           InGameState.current = InGameState.PLAYER1_TURN; 
         }  
      break;
          case InGameState.PLAYER1_MISSIONCARD:
      break;
          case InGameState.ATTACK:
      break;
    }
    println(InGameState.current);
  }
  


}

