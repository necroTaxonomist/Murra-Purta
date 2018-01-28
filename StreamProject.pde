final int SCREEN_WIDTH = 800;
final int SCREEN_HEIGHT = 600;
final boolean FULL_SCREEEN = false;
PApplet sketch = this;

GamepadArray pads;
Scene currentScene;
Gamepiece[] pieces;

SoundHandler sound;

int[] confirm;
int[] back;

void settings()
{
  size(SCREEN_WIDTH, SCREEN_HEIGHT, P2D);
  if (FULL_SCREEEN)
    fullScreen();
}

void setup()
{
  frameRate(60);
  
  pads = new GamepadArray(4);
  sound = new SoundHandler(this, 1);
  currentScene = sceneFromName("GamepadScene",null);
  pieces = new Gamepiece[4];
  
  confirm = new int[4];
  back = new int[4];
}

void draw()
{
  if (currentScene != null)
  {
    if (currentScene.isRunning())
      currentScene.execute(null);
    else
    {
      Scene tempScene = currentScene;
      currentScene= null;
      tempScene.end(null);
      background(128);
    }
  }
}

void setCurrentScene(String sceneName, String[] args)
{
  currentScene = sceneFromName(sceneName, args);
}
void setCurrentScene(Scene toScene)
{
  currentScene = toScene;
}