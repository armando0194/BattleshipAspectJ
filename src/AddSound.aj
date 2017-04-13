import java.io.File;
import java.io.IOException;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import battleship.model.Place;
import battleship.model.Board;

public aspect AddSound {
	/** Directory where audio files are stored. */
    private static final String SOUND_DIR = "src\\sounds\\";
	
    /** Clip that will be played whenever a place is hit */
    private Clip hitSound = null;
    
    /** Clip that will be played whenever a ship is hit */
	private Clip sunkSound = null;
	
	/** Flag that helps determine if the clips are loaded before playing it*/
    private boolean soundsLoaded = false;
    
	pointcut playSound(Place place) : 
		execution(void Board.hit(Place)) 
		&& args(place);
	
	/**
	 * Runs after the hit method in Board and plays a clip
	 * @param place
	 */
	after(Place place): playSound(place){
		
		/** if the sounds are not loaded, load the hit and sunk clips*/
		if(!soundsLoaded){
			hitSound = loadAudio("Missile.wav");
			sunkSound = loadAudio("bomb_x.wav");
		}
		
		if(place.hasShip() && place.ship().isSunk()){
		/** if the ship was sunk, play sunk clip */
			sunkSound.setFramePosition(0);
			sunkSound.start();
		}
		else if(place.isHit()){
		/** if the place was hit, play hit clip */
			hitSound.setFramePosition(0);
			hitSound.start();
		}
	}
	
    /**
     * Loads a clip from the system
     * @param filename - wav filename
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
