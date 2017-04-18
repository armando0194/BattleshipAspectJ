package battleship.aspect;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import battleship.model.Place;
import battleship.BoardPanel;

 /**
 * @author Manuel Hernandez
 * @author Sebastian Perez
 */
public aspect AddSound {
	/** Directory where audio files are stored. */
    private static final String SOUND_DIR = "/sounds/";
	
    /** Clip that will be played whenever a place is hit */
    private final Clip hitSound = null;
    
    /** Clip that will be played whenever a ship is hit */
	private final Clip sunkSound = null;
	
	/** Pointcut that is executed, when the hit method in Place is called. */
	pointcut playSound(Place place): 
		call(void Place.hit()) &&
		target(place) &&
		this(BoardPanel);
	
	/**
	 * Plays a sound when the user makes a move
	 * @param place - placed clicked by the user
	 */
	after(Place place) : playSound(place){	
		if(place.hasShip() && place.ship().isSunk()){
		// if a ship was sunk, play the sunk sound
			playSound(sunkSound, "Sunk.wav");
		}
		else{
		//otherwise, place the hit sound
			playSound(hitSound, "Hit.wav");	
		}
	}
	
	/**
	 * Loads a clip if it is null and plays it
	 * @param sound - sound clip
	 * @param filename - name of the wav file
	 * @throws URISyntaxException 
	 */
	private void playSound(Clip sound, String filename) {
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
     * @throws URISyntaxException 
     */
    public Clip loadAudio(String filename){
      try {
    	  URL path = this.getClass().getResource(SOUND_DIR + filename);
    	  AudioInputStream audioIn = AudioSystem.getAudioInputStream(path);
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
