import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

ArrayList<Gamepad> getAllGamepads(PApplet sketch)
{
  ControlIO controlio = ControlIO.getInstance(sketch);
  ArrayList<ControlDevice> cDevices = (ArrayList)controlio.getDevices();
  ArrayList<Gamepad> pads = new ArrayList<Gamepad>();
  String name;
  for (ControlDevice cd : cDevices)
  {
    name = cd.toListText("");
    if (name.toLowerCase().indexOf("gamepad") != -1)
    {
      pads.add(new Gamepad(cd));
      cd.open();
    }
  }
  return pads;
}

class Gamepad
{
  private ControlDevice device;
  private String name;
  private ArrayList<ControlButton> buttons;
  
  private ControlSlider stickX;
  private ControlSlider stickY;
  
  private boolean[] held;
  private boolean[] prevHeld;
  
  private String knownType;
  
  public Gamepad(ControlDevice deviceIn)
  {
    device = deviceIn;
    name = deviceIn.getName();
    buttons = new ArrayList<ControlButton>();
    
    for (int i = 0; i < device.getNumberOfButtons(); i++)
    {
      buttons.add(device.getButton(i));
    }
    held = new boolean[device.getNumberOfButtons()];
    prevHeld = new boolean[device.getNumberOfButtons()];

    if (name.toLowerCase().indexOf("xbox") != -1)
    {
      knownType = "XBOX";
    }
    else if (name.toLowerCase().indexOf("gamecube") != -1)
    {
      stickX = device.getSlider(3);
      stickX.setTolerance(0.1);
      stickY = device.getSlider(2);
      stickY.setTolerance(0.1);
      knownType = "GAMECUBE";
    }
    else
    {
      if (device.getNumberOfSliders() > 0)
      {
        stickX = device.getSlider(0);
        stickX.setTolerance(0.1);
      }
      if (device.getNumberOfSliders() > 1)
      {
        stickY = device.getSlider(1);
        stickY.setTolerance(0.1);
      }
      knownType = "UNKNOWN";
    }
  }
  
  public boolean update()
  {
    boolean anyPressed = false;
    if (held == null)
      return false;
    for (int b = 0; b < buttons.size(); b++)
    {
      prevHeld[b] = held[b];
      if (buttons.get(b).pressed())
      {
        held[b] = true;
        anyPressed = true;
      }
      else
        held[b] = false;
    }
    return anyPressed;
  }
  
  public boolean buttonHeld(int button)
  {
    return held[button];
  }
  public boolean buttonPressed(int button)
  {
    return held[button] && !prevHeld[button];
  }
  public boolean buttonReleased(int button)
  {
    return !held[button] && prevHeld[button];
  }
  
  public float getStickX()
  {
    if (stickX == null)
      return 0;
    else
    {
      return stickX.getValue();
    }
  }
  public float getStickY()
  {
    if (stickY == null)
      return 0;
    else
      return stickY.getValue();
  }
  
  public void drawSelf(int x, int y)
  {
    for (int b = 0; b < buttons.size(); b++)
    {
      if (held[b])
        fill(255,0,0);
      else
        fill(0,0,0);
      rect(x + b*10,y,8,8);
    }
  }
  
  public String type() { return knownType; }
}

class GamepadArray
{
  private int maxPlayers;
  private int players;
  private Gamepad[] pads;
  private boolean visible;
  
  public GamepadArray(int maxPlayersIn)
  {
    maxPlayers = maxPlayersIn;
    players = 0;
    pads = new Gamepad[maxPlayers];
    visible = false;
  }
  public GamepadArray(ArrayList<Gamepad> padList)
  {
    maxPlayers = padList.size();
    players = padList.size();
    pads = new Gamepad[maxPlayers];
    for (int i = 0; i < maxPlayers; i++)
    {
      pads[i] = padList.get(i);
    }
    visible = false;
  }
  
  public void removePad(int index)
  {
    if (pads[index] != null)
    {
      pads[index] = null;
      players--;
    }
  }
  
  public void addPad(Gamepad newPad)
  {
    if (players < maxPlayers)
    {
      pads[players] = newPad;
      players++;
    }
  }
  
  public void resetPads()
  {
    players = 0;
    pads = new Gamepad[maxPlayers];
  }
  
  public Gamepad addFromList(ArrayList<Gamepad> padList)
  {
    for (int i = 0; i < padList.size(); i++)
    {
      if (padList.get(i).update())
      {
        addPad(padList.get(i));
        Gamepad toReturn = padList.get(i);
        padList.remove(i);
        i--;
        return toReturn;
      }
    }
    return null;
  }
  
  public Gamepad get(int index)
  {
    if (index < players)
    {
      return pads[index];
    }
    else
    {
      return null;
    }
  }
  
  public void updatePads()
  {
    boolean anyPressed;
    for (int i = 0; i < players; i++)
    {
      anyPressed = pads[i].update();
      if (visible)
      {
        pads[i].drawSelf(8,8 + 12*i);
      }
    }
  }
  
  public int currentPlayers() { return players; }
  public int maximumPlayers() { return maxPlayers; }
  
  public void setVisibility(boolean in) { visible = in; }
}