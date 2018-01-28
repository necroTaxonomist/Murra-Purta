class View
{
  private float x, y, w, h;
  
  public View(float xIn, float yIn, float wIn, float hIn)
  {
    x = xIn;
    y = yIn;
    w = wIn;
    h = hIn;
  }
  
  public float convertX(float inputX)
  {
    return SCREEN_WIDTH * (inputX - x) / w;
  }
  public float convertY(float inputY)
  {
    return SCREEN_HEIGHT * (inputY - y) / h;
  }
  public float convertW(float inputW)
  {
    return SCREEN_WIDTH * (inputW) / w;
  }
  public float convertH(float inputH)
  {
    return SCREEN_HEIGHT * (inputH) / h;
  }
  
  public void drawImage(PImage image, float atX, float atY, float ofW, float ofH)
  {
    image(image, convertX(atX), convertY(atY), convertW(ofW), convertH(ofH));
  }
  
  public void move(float xMove, float yMove)
  {
    x += xMove;
    y += yMove;
  }
  
  public void set(float xTo, float yTo)
  {
    x = xTo;
    y = yTo;
  }
  
  public void addZoom(float wZoom)
  {
    w += wZoom;
    h += 3*wZoom/4;
  }
  public void addZoom(float wZoom, float hZoom)
  {
    w += wZoom;
    h += hZoom;
  }
  
  public void setZoom(float newW, float newH)
  {
    w = newW;
    h = newH;
  }
  
  public void drawGamepiece(Gamepiece g)
  {
    image(g.sprite,convertX(g.x) - convertW(48)/2, convertY(g.y) - convertH(64), convertW(48), convertH(64));
  }
  
  public void goToGamepiece(Gamepiece g)
  {
    x = g.x - w/2;
    y = g.y - 2*h/3;
  }
  
  public boolean moveToPoint(float toX, float toY, float amount)
  {
    float distance = sqrt(pow(x + w/2 - toX,2) + pow(y + 2*h/3 - toY,2));
    if (distance < amount)
    {
      x = toX - w/2;
      y = toY - 2*h/3;
      return true;
    }
    else
    {
      float angle = atan2(y + 2*h/3 - toY, toX - x - w/2);
      x += amount * cos(angle);
      y -= amount * sin(angle);
      return false;
    }
  }
  
  public void drawSpace(Space s)
  {
    image(s.spaceImage, convertX(s.x) - convertW(SPACE_SIZE)/2, convertY(s.y) - convertH(3*SPACE_SIZE/4)/2,
            convertW(SPACE_SIZE), convertH(3*SPACE_SIZE/4));
  }
  
  public void starAboveSpace(Space s)
  {
    if (s != null)
    {
      image(floatingStar, convertX(s.x) - convertW(SPACE_SIZE)/2,convertY(s.y-128) - convertH(3*SPACE_SIZE/4)/2,
              convertW(SPACE_SIZE), convertH(SPACE_SIZE));
    }
  }
  
  public void drawDiceBlock(DiceBlock d, float xIn, float yIn, float heightAbove)
  {
    image(diceImages[d.currentNum-1], convertX(xIn)-convertW(48)/2, convertY(yIn - heightAbove) - convertH(48), convertW(48), convertH(48));
    if (!d.rolling)
    {
      fill(255,0,0);
      
      textSize(2*SCREEN_HEIGHT/15);
      textAlign(CENTER,BOTTOM);
      text(d.currentNum, convertX(xIn), convertY(yIn - heightAbove));
    }
  }
  public void drawDiceBlock(DiceBlock d, Gamepiece above, float heightAbove)
  {
    image(diceImages[d.currentNum-1], convertX(above.x)-convertW(48)/2, convertY(above.y - heightAbove) - convertH(48), convertW(48), convertH(48));
    if (!d.rolling)
    {
      fill(255,0,0);
      
      textSize(2*SCREEN_HEIGHT/15);
      textAlign(CENTER,BOTTOM);
      text(d.currentNum, SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }
  }
  public void drawDiceBlock(DiceBlock d, Space above, float heightAbove)
  {
    image(diceImages[d.currentNum-1], convertX(above.x)-convertW(48)/2, convertY(above.y - heightAbove) - convertH(48), convertW(48), convertH(48));
    if (!d.rolling)
    {
      fill(255,0,0);
      
      textSize(2*SCREEN_HEIGHT/15);
      textAlign(CENTER,BOTTOM);
      text(d.currentNum, SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }
  }
  
  public float getX() { return x; }
}