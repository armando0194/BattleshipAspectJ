import java.io.File;
import java.io.IOException;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import battleship.model.Place;
import battleship.model.Ship;

public aspect AddSound {
	/** Directory where audio files are stored. */
    private static final String SOUND_DIR = "C:\\Users\\Sebastián\\Downloads\\";
	
	pointcut playHitSound() : execution(void notifyHit(Place, int));
	pointcut playSunkSound() : execution(void notifyShipSunk(Ship));
	
	after(): playHitSound(){
		System.out.println("buenas noches");
		playAudio("bomb_x.wav");
	}
	after(): playSunkSound(){
		System.out.println("buenos dias");
		playAudio("missile.wav");
	}

    /** Play the given audio file. Inefficient because a file will be 
     * (re)loaded each time it is played. */
    public void playAudio(String filename) {
      try {
    	  AudioInputStream audioIn = AudioSystem.getAudioInputStream(new File(SOUND_DIR + filename));
          Clip clip = AudioSystem.getClip();
          clip.open(audioIn);
          clip.start();
      } catch (UnsupportedAudioFileException 
            | IOException | LineUnavailableException e) {
          e.printStackTrace();
      }
    }
}
