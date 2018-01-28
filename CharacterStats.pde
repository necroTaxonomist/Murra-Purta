PImage starsIcon;
PImage coinsIcon;

class CharacterStats
{
  private Gamepiece piece;
  private int coins;
  private int shownCoins;
  private int stars;
  private int shownStars;
  
  public CharacterStats(Gamepiece g)
  {
    piece = g;
    coins = 0;
    shownCoins = 0;
    stars = 0;
    shownStars = 0;
    if (starsIcon == null)
      starsIcon = loadImage("./data/images/gui/stars_icon.png");
    if (coinsIcon == null)
      coinsIcon = loadImage("./data/images/gui/coins_icon.png");
  }
  
  public void drawSelf(int lr, int tb)
  {
    int x = SCREEN_WIDTH * 3 * lr / 4;
    int y = SCREEN_HEIGHT * 5 * tb / 6;
    
    fill(128, 128, 128, 128);
    rect(x, y, SCREEN_WIDTH / 4, SCREEN_HEIGHT / 6);
    
    fill(255);
    image(piece.portrait, x + SCREEN_HEIGHT / 48, y + SCREEN_HEIGHT / 48, SCREEN_HEIGHT / 8, SCREEN_HEIGHT / 8);
    image(coinsIcon, x + SCREEN_WIDTH / 8, y + SCREEN_HEIGHT / 48, SCREEN_HEIGHT / 30, SCREEN_HEIGHT / 30);
    image(starsIcon, x + SCREEN_WIDTH / 8, y + SCREEN_HEIGHT / 12, SCREEN_HEIGHT / 30, SCREEN_HEIGHT / 30);
    
    if (shownCoins < coins)
      shownCoins++;
    if (shownStars < stars)
      shownStars++;
    
    fill(0);
    textSize(SCREEN_HEIGHT/30);
    textAlign(LEFT,TOP);
    text(" x " + shownCoins, x + SCREEN_WIDTH / 8 + SCREEN_HEIGHT / 30, y + SCREEN_HEIGHT / 48);
    text(" x " + shownStars, x + SCREEN_WIDTH / 8 + SCREEN_HEIGHT / 30, y + SCREEN_HEIGHT / 12);
  }
  
  public void addCoins(int addition)
  {
    coins += addition;
  }
  public void addStars(int addition)
  {
    stars += addition;
  }
  
  public Gamepiece gamepiece()
  {
    return piece;
  }
  
}