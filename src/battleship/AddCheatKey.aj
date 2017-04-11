package battleship;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;
import javax.swing.AbstractAction;

import battleship.model.Place;


public privileged aspect AddCheatKey {
	private static BufferedImage image = null;
	public boolean BoardPanel.isCheatMode = false;
	
	private void BoardPanel.drawShips(Graphics g){
		if(image == null){
			try{
				image = ImageIO.read(new File("C:\\Users\\arman\\Documents\\JavaProjects\\BattleshipAspectJ\\src\\sprite\\block.png"));
			} catch(Exception ex){
				System.out.println( "Exception: " + ex.getStackTrace() );
			}
		}

		for (Place p: board.places()) {
			if ( !p.isHit() && p.hasShip() ) {
			    int x = leftMargin + (p.getX() - 1) * placeSize;
			    int y = topMargin + (p.getY() - 1) * placeSize;
			    g.drawImage(image, x+1, y+1, this);
		
			}
		}
	}
	
	public void BoardPanel.setIsCheatMode(boolean isCheatMode){
		this.isCheatMode = isCheatMode;
	}
	
	public boolean BoardPanel.getIsCheatMode(){
		return this.isCheatMode;
	}
	
	@SuppressWarnings("serial")
	public static class KeyAction extends AbstractAction {
       private final BoardPanel boardPanel;
       
       public KeyAction(BoardPanel boardPanel, String command) {
           this.boardPanel = boardPanel;
           putValue(ACTION_COMMAND_KEY, command);
       }
       
       /** Called when a cheat is requested. */
       @Override
       public void actionPerformed(ActionEvent event) {
           // to be executed when the cheat (F5) key is pressed.
    	   System.out.println("F5 pressed " + !boardPanel.getIsCheatMode() );
    	   boardPanel.setIsCheatMode( !boardPanel.getIsCheatMode() );
    	   boardPanel.repaint();
       } 
    }
	
	pointcut test(BoardPanel board, Graphics g ) : 
		call(void BoardPanel.drawPlaces(Graphics)) 
		&& target(board)
		&& args(g);
		
	after(BoardPanel board, Graphics g):  test(board, g){
		if( board.getIsCheatMode() ){
			board.drawShips(g);
		}
		
	}
	
}




