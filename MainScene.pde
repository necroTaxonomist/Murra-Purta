int startingX[];
int startingY;

CharacterStats[] stats;
ArrayList<Integer> playerVals;

class MainScene extends Scene
{
  View view;
  String status;
  int timer;
  int subTimer;
  
  PImage background;
  PImage boardTitle;
  PImage startSpace;
  
  int whoseTurn;
  
  SpaceArray spaces;
  
  DiceBlock[] startingBlocks;
  DiceBlock movingBlock;
  
  int spacesLeft;
  int nextSpace;
  
  public MainScene()
  {
    super();
    if (startingX == null)
    {
      startingX = new int[4];
      startingX[0] = 950;
      startingX[1] = 1025;
      startingX[2] = 1100;
      startingX[3] = 1175;
      startingY = 850;
    }
  }
  public void start(String[] args)
  {
    status = args[0];
    
    if (status.equals("zooming"))
    {
      startingBlocks = new DiceBlock[4];
    
      for (int i = 0; i < 4; i++)
      {
        if (pieces[i] != null)
        {
          pieces[i].x = (float)startingX[i];
          pieces[i].y = (float)startingY;
          if (status.equals("zooming"))
            startingBlocks[i] = new DiceBlock();
        }
      }
      
      boardTitle = loadImage("./data/images/gui/board_title.png");
      sound.playMusic("./data/music/zoomin.mp3", 0, true);
    }
    
    view = new View(0,0,1280,960);
    
    spaces = new SpaceArray("./data/spaces.txt", "./data/switches.txt");
    
    background = loadImage("./data/images/background/board.png");
    startSpace = loadImage("./data/images/background/start.png");
    
    timer = 0;
  }
  
  public void execute(String[] args)
  {
    drawBackground();
    
    if (playerVals == null)
    {
      for (int i = 0; i < 4; i++)
      {
        if (pieces[i] != null)
          view.drawGamepiece(pieces[i]);
      }
    }
    else
    {
      for (int i = 0; i < 4; i++)
      {
        if (i != whoseTurn && pieces[playerVals.get(i)] != null)
          view.drawGamepiece(pieces[playerVals.get(i)]);
      }
      view.drawGamepiece(pieces[playerVals.get(whoseTurn)]);
    }
    
    if (status.equals("zooming"))
    {
      if (timer < 60)
        timer++;
      else if (view.getX() < 2*1280/3)
      {
        view.addZoom(-4);
        view.move(4,3);
      }
      else
        timer++;
      
      if (timer < 90)
      {
        image(boardTitle,SCREEN_WIDTH/2 - SCREEN_WIDTH/6, SCREEN_HEIGHT/2 - 0.814*SCREEN_WIDTH/6, SCREEN_WIDTH/3, 0.814*SCREEN_WIDTH/3);
      }
      else if (timer < 120)
      {
        timer++;
      }
      else
      {
        status = "order_deciding";
        timer = 0;
      }
    }
    if (status.equals("order_deciding"))
    {
      if (timer == 0)
      {
        timer = 1;
        for (int i = 0; i < 4; i++)
        {
          if (pieces[i] != null)
            pieces[i].prevY = -1;
        }
      }
      textSize(SCREEN_HEIGHT/15);
        textAlign(CENTER,TOP);
        fill(0);
      text("yo dogs roll them dice",SCREEN_WIDTH/2,SCREEN_WIDTH/50);
      text("to decide yall's order",SCREEN_WIDTH/2,3*SCREEN_WIDTH/50);
      pads.updatePads();
      boolean noneRolling = true;
      for (int i = 0; i < 4; i++)
      {
        if (pieces[i] != null)
        {
          if ( pieces[i].prevY == -1 && ( (pads.get(i) == null && (i == 0 || !startingBlocks[i-1].rolling))
              || (pads.get(i) != null && pads.get(i).buttonPressed(confirm[i])) ) )
          {
            pieces[i].setPrevY();
          }
          if (startingBlocks[i].rolling)
          {
            noneRolling = false;
            if (pieces[i].prevY != -1)
            {
              pieces[i].hitBlock(startingBlocks[i]);
            }
            startingBlocks[i].newNum();
          }
          else
          {
            removeRoll(startingBlocks[i].currentNum);
          }
          view.drawDiceBlock(startingBlocks[i], pieces[i].x, startingY, 96);
        }
      }
      if (noneRolling)
      {
        resetRolls();
        playerVals = new ArrayList<Integer>();
        ArrayList<Integer> diceVals = new ArrayList<Integer>();
        for (int k = 0; k < 4; k++)
        {
          if (playerVals.size() == 0)
          {
            playerVals.add(new Integer(k));
            diceVals.add(new Integer(startingBlocks[k].currentNum));
          }
          else
          {
            boolean inserted = false;
            for (int q = 0; q < playerVals.size(); q++)
            {
              if (!inserted && startingBlocks[k].currentNum > diceVals.get(q))
              {
                playerVals.add(q,new Integer(k));
                diceVals.add(q, new Integer(startingBlocks[k].currentNum));
                inserted = true;
                break;
              }
            }
            if (!inserted)
            {
              playerVals.add(new Integer(k));
              diceVals.add(new Integer(startingBlocks[k].currentNum));
            }
          }
        }
        status = "assigning";
        timer = -1;
      }
      stats = new CharacterStats[4];
    }
    if (status.equals("assigning"))
    {
      pads.updatePads();
      for (int i = 0; i < 4; i++)
      {
          view.drawDiceBlock(startingBlocks[i], pieces[i].x, startingY, 96);
      }
      
      if (timer == -1)
      {
        for (int p = 0; p < pads.currentPlayers(); p++)
        {
          if (pads.get(p) != null && pads.get(p).buttonPressed(confirm[p]))
            timer++;
        }
      }
      else if (timer < 4 && stats[timer] == null)
      {
        stats[timer] = new CharacterStats(pieces[playerVals.get(timer)]);
        sound.playSound(pieces[playerVals.get(timer)].name);
      }
      else if (timer < 4)
      {
        if (pads.get(playerVals.get(timer)) != null)
        {
          if (pads.get(playerVals.get(timer)).buttonPressed(confirm[playerVals.get(timer)]))
            timer++;
        }
        else
        {
          if (pads.get(0).buttonPressed(confirm[0]))
            timer++;
        }
      }
      
      for (int b = 3; b >= 0; b--)
      {
        if (stats[b] != null)
        {
          fill(0);
          textSize(SCREEN_HEIGHT/18);
          textAlign(CENTER, TOP);
          text(pieces[playerVals.get(b)].name + " goes " + (b+1) + "st", SCREEN_WIDTH/2, 0);
          break;
        }
      }
      
      if (timer > 3 && stats[3] != null)
      {
        status = "givecoins";
        for (int i = 0; i < 4; i++)
        {
          stats[i].addCoins(10);
        }
        timer = -1;
      }
    }
    if (status.equals("givecoins"))
    {
      fill(0);
      textSize(SCREEN_HEIGHT/18);
      textAlign(CENTER, TOP);
      text("errybody gets coins", SCREEN_WIDTH/2, 0);
      
      pads.updatePads();
      
      if (timer == -1)
      {
        for (int p = 0; p < pads.currentPlayers(); p++)
        {
          if (pads.get(p) != null && pads.get(p).buttonPressed(confirm[p]))
          {
            sound.stopMusic(0);
            timer = 0;
          }
        }
      }
      if (timer != -1)
      {
        timer++;
        background(0);
        if (timer > 60)
        {
          sound.playMusic("./data/music/newstarspace.mp3", 0, true);
          view.set(640,480);
          view.setZoom(640,480);
          spaces.moveStar();
          timer = -1;
          status = "newstarspace";
        }
      }
    }
    if (status.equals("newstarspace"))
    {
      pads.updatePads();
      if (timer == -1 && view.moveToPoint(spaces.starSpace().x,spaces.starSpace().y,4))
      {
        fill(0);
        textSize(SCREEN_HEIGHT/15);
        textAlign(CENTER, CENTER);
        text("here's the star you dumb fuck", SCREEN_WIDTH/2, SCREEN_HEIGHT/4);
        
        for (int p = 0; p < pads.currentPlayers(); p++)
        {
          if (pads.get(p) != null && pads.get(p).buttonPressed(confirm[p]))
          {
            sound.stopMusic(0);
            timer = 0;
          }
        }
      }
      if (timer != -1)
      {
        timer++;
        background(0);
        if (timer > 60)
        {
          sound.playMusic("./data/music/board.mp3", 0, true);
          for (int i = 0; i < 4; i++)
          {
            pieces[i].teleportToSpace(spaces.get(0),0);
          }
          view.goToGamepiece(stats[0].gamepiece());
          timer = 0;
          subTimer = 0;
          
          whoseTurn = 0;
          
          status = "turn";
        }
      }
    }
    if (status.equals("turn"))
    {
      pads.updatePads();
      if (timer == 0)
      {
        fill(0);
        textSize(2*SCREEN_HEIGHT/15);
        textAlign(CENTER, CENTER);
        text(pieces[playerVals.get(whoseTurn)].name.toUpperCase() + "'s TURN", SCREEN_WIDTH/2, SCREEN_HEIGHT/4);
        
        if (pads.get(playerVals.get(whoseTurn)) != null)
        {
          if (pads.get(playerVals.get(whoseTurn)).buttonPressed(confirm[playerVals.get(whoseTurn)]))
          {
            timer++;
            movingBlock = new DiceBlock();
          }
        }
        else
        {
          subTimer++;
          if (subTimer > 60)
          {
            subTimer = 0;
            timer++;
            movingBlock = new DiceBlock();
            pieces[playerVals.get(whoseTurn)].setPrevY();
          }
        }
      }
      if (timer == 1)
      {
        if (movingBlock.rolling)
        {
          view.drawDiceBlock(movingBlock,spaces.get(pieces[playerVals.get(whoseTurn)].space),96);
          movingBlock.newNum();
        }
        if (subTimer < 60)
        {
          if (pads.get(playerVals.get(whoseTurn)) != null)
          {
            if (pads.get(playerVals.get(whoseTurn)).buttonPressed(confirm[playerVals.get(whoseTurn)]))
            {
              subTimer = 60;
            }
          }
          else
          {
            subTimer++;
          }
          
        }
        else if (subTimer == 60)
        {
          if (movingBlock.rolling)
          {
            pieces[playerVals.get(whoseTurn)].hitBlock(movingBlock);
          }
          else
          {
            spacesLeft = movingBlock.currentNum;
            timer = 2;
            subTimer = 0;
          }
        }
      }
      if (timer == 2)
      {
        fill(255,0,0);
        textSize(2*SCREEN_HEIGHT/15);
        textAlign(CENTER,BOTTOM);
        text(spacesLeft, SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        
        if (subTimer < 15)
          subTimer++;
        else
        {
          if (nextSpace == -1)
          {
            if (spaces.nextSpace(pieces[playerVals.get(whoseTurn)].space).length == 1)
            {
              nextSpace = spaces.nextSpace(pieces[playerVals.get(whoseTurn)].space)[0];
            }
          }
          else
          {
            if (pieces[playerVals.get(whoseTurn)].moveToSpace(spaces.get(nextSpace), nextSpace, 2))
            {
              nextSpace = -1;
              subTimer = 0;
            }
          }
        }
      }
      
    }
    
    if (stats != null)
      drawGUI();
  }
  
  public void drawBackground()
  {
    background(255);
    view.drawImage(background,0,0,1280,960);
    view.drawImage(startSpace,900,700,350,262.5);
    for (int i = 0; i < spaces.size(); i++)
    {
      view.drawSpace(spaces.get(i));
    }
    view.starAboveSpace(spaces.starSpace());
  }
  
  public void drawGUI()
  {
    for (int i = 0; i < 4; i++)
    {
      if (stats[i] != null)
        stats[i].drawSelf(i % 2, i / 2);
    }
  }
  
  public void end(String[] args)
  {
  }
  
  public boolean isRunning()
  {
    return running;
  }
}