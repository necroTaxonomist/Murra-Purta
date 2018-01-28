








































class Scene
{
  protected boolean running;
  
  public Scene()
  {
    running = true;
  }
  public void start(String[] args)
  {
  }
  public void execute(String[] args)
  {
  }
  public void end(String[] args)
  {
  }
  
  public boolean isRunning()
  {
    return running;
  }
}

Scene sceneFromName(String name, String[] args)
{
  Scene returnScene = null;
  if (name.equals("GamepadScene"))
  {
    returnScene = new GamepadScene();
  }
  else if (name.equals("MainScene"))
  {
    returnScene = new MainScene();
  }
  else if (name.equals("CharacterSelectScene"))
  {
    returnScene = new CharacterSelectScene();
  }
  else if (name.equals("TitleScene"))
  {
    returnScene = new TitleScene();
  }
  
  returnScene.start(args);
  return returnScene;
}

class GamepadScene extends Scene
{
  ArrayList<Gamepad> allPads;
  PImage gcControllerImage;
  int iconSize;
  
  public GamepadScene()
  {
    super();
    gcControllerImage = loadImage("./data/images/menu/gc_controller.png");
    iconSize = 3 * SCREEN_WIDTH / 20;
 
  }
  
  public void start(String[] args)
  {
    allPads = getAllGamepads(sketch);
    fill(0);
    textAlign(CENTER);
  }
  public void execute(String[] args)
  {
    background(255);
    textSize(SCREEN_HEIGHT/15);
    text("Press a button on your controller to join",SCREEN_WIDTH/2,SCREEN_HEIGHT/5);
    textSize(SCREEN_HEIGHT/20);
    text("Press a key on the keyboard when all players are in",SCREEN_WIDTH/2,2*SCREEN_HEIGHT/5);
    
    Gamepad added;
    added = pads.addFromList(allPads);
    if (added != null && added.type().equals("GAMECUBE"))
    {
      confirm[pads.currentPlayers()-1] = 1;
      back[pads.currentPlayers()-1] = 2;
    }
    
    int distBetween = SCREEN_WIDTH / (pads.currentPlayers() + 1);
    for (int i = 1; i <= pads.currentPlayers(); i++)
    {
      image(gcControllerImage,distBetween*i - iconSize/2,3*SCREEN_HEIGHT/4,iconSize,iconSize);
    }
    if (keyPressed)
      running = false;
  }
  public void end(String[] args)
  {
    setCurrentScene("TitleScene",null);
  }
}