PImage[] allSpaces;
PImage floatingStar;

float SPACE_SIZE = 64;

class Space
{
  int x,y;
  String type;
  PImage spaceImage;
  public Space(int xIn, int yIn, String typeIn)
  {
    x = xIn;
    y = yIn;
    type = typeIn;
    spaceImage = spaceFromName(typeIn);
  }
}

PImage[] getSpaceImages()
{
  PImage[] toReturn = new PImage[5];
  toReturn[0] = loadImage("./data/images/spaces/blue.png");
  toReturn[1] = loadImage("./data/images/spaces/red.png");
  toReturn[2] = loadImage("./data/images/spaces/happening.png");
  toReturn[3] = loadImage("./data/images/spaces/mushroom.png");
  toReturn[4] = loadImage("./data/images/spaces/star.png");
  return toReturn;
}

PImage spaceFromName(String name)
{
  if (name.equals("blue"))
    return allSpaces[0];
  else if (name.equals("red"))
    return allSpaces[1];
  else if (name.equals("happening"))
    return allSpaces[2];
  else if (name.equals("mushroom"))
    return allSpaces[3];
  else if (name.equals("star"))
    return allSpaces[4];
  else
    return null;
}

class PathSwitch
{
  int from, path1, path2;
  public PathSwitch(int fromIn, int p1In)
  {
    from = fromIn;
    path1 = p1In;
    path2 = -1;
  }
  public PathSwitch(int fromIn, int p1In, int p2In)
  {
    from = fromIn;
    path1 = p1In;
    path2 = p2In;
  }
}

class SpaceArray
{
  private ArrayList<Space> spaces;
  private ArrayList<PathSwitch> switches;
  int starSpace;
  
  public SpaceArray(String spacesFile, String switchesFile)
  {
    if (allSpaces == null)
    {
      allSpaces = getSpaceImages();
      floatingStar = loadImage("./data/images/spaces/floating_star.png");
    }
    
    BufferedReader reader;
    String line;
    reader = createReader(spacesFile);    
    
    spaces = new ArrayList<Space>();
    do
    {
      try
      {
        line = reader.readLine();
      }
      catch (IOException e)
      {
        e.printStackTrace();
        line = null;
      }
      if (line != null && !line.equals(""))
      {
        String[] args = splitTokens(line,",");
        spaces.add(new Space(int(args[0]),int(args[1]),args[2]));
      }
    }
    while (line != null);
    
    reader = createReader(switchesFile);
    
    switches = new ArrayList<PathSwitch>();
    do
    {
      try
      {
        line = reader.readLine();
      }
      catch (IOException e)
      {
        e.printStackTrace();
        line = null;
      }
      if (line != null && !line.equals(""))
      {
        String[] args = splitTokens(line,",");
        if (args.length == 2)
          switches.add(new PathSwitch(int(args[0]), int(args[1])));
        else
          switches.add(new PathSwitch(int(args[0]), int(args[1]), int(args[2])));
      }
    }
    while (line != null);
    
    starSpace = -1;
  }
  
  public int[] nextSpace(int currentSpace)
  {
    int[] toReturn = null;
    for (PathSwitch p : switches)
    {
      if (p.from == currentSpace)
      {
        if (p.path2 != -1)
        {
          toReturn = new int[2];
          toReturn[0] = p.path1;
          toReturn[1] = p.path2;
        }
        if (p.path2 == -1)
        {
          toReturn = new int[1];
          toReturn[0] = p.path1;
        }
      }
    }
    return toReturn;
  }
  
  public Space get(int index)
  {
    if (index == starSpace)
      return new Space(spaces.get(index).x, spaces.get(index).y, "star");
    else
      return spaces.get(index);
  }
  
  public int size()
  {
    return spaces.size();
  }
  
  public void moveStar()
  {
    int tempStar;
    do
    {
      tempStar = (int)random(spaces.size());
    }
    while(get(tempStar).type.equals("happening") || get(tempStar).type.equals("star"));
    
    starSpace = tempStar;
  }
  
  public Space starSpace()
  {
    if (starSpace == -1)
      return null;
    else
      return new Space(spaces.get(starSpace).x, spaces.get(starSpace).y, "star");
  }
}