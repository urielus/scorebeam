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
  PImage board;

  Risiko() {
    this.board = loadImage("risiko spielfeld.jpg");
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
    
    /**
    Do something intelligent
    */

    stroke(175);
  
    textFont(f);       
    fill(255);
  
    textAlign(CENTER);
    text("RISIKO",width/2,60); 
  
    textAlign(LEFT);
    text("This text is left aligned.",width/2,100); 
  
    textAlign(RIGHT);
    text("This text is right aligned.",width/2,140); 

  }
  
  public void drawBoard(int player) {
    int imgWidth  = board.width;
    int imgHeight = board.height; 
    int x = width/2 - imgWidth/2; 
    int y = 0; 
    
    image(board, x, y, imgWidth, imgHeight);

    if(player == '1') {
      println("Player 1 GO");
    } else if(player == '2') {
      println("Player 2 GO");
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

