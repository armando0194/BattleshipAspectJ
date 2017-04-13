import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JOptionPane;
import javax.swing.JPanel;

import battleship.BattleshipDialog;
import battleship.model.Board;

public class PlayButtonListener implements ActionListener{
	BattleshipDialog dialog;
	AddStrategy addStrategy;
	//no pude]
	public PlayButtonListener(AddStrategy addStrategy, BattleshipDialog dialog, StrategyDropDown dropDown, Strategy computerStrategy, Board userBoard) {
		this.dialog = dialog;
		this.addStrategy = addStrategy;
	}

	@Override
	public void actionPerformed(ActionEvent event) {
//		String strategySelected = addStrategy.dropDown.getStrategySelected();
//		
//		if(strategySelected.equals("Smart")){
//			addStrategy.computerStrategy = new SmartStrategy(addStrategy.userBoard.places());
//		}else if(strategySelected.equals("Sweep")){
//			addStrategy.computerStrategy = new SweepStrategy(addStrategy.userBoard.places());
//		}else if(strategySelected.equals("Random")){
//			addStrategy.computerStrategy = new RandomStrategy(addStrategy.userBoard.places());
//		}
	}
	
}
