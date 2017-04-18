package battleship.aspect;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.MouseListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.ShipPanel;
import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;
import battleship.strategy.RandomStrategy;
import battleship.strategy.SmartStrategy;
import battleship.strategy.Strategy;
import battleship.strategy.StrategySelector;
import battleship.strategy.SweepStrategy;
import static battleship.Constants.DEFAULT_BOARD_COLOR;
import static battleship.Constants.DEFAULT_HIT_COLOR;
import static battleship.Constants.DEFAULT_MISS_COLOR;
 

/**
 * @author Manuel Hernandez
 * @author Sebastian Perez
 */
privileged aspect AddStrategy {

	/** Dialog dimensions when the practice mode is enabled */
	private final static Dimension PRACTICE_DIMENSION = new Dimension(355, 470);

	/**  Dialog dimensions when the practice mode is disabled */
	private final static Dimension PLAY_DIMENSION = new Dimension(350, 560);

	/** New play button that starts a new game with a computer  */
	private JButton BattleshipDialog.newPlayButton;

	/** Dropdown with the different computer strategies */
	private StrategySelector BattleshipDialog.dropDown;

	/** User board that will be displayed above the computer board */
	private Board userBoard;

	/** Computer strategy selected by the user */
	private Strategy computerStrategy;

	/** JPanel that contains the user's board and ship status */
	private JPanel statusPanel;

	/** Flag to keep track of the game mode */
	private boolean isPracticeMode = true;
	
	/** Choice selected by the user when he wants to start a new game */
	private boolean newGameDialogChoice = false;

	/**
	 * Pointcut that executes when a new BattleshipDialog is initialized
	 * @param dialog - dialog that will be modified
	 */
	pointcut setPracticeDimension(BattleshipDialog dialog) : 
		execution(BattleshipDialog.new(..)) && 
		target(dialog);

	/**
	 * Pointcut that executes when the placeClicked method in BoardPanel is called
	 * @param place - Place that the user clicked
	 */
	pointcut isGameOver(BoardPanel boardPanel, Place place): 
		execution(void BoardPanel.placeClicked(Place)) &&
		this(boardPanel)&&
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

	/** Pointcut that executes when the showConfirmDialog in JOptionPane is called */
	pointcut saveUserSelection() : 
		call(int JOptionPane.showConfirmDialog(..));
	
	/** Stores the choice made by the user when the new game dialog appeared */
	after() returning(int choice) : saveUserSelection() {
		newGameDialogChoice = (choice == 0) ? true : false;
	}
	
	/**
	 * When a dialog is created, the size is set to a predetermined size
	 * @param dialog
	 */
	after (BattleshipDialog dialog) : setPracticeDimension(dialog){
		dialog.setSize(PRACTICE_DIMENSION);
	}

	/**
	 * Check if the computer won before shooting a place,
	 * and notify winner if any
	 * @param place - Place that the user clicked
	 */
	void around(BoardPanel boardPanel, Place place): isGameOver(boardPanel, place){
		// if the userboard is not game over, then let the user shoot
		if(!userBoard.isGameOver()){
			proceed(boardPanel, place);
			if(boardPanel.board.isGameOver()){
				// if the user won notify him/her
				notifyWinner("You!! :D");
			}
		}
	}


	/**
	 * Resets the computer board, and creates the strategy depending on the user choice
	 * @param dialog - battleship dialog
	 * @param event  - button pressed action
	 * @see BattleshipDialog
	 */
	after(BattleshipDialog dialog, ActionEvent event): resetComputerBoard(dialog, event){
		// if the user chose no in the new game dialog, stop excution
		if(!newGameDialogChoice)
			return;
		
		resetUserBoard(dialog);

		if(event.getActionCommand().equals("Play")){
			// if the, play button create a new strategy depending on the selected strategy
			String strategySelected = dialog.getStrategySelected();
			if(strategySelected.equals("Random"))
				computerStrategy = new RandomStrategy(userBoard.places());
			else if(strategySelected.equals("Sweep"))
				computerStrategy = new SweepStrategy(userBoard.places());
			else if(strategySelected.equals("Smart"))
				computerStrategy = new SmartStrategy(userBoard.places());	

			isPracticeMode = false;
			statusPanel.setVisible(true);
			dialog.setSize(PLAY_DIMENSION);
		}
		else{
			// Otherwise the practice button was clicked, so set flag true, resize and set visible false
			isPracticeMode = true;
			statusPanel.setVisible(false);
			dialog.setSize(PRACTICE_DIMENSION);
		}
	}

	/**
	 * Resets the computer board and places the ship in the board
	 * @param dialog - battleship dialog
	 */
	private void resetUserBoard(BattleshipDialog dialog) {
		Board temp = dialog.board;
		userBoard.reset();
		dialog.board = userBoard;
		dialog.placeShips();
		dialog.board = temp;
	}

	/** Generates a computer move when the user is not practicing */
	after(): computerTurn(){
		// if practice mode is not enabled, then generate computer move
		if(!isPracticeMode){
			computerStrategy.move();
			statusPanel.repaint();
			if(userBoard.isGameOver()){
				//notify  if the computer won
				notifyWinner("Computer :'(");
			}
		} 
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
	private JPanel makeShipsPanel(BattleshipDialog dialog){
		JPanel shipsPanel = new JPanel();
		shipsPanel.setLayout( new GridLayout(5, 2) );
		userBoard = new Board(10);
		resetUserBoard(dialog);

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
	private JPanel makeStatusPanel(BattleshipDialog dialog){
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
	private void removeMouseListener(JPanel panel){
		MouseListener[] mouseListeners = panel.getMouseListeners();

		for (MouseListener mouseListener : mouseListeners)
			panel.removeMouseListener(mouseListener);
	}

	/**
	 * Gets the strategy selected from a dropdown
	 * @return String - strategy selected
	 */
	private String BattleshipDialog.getStrategySelected(){
		return dropDown.getStrategySelected();
	}	

	/**
	 * Creates a new play button and a strategy selector, and it adds it to JPanel
	 */
	private void BattleshipDialog.addNewPlayButton(){
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

	/**
	 * Creates a pop up notifying the user of the winner
	 * @param winner - winner name
	 */
	private void notifyWinner(String winner){
		JPanel winnerMessage = new JPanel();
		winnerMessage.add(new JLabel("Winner: " + winner));
		JOptionPane.showMessageDialog(null,winnerMessage,"Winner",JOptionPane.INFORMATION_MESSAGE);
	}
}
