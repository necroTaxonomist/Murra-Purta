class Gamepiece
{
  float x, y;
  PImage sprite;
  int space;
  color charColor;
  float prevY;
  String name;
  PImage portrait;
  
  public Gamepiece(String nameIn, PImage spriteIn, PImage portraitIn, color colorIn)
  {
    name = nameIn;
    charColor = colorIn;
    sprite = spriteIn;
    portrait = portraitIn;
  }
  public Gamepiece(String filename, color colorIn)
  {
    charColor = colorIn;
    sprite = loadImage(filename);
  }
  public Gamepiece(float xIn, float yIn, String filename, color colorIn, int spaceIn)
  {
    x = xIn;
    y = yIn;
    prevY = -1;
    space = spaceIn;
    charColor = colorIn;
    sprite = loadImage(filename);
  }
  
  public void teleportToSpace(Space space, int index)
  {
    x = space.x;
    y = space.y;
    this.space = index;
  }
  
  public boolean moveToSpace(Space space, int index, float amount)
  {
    float distance = sqrt(pow(x - space.x,2) + pow(y - space.y,2));
    if (distance < amount)
    {
      x = space.x;
      y = space.y;
      this.space = index;
      return true;
    }
    else
    {
      float angle = atan2(y - space.y, space.x - x);
      x += amount * cos(angle);
      y += amount * sin(angle);
      return false;
    }
  }
  
  public void setPrevY()
  {
    prevY = y;
  }
  
  public void hitBlock(DiceBlock d)
  {
    y -= 8;
    if (prevY - y >= 48)
    {
      d.hit();
      y = prevY;
    }
  }
  
}