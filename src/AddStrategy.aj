import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.MouseListener;
import java.util.List;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import java.awt.event.ActionEvent;

import battleship.*;
import static battleship.Constants.DEFAULT_BOARD_COLOR;
import static battleship.Constants.DEFAULT_HIT_COLOR;
import static battleship.Constants.DEFAULT_MISS_COLOR;
import battleship.model.*;

 privileged aspect AddStrategy {
	
	public JButton BattleshipDialog.newPlayButton;
	public Board computerBoard;
    public Board userBoard;
    public Strategy computerStrategy;
	public StrategyDropDown BattleshipDialog.dropDown;
	public List<ShipPanel> shipStatusPanels;
	public JPanel test;
	
	/**  */
	pointcut computerTurn(): 
		call(void Place.hit());
	
	/**  */
	pointcut resetComputerBoard(BattleshipDialog dialog, ActionEvent event) : 
		execution(void BattleshipDialog.playButtonClicked(ActionEvent)) 
		&& target(dialog)
		&& args(event);
	
	after(BattleshipDialog dialog, ActionEvent event): resetComputerBoard(dialog, event){
		String strategySelected = dialog.getStrategySelected();
		System.out.println("new game: " + strategySelected);
	}
	
	public String BattleshipDialog.getStrategySelected(){
    	return dropDown.getStrategySelected();
    }
	
	after(): computerTurn(){
		System.out.println("hit");
        String sourceName = thisJoinPointStaticPart.getSourceLocation().getWithinType().getName();
        if(sourceName.equals("battleship.BoardPanel") && computerStrategy != null){
        	computerStrategy.move();
        	test.repaint();
        }
        System.out.println("Call from " +  sourceName);
	}
	
	JPanel around(battleship.BattleshipDialog dialog): 
		target(dialog) 
		&& execution(JPanel makeBoardPane()){
		JPanel content = new JPanel(new BorderLayout());
		content.add(makeStatusPanel(dialog), BorderLayout.NORTH);
		content.add(proceed(dialog), BorderLayout.CENTER);
		dialog.addNewPlayButton();
		return content;
	}
	
    public JPanel makeShipsPanel(BattleshipDialog dialog){
    	JPanel shipsPanel = new JPanel();
    	shipsPanel.setLayout( new GridLayout(5, 2) );
    	userBoard = new Board(10);
    	dialog.placeShips(userBoard);
    	
    	Iterable<Ship> ships = userBoard.ships();
    	
    	for (Ship ship : ships) {
    		ShipPanel shipPanel = new ShipPanel(ship);
    		shipsPanel.add( new JLabel(ship.name()) );
    		shipsPanel.add( shipPanel );
    		//shipStatusPanels.add(shipPanel);
		}
    	
    	return shipsPanel;
    }
    
    public JPanel makeStatusPanel(BattleshipDialog dialog){
    	JPanel statusPanel = new JPanel( new GridLayout(1, 2) );
    	BoardPanel userBoardPanel;
    	
    	statusPanel.setBorder(new EmptyBorder(10,30,10,10));
    	statusPanel.setMaximumSize(new Dimension(335, 300));
    	statusPanel.add(makeShipsPanel(dialog));
    	userBoardPanel = new BoardPanel(userBoard, 0, 0, 8, DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR);
    	MouseListener[] mouseListeners = userBoardPanel.getMouseListeners();
    	
    	for (MouseListener mouseListener : mouseListeners) {
			userBoardPanel.removeMouseListener(mouseListener);
		}
    	
    	userBoardPanel.getMouseListeners();
    	statusPanel.add( userBoardPanel );
    	test = statusPanel;
    	return statusPanel;
    }

    public void BattleshipDialog.placeShips(Board board){
    	int size = board.size();
        for (Ship ship : board.ships()) {
            int i = 0;
            int j = 0;
            boolean dir = false;
            do {
                i = random.nextInt(size) + 1;
                j = random.nextInt(size) + 1;
                dir = random.nextBoolean();
            } while (!board.placeShip(ship, i, j, dir));
        }
    }
    
    public void BattleshipDialog.addNewPlayButton(){
    	JButton practiceButton = (JButton)playButton;
    	JPanel buttonPane = (JPanel)playButton.getParent();
    	dropDown = new StrategyDropDown();
    	practiceButton.setText("Practice"); // change the text of the current play button to practiv
    	
    	//create new play button
    	newPlayButton = new JButton("Play");
    	//newPlayButton.addActionListener(new PlayButtonListener(this, dialog, dropDown, computerStrategy, userBoard));
    	newPlayButton.addActionListener(this::playButtonClicked);
    	// add new button and strategy dropdown
    	buttonPane.add(newPlayButton);
    	buttonPane.add(new JLabel("Strategy: "));
    	buttonPane.add(dropDown);
    }
    

	/** To be called when the play button is clicked. If the current play
     * is over, start a new play; otherwise, prompt the user for
     * confirmation and then proceed accordingly. */
//	private void playButtonClicked2(ActionEvent event) {
//        System.out.println("Play " + dropDown.getStrategySelected());
//        String strategySelected = dropDown.getStrategySelected();
//        
//        if(strategySelected.equals("Smart")){
//        	computerStrategy = new SmartStrategy(userBoard.places());
//        }else if(strategySelected.equals("Sweep")){
//        	computerStrategy = new SweepStrategy(userBoard.places());
//        }else if(strategySelected.equals("Random")){
//        	computerStrategy = new RandomStrategy(userBoard.places());
//        }
//        
//    }
}
