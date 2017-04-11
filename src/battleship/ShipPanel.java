package battleship;

import javax.swing.JPanel;
import java.awt.Color;
import java.awt.Graphics;

import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;

import static battleship.Constants.*;

/**
* A special panel to display a battleship board modeled by the
* {@link Board} class. A battle board is displayed as a 2D grid of 
* square cells. 
* 
* <pre>
*  +--------------
*  |    TM         
*  |   +---+---+-- 
*  |LM |PS |   |   ...
*  |   +---+---+--
*  |       ...
* </pre>
*
* @see Board
* @author Yoonsik Cheon
* @version $Revision: 1.1 $
*/
@SuppressWarnings("serial")
public class ShipPanel extends JPanel {

 /**
	  * Height of the blank space above the board panel in pixel. It is 10 by
	  * default.
	  */
	 protected final int topMargin;
	
	 /**
	  * Width of the blank space left of the board panel in pixel. It is 10 by
	  * default.
	  */
	 protected final int leftMargin;
	
	 /**
	  * Number of pixels between horizontal/vertical lines of the board panel to
	  * present places. By default, it is 30.
	  */
	 protected int placeSize;
	
	 /**
	  * Number of rows/columns of the battleship board. The board will have
	  * <code>boardSize x boardSize</code> places.
	  */
	 protected int boardSize;
	 
	 protected int shipSize;
	
	 /** Background color of the board. It's blue by default. */
	 protected Color boardColor;
	
	 protected Color shipColor;
	 /** Color for drawing places that are hit and have a ship. */
	 protected final Color hitColor;
	
	 /** Color for drawing places that are hit but have no ship. */
	 protected final Color missColor;
	
	 /** Foreground color for drawing 2-d grid lines for board and places. */
	 protected final Color lineColor = DEFAULT_LINE_COLOR;
	
	 /** Battleship board to be displayed by this panel. */
	 //protected final Board board;
	 
	 protected final Ship ship;
	
	 /** Create a new panel to display the given battleship board. */ 
	 public ShipPanel(Ship ship) {
	 	this(ship, 
	 	    0, 0, 10,
	 	    DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR);
	 }
	 
	 /** Create a new panel to display the given battleship board according
	  * to the given display specifications. */
	 public ShipPanel(Ship ship,
	         		int topMargin, int leftMargin, int placeSize,
	         		Color boardColor, Color hitColor, Color missColor) {
	 	this.ship = ship;
	 	this.shipSize = ship.size();
	 	this.topMargin = topMargin;
	 	this.leftMargin = leftMargin;
	 	this.placeSize = placeSize;
	 	this.boardColor = boardColor;
	 	this.hitColor = hitColor;
	 	this.missColor = missColor;
	 }
	 
	 /** Overridden here to draw the current state of the battleship board. 
	  * This method will draw a 2-d grid representation of the board. */
	 @Override
	 public void paint(Graphics g) {
	     super.paint(g); // clear the background
	     drawGrid(g);
	     drawPlaces(g);
	 }
	
	 /** Draw a 2D grid representing a battleship board of 
	  * <code>boardSize x boardSize</code> places. Both horizontal and
	  * vertical lines are spaced <code>placeSize</code> pixels. */
	 private void drawGrid(Graphics g) {
	     Color oldColor = g.getColor(); 
	
	     // fill the background of the frame.
	     final int frameSize = shipSize * placeSize;
	     System.out.println(frameSize);
	     g.setColor(boardColor);
	     g.fillRect(leftMargin, topMargin, frameSize, placeSize);
	     
	     // draw vertical and horizontal lines
	     g.setColor(lineColor);
	     int x = leftMargin;
	     int y = topMargin;
	   
	     for (int i = 0; i <= shipSize; i++) {
	    	 g.drawLine(x, topMargin, x, topMargin + placeSize);
	         x += placeSize;
	     }
	     g.drawLine(leftMargin, y, leftMargin + frameSize, y);
	     g.drawLine(leftMargin, y + placeSize, leftMargin + frameSize, y + placeSize);
	
	     g.setColor(oldColor);
	 }
	
	 /** Draw the places that are hit. */
	 private void drawPlaces(Graphics g) {
	     final Color oldColor = g.getColor();
	     for (Place p: ship.places()) {
	 		if (p.isHit()) {
	 		    int x = leftMargin + (p.getX() - 1) * placeSize;
	 		    int y = topMargin + (p.getY() - 1) * placeSize;
	 		    g.setColor(ship.isSunk() ? missColor : hitColor);
	 		    g.fillRect(x + 1, y + 1, placeSize - 1, placeSize - 1);
	 		}
	     }
	     g.setColor(oldColor);
	     
	 }
}

