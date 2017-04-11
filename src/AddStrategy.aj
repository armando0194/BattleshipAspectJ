import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.MouseListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import battleship.*;
import static battleship.Constants.DEFAULT_BOARD_COLOR;
import static battleship.Constants.DEFAULT_HIT_COLOR;
import static battleship.Constants.DEFAULT_MISS_COLOR;
import battleship.model.*;

public privileged aspect AddStrategy {
	
	public JButton newPlayButton;
	public Board computerBoard;
    public Board userBoard;
    private Strategy computerStrategy;
	private StrategyDropDown dropDown;
	private JPanel test;
	
	pointcut computerTurn(): call(void Place.hit());
	
	after(): computerTurn(){
		System.out.println("hit");
        String sourceName = thisJoinPointStaticPart.getSourceLocation().getWithinType().getName();
        if(sourceName.equals("battleship.BoardPanel") && computerStrategy != null){
        	computerStrategy.move();
        	test.repaint();
        }
        System.out.println("Call from " +  sourceName);
		//computerStrategy.move();
	}
	
	JPanel around(battleship.BattleshipDialog dialog): target(dialog) && execution(JPanel makeBoardPane()){
		JPanel content = new JPanel(new BorderLayout());
		content.add(makeStatusPanel(dialog), BorderLayout.NORTH);
		content.add(proceed(dialog), BorderLayout.CENTER);
		addNewPlayButton(dialog);
		return content;
	}
	
    public JPanel makeShipsPanel(BattleshipDialog dialog){
    	JPanel shipsPanel = new JPanel();
    	shipsPanel.setLayout( new GridLayout(5, 2) );
    	userBoard = new Board(10);
    	dialog.placeShips(userBoard);
    	
    	Iterable<Ship> ships = userBoard.ships();
    	
    	for (Ship ship : ships) {
    		shipsPanel.add( new JLabel(ship.name()) );
    		shipsPanel.add( new ShipPanel(ship) );
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
    
    public void addNewPlayButton(battleship.BattleshipDialog dialog){
    	JButton practiceButton = (JButton)dialog.playButton;
    	JPanel buttonPane = (JPanel)practiceButton.getParent();
    	dropDown = new StrategyDropDown();
    	practiceButton.setText("Practice"); // change the text of the current play button to practiv
    	
    	//create new play button
    	newPlayButton = new JButton("Play");
    	newPlayButton.addActionListener(this::playButtonClicked2);
    	
    	// add new button and strategy dropdown
    	buttonPane.add(newPlayButton);
    	buttonPane.add(new JLabel("Strategy: "));
    	buttonPane.add(dropDown);
    }
    

	/** To be called when the play button is clicked. If the current play
     * is over, start a new play; otherwise, prompt the user for
     * confirmation and then proceed accordingly. */
	private void playButtonClicked2(ActionEvent event) {
        System.out.println("Play " + dropDown.getStrategySelected());
        String strategySelected = dropDown.getStrategySelected();
        
        if(strategySelected.equals("Smart")){
        	computerStrategy = new SmartStrategy(userBoard.places());
        }else if(strategySelected.equals("Sweep")){
        	computerStrategy = new SweepStrategy(userBoard.places());
        }else if(strategySelected.equals("Random")){
        	computerStrategy = new RandomStrategy(userBoard.places());
        }
        
    }
}
