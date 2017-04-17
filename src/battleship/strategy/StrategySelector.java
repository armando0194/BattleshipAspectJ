package battleship.strategy;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JComboBox;

@SuppressWarnings("serial")
public class StrategySelector extends JComboBox<String[]>{
	private final String[] choices = {"Random", "Sweep", "Smart"};
	
	/**
	 * Constructor
	 * Sets the choices of the drop down 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public StrategySelector(){
		super();
		setModel( new DefaultComboBoxModel(choices) );
	}
	
	/**
	 * Returns the strategy that the user selected
	 * @return - String containing the strategy selected
	 */
	public String getStrategySelected(){
		return getSelectedItem().toString();
	}
}
