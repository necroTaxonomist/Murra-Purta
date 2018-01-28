PImage[] diceImages;
ArrayList<Integer> possibleRolls;

class DiceBlock
{
  int currentNum;
  boolean rolling;
  
  public DiceBlock()
  {
    if (diceImages == null)
      diceImages = getDiceImages();
    if (possibleRolls == null)
    {
      resetRolls();
    }
    rolling = true;
    newNum();
  }
  
  public void newNum()
  {
    int index = (int)random(possibleRolls.size());
    currentNum = possibleRolls.get(index);
  }
  
  public int hit()
  {
    rolling = false;
    return currentNum;
  }
  
  public void inc()
  {
    currentNum++;
    if (currentNum > 10)
      currentNum -= 10;
  }
}

void resetRolls()
{
  possibleRolls = new ArrayList<Integer>();
  for (int i = 1; i <= 10; i++)
    possibleRolls.add(new Integer(i));
}

void removeRoll(int value)
{
  for (int i = 0; i < possibleRolls.size(); i++)
  {
    if (possibleRolls.get(i).equals(value))
    {
      possibleRolls.remove(i);
      break;
    }
  }
}

PImage[] getDiceImages()
{
  PImage[] toReturn = new PImage[10];
  for (int i = 1; i <= 10; i++)
  {
    toReturn[i-1] = loadImage("./data/images/dice/" + i + ".png");
  }
  return toReturn;
}