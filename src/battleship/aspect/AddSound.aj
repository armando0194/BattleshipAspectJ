package battleship.aspect;
import java.io.File;
import java.io.IOException;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import battleship.model.Place;
import battleship.model.Board;
import battleship.model.Ship;

 /**
 * @author Manuel Hernandez
 * @author Sebastian Perez
 */
public aspect AddSound {
	/** Directory where audio files are stored. */
    private static final String SOUND_DIR = "src\\sounds\\";
	
    /** Clip that will be played whenever a place is hit */
    private final Clip hitSound = null;
    
    /** Clip that will be played whenever a ship is hit */
	private final Clip sunkSound = null;
	
	/**
     * Pointcut that is executed, when the notifyHit method in Board is executed.
     */
	pointcut playHitSound() : 
		execution(void Board.notifyHit(Place, int));
	
	/**
     * Pointcut that is executed, when the notifyShipSunk method in Board is executed.
     */
	pointcut playSunkSound() : 
		execution(void Board.notifyShipSunk(Ship));
	
	/**
	 * Plays hit sound
	 */
	after() : playHitSound(){
		playSound(hitSound, "Hit.wav");	
	}
	
	/**
	 * Plays sunk sound
	 */
	after() : playSunkSound(){
		playSound(sunkSound, "Sunk.wav");	
	}
	
	/**
	 * Loads a clip if it is null and plays it
	 * @param sound - sound clip
	 * @param filename - name of the wav file
	 */
	private void playSound(Clip sound, String filename){
		if(sound == null){
			sound = loadAudio(filename);
		}
		sound.stop();
		sound.setFramePosition(0);
		sound.start();
	}
	
    /**
     * Loads a clip from the system
     * @param filename - audio filename
     * @return - An open clip ready to play
     */
    public Clip loadAudio(String filename) {
      try {
    	  AudioInputStream audioIn = AudioSystem.getAudioInputStream(new File(SOUND_DIR + filename));
          Clip clip = AudioSystem.getClip();
          clip.open(audioIn);
          return clip;
      } catch (UnsupportedAudioFileException 
            | IOException | LineUnavailableException e) {
          e.printStackTrace();
          return null;
      }
    }
}
