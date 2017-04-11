import javax.swing.DefaultComboBoxModel;
import javax.swing.JComboBox;

public class StrategyDropDown extends JComboBox<String[]>{
	private final String[] choices = {"Random", "Sweep", "Smart"};
	
	/**
	 * Constructor
	 * Sets the choices of the drop down 
	 */
	public StrategyDropDown(){
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
