package battleship.aspect;

import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;
import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.KeyStroke;

import com.sun.glass.events.KeyEvent;

import battleship.BoardPanel;
import battleship.model.Place;

/**
 * @author Manuel Hernandez
 * @author Sebastian Perez
 */
public privileged aspect AddCheatKey {
	
	/** Path of the image that shows the locations of ships hiding in the battleship board   */
	private static final String IMAGE_DIR = "src\\sprite\\block.png";
	
	/** Image that shows the locations of ships hiding in the battleship board */
	private static BufferedImage image = null;
	
	/** Flag that keeps track of the cheat mode. It is injected in the BoardPanel */
	public boolean BoardPanel.isCheatMode = false;
	
	/**
	 * Intercept all the Board panel constructors 
	 * @param panel - computer board panel
	 */
	pointcut addKeyListener(BoardPanel panel) : 
		initialization(BoardPanel.new(..)) && 
		target(panel);
	
	/**
	 * when the drawPlaces is called
	 * @param board - current target BoardPanel
	 * @param g - 2-D Graphics where the hidden ships will be drawn
	 */
	pointcut drawHiddenShips(BoardPanel board, Graphics g ) : 
		call(void BoardPanel.drawPlaces(Graphics)) 
		&& target(board)
		&& args(g);
	
	/**
	 * After a BoardPanel is initialized add a action and input map, so the panel
	 * detects when a user hits f5
	 * @param panel - computer Board Panel
	 * @see BoardPanel
	 */
	after(BoardPanel panel) : addKeyListener(panel){
    	ActionMap actionMap = panel.getActionMap();
        int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
        InputMap inputMap = panel.getInputMap(condition);
        String cheat = "Cheat";
        inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), cheat);
        actionMap.put(cheat, new KeyAction(panel, cheat));
	}
		
	/**
	 * Draws Hidden ships if the cheat mode is activated
	 * @param board - current target BoardPanel
	 * @param g - 2-D Graphics where the hidden ships will be drawn
	 */
	after(BoardPanel board, Graphics g) : drawHiddenShips(board, g){
		if(board.getIsCheatMode()){
			board.drawShips(g);
		}	
	}
	
	
	/**
	 * Loads an image to display hidden ships, and draws it in the board.
	 * It is injected in the BoardPanel
	 * @param g - JPanel graphic in which the ships will be drawn. 
	 */
	private void BoardPanel.drawShips(Graphics g){
		/** Load image if it is null */
		if(image == null){
			try{
				image = ImageIO.read(new File(IMAGE_DIR));
			} catch(Exception ex){
				ex.printStackTrace();
				return; 
			}
		}
		 
		/** Traverse places and if there is a ship, and it is now hit, an image is drawn */
		for (Place p: board.places()) {
			if ( !p.isHit() && p.hasShip() ) {
			    int xPos = leftMargin + (p.getX() - 1) * placeSize;
			    int yPos = topMargin + (p.getY() - 1) * placeSize;
			    g.drawImage(image, xPos+1, yPos+1, this);
			}
		}
	}
	
	/**
	 * Setter for isCheatMode. It is injected in the BoardPanel
	 * @param isCheatMode - new isCheatMode value
	 */
	public void BoardPanel.setIsCheatMode(boolean isCheatMode){
		this.isCheatMode = isCheatMode;
	}
	
	/**
	 * Getter for isCheatMode. It is injected in the BoardPanel
	 * @return - the current value of isCheatMode
	 */
	public boolean BoardPanel.getIsCheatMode(){
		return this.isCheatMode;
	}
	
	/** sClass that manages the user input when it click the f5 key */
	@SuppressWarnings("serial")
	public static class KeyAction extends AbstractAction {
		private final BoardPanel boardPanel;
		public KeyAction(BoardPanel boardPanel, String command) {
			this.boardPanel = boardPanel;
			putValue(ACTION_COMMAND_KEY, command);
		}
		   
		/** When the user press f5, the cheat mode is toggled, and the board is repainted */
		@Override
		public void actionPerformed(ActionEvent event) {
			boardPanel.setIsCheatMode( !boardPanel.getIsCheatMode() );
			boardPanel.repaint();
		} 
	}
}




