import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import battleship.BattleshipDialog;
import battleship.model.Board;

public class PlayButtonListener implements ActionListener{
	BattleshipDialog dialog;
	StrategyDropDown dropDown;
	Strategy computerStrategy;
	Board userBoard;
	
	public PlayButtonListener(BattleshipDialog dialog, StrategyDropDown dropDown, Strategy computerStrategy, Board userBoard) {
		this.dialog = dialog;
		this.dropDown = dropDown;
		this.computerStrategy = computerStrategy;
		this.userBoard = userBoard;
	}

	@Override
	public void actionPerformed(ActionEvent event) {
		System.out.println("Play " + dropDown.getStrategySelected());
		String strategySelected = dropDown.getStrategySelected();
		
		if(strategySelected.equals("Smart")){
			
		}else if(strategySelected.equals("Sweep")){
			System.out.println("fuck this  shit");
			computerStrategy = new SweepStrategy(userBoard.places());
		}else if(strategySelected.equals("Random")){
			System.out.println("que chingados");
			computerStrategy = new RandomStrategy(userBoard.places());
		}
		
		
		
	}

}
