import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.MouseListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import static battleship.Constants.DEFAULT_BOARD_COLOR;
import static battleship.Constants.DEFAULT_HIT_COLOR;
import static battleship.Constants.DEFAULT_MISS_COLOR;
import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.ShipPanel;
import battleship.model.Board;
import battleship.model.Ship;
import battleship.model.Place;
import battleship.strategy.Strategy;
import battleship.strategy.StrategySelector;
import battleship.strategy.RandomStrategy;
import battleship.strategy.SweepStrategy;
import battleship.strategy.SmartStrategy;

 privileged aspect AddStrategy {
	
	 /** Dialog dimensions when the practice mode is enabled */
	private final static Dimension PRACTICE_DIMENSION = new Dimension(355, 470);
		
	/**  Dialog dimensions when the practice mode is disabled */
	private final static Dimension PLAY_DIMENSION = new Dimension(350, 560);
		
	/** New play button that starts a new game with a computer  */
	public JButton BattleshipDialog.newPlayButton;
	
	/** Dropdown with the different computer strategies */
	public StrategySelector BattleshipDialog.dropDown;
    
	/** User board that will be displayed above the computer board */
	public Board userBoard;
    
	/** Computer strategy selected by the user */
	public Strategy computerStrategy;
	
	/** JPanel that contains the user's board and ship status */
	public JPanel statusPanel;
	
	/** Flag to keep track of the game mode */
	public boolean isPracticeMode = true;
	
	/**
	 * Poincut that executes when a new BattleshipDialog is initialized
	 * @param dialog - dialog that will be modified
	 */
	pointcut setPracticeDimension(BattleshipDialog dialog) : 
		execution(BattleshipDialog.new(..)) && 
		target(dialog) ;
		
	/**
	 * Pointcut that executes when the placeClicked method in BoardPanel is called
	 * @param place - Place that the user clicked
	 */
	pointcut isGameOver(Place place): 
		call(void BoardPanel.placeClicked(Place)) &&
		args(place);
	
	/** Pointcut that executes when the hit method in Place is called */
	pointcut computerTurn(): 
		call(void Place.hit()) &&
		this(BoardPanel);
	
	/**
	 * Pointcut that executes when the playButtonClicked method in BattleshipDialog is executed
	 * @param dialog - current target
	 * @param event - button pressed event
	 */
	pointcut resetComputerBoard(BattleshipDialog dialog, ActionEvent event) : 
		execution(void BattleshipDialog.playButtonClicked(ActionEvent)) 
		&& target(dialog)
		&& args(event);
	
	/**
	 * Pointcut that executes when the makeBoardPane in BattleshipDialog is executed
	 * @param dialog - current target
	 */
	pointcut makeStatusPane(battleship.BattleshipDialog dialog) : 
		execution(JPanel makeBoardPane()) && 
		target(dialog); 
	
	/**
	 * When a dialog is created, the size is set to a predetermined size
	 * @param dialog
	 */
	after (BattleshipDialog dialog) : setPracticeDimension(dialog){
		dialog.setSize(PRACTICE_DIMENSION);
	}
	
	/**
	 * Check if the computer won before shooting a place
	 * @param place - Place that the user clicked
	 */
	void around(Place place): isGameOver(place){
		// if the userboard is not game over, then let the user shoot
		if(!userBoard.isGameOver())
			proceed(place);
	}
	
	/**
	 * Resets the computer board, and creates the strategy depending on the user choice
	 * @param dialog - battleship dialog
	 * @param event  - button pressed action
	 * @see BattleshipDialog
	 */
	after(BattleshipDialog dialog, ActionEvent event): resetComputerBoard(dialog, event){
		userBoard.reset(); 
		dialog.placeShips(userBoard);
		
		if(event.getActionCommand().equals("Play")){
		// if the, play button create a new strategy depending on the selected strategy
			isPracticeMode = false;
			String strategySelected = dialog.getStrategySelected();
			if(strategySelected.equals("Random"))
				computerStrategy = new RandomStrategy(userBoard.places());
			else if(strategySelected.equals("Sweep"))
				computerStrategy = new SweepStrategy(userBoard.places());
			else if(strategySelected.equals("Smart"))
				computerStrategy = new SmartStrategy(userBoard.places());	
			statusPanel.setVisible(true);
			dialog.setSize(PLAY_DIMENSION);
		}
		else{
		// Otherwise the practice button was clicked, so set flag true
			isPracticeMode = true;
			statusPanel.setVisible(false);
			dialog.setSize(PRACTICE_DIMENSION);
		}
	}
	
	/** Generates a computer move when the user is not practicing */
	after(): computerTurn(){
		// if practice mode is not enabled, then generate computer move
		if(!isPracticeMode)
			computerStrategy.move();
        statusPanel.repaint();
	}
	
	/**
	 * Creates a status panel above the computer board in which the status of the 
	 * user's ship and its board its displayed.
	 * @param dialog 
	 * @return - JPanel that contains the new features
	 */
	JPanel around(battleship.BattleshipDialog dialog): makeStatusPane(dialog){
		JPanel content = new JPanel(new BorderLayout());
		content.add(makeStatusPanel(dialog), BorderLayout.NORTH);
		content.add(proceed(dialog), BorderLayout.CENTER);
		dialog.addNewPlayButton();
		return content;
	}
	
	/**
	 * Creates a JPanel that contains the status of the ship. It
	 * shows if a ship has been hit or sunk.
	 * @param dialog
	 * @return - A JPanel that contains Ship Panels inside
	 */
    public JPanel makeShipsPanel(BattleshipDialog dialog){
    	JPanel shipsPanel = new JPanel();
    	shipsPanel.setLayout( new GridLayout(5, 2) );
    	userBoard = new Board(10);
    	dialog.placeShips(userBoard);
    	
    	Iterable<Ship> ships = userBoard.ships();
    	
    	// traverse the ships and creates a ShipPanel for each one
    	for (Ship ship : ships) {
    		ShipPanel shipPanel = new ShipPanel(ship);
    		shipsPanel.add(new JLabel(ship.name()));
    		shipsPanel.add(shipPanel);
		}
    	
    	return shipsPanel;
    }
    
    /**
     * Creates status panel that adds a user board and ships status
     * @param dialog
     * @return - JPanel that contains the status of the user
     */
    public JPanel makeStatusPanel(BattleshipDialog dialog){
    	JPanel statusPanel = new JPanel( new GridLayout(1, 2) );
    	BoardPanel userBoardPanel;
    	
    	statusPanel.setBorder(new EmptyBorder(10,30,10,10));
    	statusPanel.setMaximumSize(new Dimension(335, 300));
    	statusPanel.add(makeShipsPanel(dialog));
    	userBoardPanel = new BoardPanel(userBoard, 0, 0, 8, DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR);
    	removeMouseListener(userBoardPanel);
    	
    	userBoardPanel.getMouseListeners();
    	statusPanel.add(userBoardPanel);
    	this.statusPanel = statusPanel;
    	statusPanel.setVisible(false);
    	return statusPanel;
    }

    /**
     * Removes MouseListeners from a JPanel
     * @param panel - JPanel without MouseListener
     */
    public void removeMouseListener(JPanel panel){
    	MouseListener[] mouseListeners = panel.getMouseListeners();
    	
    	for (MouseListener mouseListener : mouseListeners)
    		panel.removeMouseListener(mouseListener);
    }
    
    /**
     * Gets the strategy selected from a dropdown
     * @return String - strategy selected
     */
    public String BattleshipDialog.getStrategySelected(){
    	return dropDown.getStrategySelected();
    }	
    
    /**
     * Places ships in a board
     * @param board - board where the ships will be placed
     */
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
    
    /**
     * Creates a new play button and a strategy selector, and it adds it to JPanel
     */
    public void BattleshipDialog.addNewPlayButton(){
    	JButton practiceButton = (JButton)playButton;
    	JPanel buttonPane = (JPanel)playButton.getParent();
    	dropDown = new StrategySelector();
    	practiceButton.setText("Practice"); // change the text of the current play button to practiv
    	
    	//create new play button
    	newPlayButton = new JButton("Play");
    	newPlayButton.addActionListener(this::playButtonClicked);
    	
    	// add new button and strategy dropdown
    	buttonPane.add(newPlayButton);
    	buttonPane.add(new JLabel("Strategy: "));
    	buttonPane.add(dropDown);
    }
}
