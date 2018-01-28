String[] characterNames;
PImage[] characterSprites;
color[] characterColors;
PImage[] characterPortraits;

void loadCharacters()
{
  characterSprites = new PImage[6];
  characterSprites[0] = loadImage("./data/images/characters/mario.png");
  characterSprites[1] = loadImage("./data/images/characters/sonic.png");
  characterSprites[2] = loadImage("./data/images/characters/megaman.png");
  characterSprites[3] = loadImage("./data/images/characters/pacman.png");
  characterSprites[4] = loadImage("./data/images/characters/shrek.png");
  characterSprites[5] = loadImage("./data/images/characters/donkeykong.png");
  
  characterPortraits = new PImage[6];
  characterPortraits[0] = loadImage("./data/images/characters/portraits/mario.png");
  characterPortraits[1] = loadImage("./data/images/characters/portraits/sonic.png");
  characterPortraits[2] = loadImage("./data/images/characters/portraits/megaman.png");
  characterPortraits[3] = loadImage("./data/images/characters/portraits/pacman.png");
  characterPortraits[4] = loadImage("./data/images/characters/portraits/shrek.png");
  characterPortraits[5] = loadImage("./data/images/characters/portraits/donkeykong.png");
  
  characterNames = new String[6];
  characterNames[0] = "Mario";
  characterNames[1] = "Sonic";
  characterNames[2] = "Mega Man";
  characterNames[3] = "Pac Man";
  characterNames[4] = "Shrek";
  characterNames[5] = "Donkey Kong";
  
  characterColors = new color[6];
  characterColors[0] = color(255,0,0);
  characterColors[1] = color(0,0,255);
  characterColors[2] = color(0,255,255);
  characterColors[3] = color(255,255,0);
  characterColors[4] = color(0,255,0);
  characterColors[5] = color(101,67,33);
  
  sound.loadSound("./data/sounds/mario.mp3", characterNames[0]);
  sound.loadSound("./data/sounds/sonic.mp3", characterNames[1]);
  sound.loadSound("./data/sounds/megaman.mp3", characterNames[2]);
  sound.loadSound("./data/sounds/pacman.mp3", characterNames[3]);
  sound.loadSound("./data/sounds/shrek.mp3", characterNames[4]);
  sound.loadSound("./data/sounds/donkeykong.wav", characterNames[5]);
}

class CharacterSelectScene extends Scene
{
  int[] pointers;
  int[] lastPressed;
  int[] selected;
  PImage pointerSprite;
  int cpuSelect;
  
  public CharacterSelectScene()
  {
    if (characterSprites == null)
      loadCharacters();
  }
  public void start(String[] args)
  {
    cpuSelect = -1;
    sound.playMusic("./data/music/settings.mp3", 0, true);
    
    pointerSprite = loadImage("./data/images/menu/pointer.png");
    
    pointers = new int[4];
    lastPressed = new int[4];
    selected = new int[4];
    for (int i = 0; i < 4; i++)
    {
      pointers[i] = i;
      lastPressed[i] = 0;
      selected[i] = -1;
    }
  }
  public void execute(String[] args)
  {
    background(255);
    
    textSize(SCREEN_HEIGHT/15);
    fill(0);
    textAlign(CENTER, TOP);
    text("Select your character, bruh", SCREEN_WIDTH/2, SCREEN_HEIGHT/50);

    for (int i = 1; i <=5; i += 2)
    {
      if (characterSprites[i-1] != null)
        image(characterSprites[i-1],SCREEN_WIDTH/7*i, SCREEN_HEIGHT/5, SCREEN_WIDTH/7, 4*SCREEN_WIDTH/21);
      else
      {
        fill(255,0,0);
        rect(SCREEN_WIDTH/7*i, SCREEN_HEIGHT/5, SCREEN_WIDTH/7, 4*SCREEN_WIDTH/21);
      }
      if (characterSprites[i] != null)
        image(characterSprites[i],SCREEN_WIDTH/7*i, SCREEN_HEIGHT/2, SCREEN_WIDTH/7, 4*SCREEN_WIDTH/21);
      else
      {
        fill(255,0,0);
        rect(SCREEN_WIDTH/7*i, SCREEN_HEIGHT/2, SCREEN_WIDTH/7, 4*SCREEN_WIDTH/21);
      }
    }
    
    pads.updatePads();
    if (cpuSelect == -1)
    {
      for (int j = 0; j < pads.currentPlayers(); j++)
      {
        if (pads.get(j).buttonPressed(confirm[j]))
        {
          boolean alreadySelected = false;
          for (int i = 0; i < pads.currentPlayers(); i++)
          {
            if (selected[i] == pointers[j])
              alreadySelected = true;
          }
          if (!alreadySelected)
          {
            selected[j] = pointers[j];
            sound.playSound(characterNames[pointers[j]]);
          }
        }
        
        if (selected[j] == -1)
        {
          if (lastPressed[j] > 0)
          {
            lastPressed[j]--;
          }
          else
          {
            float stickX, stickY;
            stickX = pads.get(j).getStickX();
            stickY = pads.get(j).getStickY();
            
            if (stickX > .2)
            {
              pointers[j] = (pointers[j] + 2) % 6;
              lastPressed[j] = 15;
            }
            else if (stickX < -.2)
            {
              pointers[j] = (pointers[j] - 2) % 6;
              lastPressed[j] = 15;
            }
            else if (stickY > .2)
            {
              pointers[j] = (pointers[j] + 1) % 6;
              lastPressed[j] = 15;
            }
            else if (stickY < -.2)
            {
              pointers[j] = (pointers[j] - 1) % 6;
              lastPressed[j] = 15;
            }
            if (pointers[j] < 0)
              pointers[j] += 6;
          }
          
          textSize(2*SCREEN_HEIGHT/15);
          fill(0);
          textAlign(LEFT, TOP);
          if (pointers[j] % 2 == 0)
          {
            image(pointerSprite, SCREEN_WIDTH/7*(pointers[j]+1) - SCREEN_WIDTH/7 + j*SCREEN_WIDTH/50, SCREEN_HEIGHT/5 + j*SCREEN_WIDTH/50, SCREEN_WIDTH/7, SCREEN_WIDTH/7);
            text(j+1, SCREEN_WIDTH/7*(pointers[j]+1) - SCREEN_WIDTH/7 + j*SCREEN_WIDTH/50, SCREEN_HEIGHT/5 + j*SCREEN_WIDTH/50);
          }
          else
          {
            image(pointerSprite, SCREEN_WIDTH/7*(pointers[j]) - SCREEN_WIDTH/7 + j*SCREEN_WIDTH/50, SCREEN_HEIGHT/2 + j*SCREEN_WIDTH/50, SCREEN_WIDTH/7, SCREEN_WIDTH/7);
            text(j+1, SCREEN_WIDTH/7*(pointers[j]) - SCREEN_WIDTH/7 + j*SCREEN_WIDTH/50, SCREEN_HEIGHT/2 + j*SCREEN_WIDTH/50);
          }
        }
        else
        {
          if (pads.get(j).buttonPressed(back[j]))
          {
            selected[j] = -1;
          }
          textSize(4*SCREEN_HEIGHT/15);
          fill(0);
          textAlign(LEFT, TOP);
          if (pointers[j] % 2 == 0)
          {
            text(j+1, SCREEN_WIDTH/7*(pointers[j]+1), SCREEN_HEIGHT/5);
          }
          else
          {
            text(j+1, SCREEN_WIDTH/7*(pointers[j]), SCREEN_HEIGHT/2);
          }
        }
      }
      
      boolean allChosen = true;
      for (int s = 0; s < pads.currentPlayers(); s++)
      {
        if (selected[s] == -1)
          allChosen = false;
      }
      if (allChosen)
      {
        if (pads.currentPlayers() == 4)
          running = false;
        else
          cpuSelect = pads.currentPlayers();
      }
    }
    else
    {
      for (int j = 0; j < cpuSelect; j++)
      {
        textSize(4*SCREEN_HEIGHT/15);
        fill(0);
        textAlign(LEFT, TOP);
        if (pointers[j] % 2 == 0)
        {
          text(j+1, SCREEN_WIDTH/7*(pointers[j]+1), SCREEN_HEIGHT/5);
        }
        else
        {
          text(j+1, SCREEN_WIDTH/7*(pointers[j]), SCREEN_HEIGHT/2);
        }
      }
      
      
      if (pads.get(0).buttonPressed(confirm[0]))
        {
          boolean alreadySelected = false;
          for (int i = 0; i < cpuSelect; i++)
          {
            if (selected[i] == pointers[cpuSelect])
              alreadySelected = true;
          }
          if (!alreadySelected)
          {
            selected[cpuSelect] = pointers[cpuSelect];
            sound.playSound(characterNames[pointers[cpuSelect]]);
          }
        }
        if (pads.get(0).buttonPressed(back[0]) && cpuSelect > 0)
          {
            selected[cpuSelect-1] = -1;
            if (cpuSelect == pads.currentPlayers())
              cpuSelect = -1;
            else
              cpuSelect--;
          }
        
        if (cpuSelect >= 0 && cpuSelect < 4 && selected[cpuSelect] == -1)
        {
          if (lastPressed[cpuSelect] > 0)
          {
            lastPressed[cpuSelect]--;
          }
          else
          {
            float stickX, stickY;
            stickX = pads.get(0).getStickX();
            stickY = pads.get(0).getStickY();
            
            if (stickX > .2)
            {
              pointers[cpuSelect] = (pointers[cpuSelect] + 2) % 6;
              lastPressed[cpuSelect] = 15;
            }
            else if (stickX < -.2)
            {
              pointers[cpuSelect] = (pointers[cpuSelect] - 2) % 6;
              lastPressed[cpuSelect] = 15;
            }
            else if (stickY > .2)
            {
              pointers[cpuSelect] = (pointers[cpuSelect] + 1) % 6;
              lastPressed[cpuSelect] = 15;
            }
            else if (stickY < -.2)
            {
              pointers[cpuSelect] = (pointers[cpuSelect] - 1) % 6;
              lastPressed[cpuSelect] = 15;
            }
            if (pointers[cpuSelect] < 0)
              pointers[cpuSelect] += 6;
          }
          
          textSize(2*SCREEN_HEIGHT/15);
          fill(0);
          textAlign(LEFT, TOP);
          if (pointers[cpuSelect] % 2 == 0)
          {
            image(pointerSprite, SCREEN_WIDTH/7*(pointers[cpuSelect]+1) - SCREEN_WIDTH/7 + cpuSelect*SCREEN_WIDTH/50, SCREEN_HEIGHT/5 + cpuSelect*SCREEN_WIDTH/50, SCREEN_WIDTH/7, SCREEN_WIDTH/7);
            text(cpuSelect+1, SCREEN_WIDTH/7*(pointers[cpuSelect]+1) - SCREEN_WIDTH/7 + cpuSelect*SCREEN_WIDTH/50, SCREEN_HEIGHT/5 + cpuSelect*SCREEN_WIDTH/50);
          }
          else
          {
            image(pointerSprite, SCREEN_WIDTH/7*(pointers[cpuSelect]) - SCREEN_WIDTH/7 + cpuSelect*SCREEN_WIDTH/50, SCREEN_HEIGHT/2 + cpuSelect*SCREEN_WIDTH/50, SCREEN_WIDTH/7, SCREEN_WIDTH/7);
            text(cpuSelect+1, SCREEN_WIDTH/7*(pointers[cpuSelect]) - SCREEN_WIDTH/7 + cpuSelect*SCREEN_WIDTH/50, SCREEN_HEIGHT/2 + cpuSelect*SCREEN_WIDTH/50);
          }
        }
        else if (cpuSelect >= 0 && cpuSelect < 4)
        {
          textSize(4*SCREEN_HEIGHT/15);
          fill(0);
          textAlign(LEFT, TOP);
          if (pointers[cpuSelect] % 2 == 0)
          {
            text(cpuSelect+1, SCREEN_WIDTH/7*(pointers[cpuSelect]+1), SCREEN_HEIGHT/5);
          }
          else
          {
            text(cpuSelect+1, SCREEN_WIDTH/7*(pointers[cpuSelect]), SCREEN_HEIGHT/2);
          }
        }
      }
      
      if (cpuSelect > 0 && selected[cpuSelect] != -1)
      {
        if (cpuSelect == 3)
          running = false;
        else
          cpuSelect++;
      }
  }
  public void end(String[] args)
  {
    for (int i = 0; i < selected.length; i++)
    {
      pieces[i] = getCharacter(selected[i]);
    }
    
    String[] argsIn = new String[1];
    argsIn[0] = "zooming";
    setCurrentScene("MainScene",argsIn);
  }
  
  public boolean isRunning()
  {
    return running;
  }
}

Gamepiece getCharacter(int index)
{
  return new Gamepiece(characterNames[index], characterSprites[index], characterPortraits[index], characterColors[index]);
}