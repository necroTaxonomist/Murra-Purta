class TitleScene extends Scene
{
  PImage titleBackground;
  
  public TitleScene()
  {
  }
  public void start(String[] args)
  {
    sound.playMusic("./data/music/titlescreen.mp3", 0, true);
    titleBackground = loadImage("./data/images/menu/titlescreen.png");
    textSize(SCREEN_HEIGHT/15);
    textAlign(CENTER,CENTER);
    fill(0);
  }
  public void execute(String[] args)
  {
    image(titleBackground,0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    text("press A to play yay hey hurray",SCREEN_WIDTH/2, 3*SCREEN_HEIGHT/4);
    
    pads.updatePads();
    for (int i = 0; i < pads.currentPlayers(); i++)
    {
      if (pads.get(i).buttonPressed(confirm[i]))
        running = false;
    }
  }
  public void end(String[] args)
  {
    sound.stopMusic(0);
    setCurrentScene("CharacterSelectScene",null);
  }
}