package battleship;

import javax.swing.JPanel;
import java.awt.Color;
import java.awt.Graphics;
import battleship.model.Place;
import battleship.model.Ship;

/**
* A special panel to display a ship modeled by the
* {@link Ship} class. A ship status is displayed as a 2D grid of 
* square cells. 
* @see Ship
*/
@SuppressWarnings("serial")
public class ShipPanel extends JPanel {

	 /**
	  * Height of the blank space above the ship panel in pixel.
	  */
	 protected final int topMargin = 0;
	
	 /**
	  * Width of the blank space left of the ship panel in pixel.
	  */
	 protected final int leftMargin = 0;
	
	 /**
	  * Number of pixels between horizontal/vertical lines of the ship panel to
	  * present places..
	  */
	 protected final int placeSize = 10;
	 
	 /**
	  * Number of columns of the ship
	  */
	 protected int shipSize;
	
	 /** Background color of the ship.  */
	 protected final Color shipColor = new Color(51, 153, 255);
	 
	 /** Color for drawing ship places that are hit. */
	 protected final Color hitShipColor = Color.ORANGE;
	
	 /** Color for drawing ship places that are sunk */
	 protected final Color sunkShipColor = Color.RED;
	
	 /** Foreground color for drawing 2-d grid lines for board and places. */
	 protected final Color lineColor = Color.BLACK;
	
	 /** Battleship board to be displayed by this panel. */
	 //protected final Board board;
	 
	 protected final Ship ship;
	
	 /** Create a new panel to display the given battleship board. */ 
	 public ShipPanel(Ship ship) {
		 this.ship = ship;
		 this.shipSize = ship.size();
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
	     g.setColor(shipColor);
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
	
	 /** Draws the ship places yellow if they are hit, and red if the ship is sunk. */
	 private void drawPlaces(Graphics g) {
	     final Color oldColor = g.getColor();
	     int x = leftMargin + 1;
		 int y = topMargin + 1;
		 
	     for (Place p: ship.places()) {
	 		if (p.isHit()) {
	 		    g.setColor(ship.isSunk() ? sunkShipColor : hitShipColor);
	 		    g.fillRect(x, y, (placeSize - 1), (placeSize - 1));
	 		    x += placeSize;
	 		}
	     }
	     g.setColor(oldColor);
	     
	 }
}

