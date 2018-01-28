import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

final int DEFAULT_GAIN = -10;

class SoundHandler
{
  private Minim minim;
  
  private AudioPlayer[] music;
  private Dict<String,AudioSample> sfx;
  
  public SoundHandler(Object sketch, int musicChannels)
  {
    minim = new Minim(sketch);
    
    music = new AudioPlayer[musicChannels];
    sfx = new Dict<String,AudioSample>();
  }
  
  public void playMusic(String filename, int channel, boolean loop)
  {
    if (music[channel] != null)
      music[channel].pause();
    music[channel] = minim.loadFile(filename);
    
    if (loop)
      music[channel].loop();
    else
      music[channel].play();
    
    music[channel].setGain(DEFAULT_GAIN);
  }
  
  public void rewindMusic(int channel)
  {
    music[channel].rewind();
  }
  
  public void stopMusic(int channel)
  {
    music[channel].pause();
  }
  
  public void musicGain(int channel, int value)
  {
    music[channel].setGain(value);
  }
  
  public String loadSound(String filename)
  {
    sfx.add(filename, minim.loadSample(filename, 512));
    return filename;
  }
  public String loadSound(String filename, String soundName)
  {
    sfx.add(soundName, minim.loadSample(filename, 512));
    return soundName;
  }
  
  public void playSound(String name)
  {
    sfx.get(name).trigger();
  }
}

class Dict<KeyType, ValueType>
{
  private ArrayList<KeyType> keys;
  private ArrayList<ValueType> values;
  
  public Dict()
  {
    keys = new ArrayList<KeyType>();
    values = new ArrayList<ValueType>();
  }
  
  public int add(KeyType keyName, ValueType value)
  {
    keys.add(keyName);
    values.add(value);
    return values.size()-1;
  }
  
  public ValueType get(KeyType keyName)
  {
    for (int i = 0; i < size(); i++)
    {
      if (keys.get(i).equals(keyName))
        return values.get(i);
    }
    return null;
  }
  
  public ValueType getByPosition(int position)
  {
    return values.get(position);
  }
  
  public int size()
  {
    return min(keys.size(),values.size());
  }
}