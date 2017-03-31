import javax.swing.JPanel;

import org.aspectj.lang.ProceedingJoinPoint;

import battleship.BattleshipDialog;

import javax.swing.JButton;

public privileged aspect AddStrategy {
	
	private JButton newPlay;
	
	pointcut addPlayButtton() : execution(JPanel makeControlPane());
	
	after() : addPlayButtton(){
		 System.out.println("Number="+((BattleshipDialog)thisJoinPoint.getTarget()).playButton.getText());
		 BattleshipDialog context =  ((BattleshipDialog)thisJoinPoint.getTarget());
		 
		 newPlay = new JButton("Play");
		 
		 System.out.println("counter " + context.getComponentCount());
		 
		 context.playButton.setText("Practice");
		 
	}
}
