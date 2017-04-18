package battleship.strategy;
import java.util.HashMap;
import java.util.List;
import battleship.model.Place;

/**
 * @author Manuel Hernandez
 * @author Sebastian Perez
 */
public abstract class Strategy
{
	/** */
	public final int firstElement = 0;
	
	/** Hashmap that will stores all the possible moves */
	public HashMap<Integer, Place> possibleMoves; 
	
	/** List containing the possible moves from the hashmap*/
	public List<Integer> possibleMoveKeys;
	
	/** Generates a computer move depending on the strategy */
	abstract protected void move();
	
	/** generates all the possible moves */
	abstract protected void generatePossibleMoveKeys();
	
	/**
	 * Constructor that stores all the possible moves in a hashmap
	 * @param places - board places
	 */
	public Strategy(Iterable<Place> places) {
		generatePossibleMoves(places);
	}
	
	/**
	 * Generates all the possibles moves and stores it in a Hashmap
	 * @param places - board places
	 */
	public void generatePossibleMoves(Iterable<Place> places){
		possibleMoves = new HashMap<Integer, Place>();
		int index = 1;
		
		//Traverse the places and stores it in a List
		for (Place place : places) {
			possibleMoves.put(index++, place);
		}
	}
	
	/**
	 * Removes a possible move from tthe list 
	 * @param key - key of the element that will be removed
	 */
	public void removePlaceByIndex(int key){
		possibleMoveKeys.remove(key);
	}
	
	/**
	 * Removes a possible move from the lists 
	 * @param key - key of the element that will be removed
	 */
	public void removePlaceByValue(Integer value){
		possibleMoveKeys.remove(value);
	}
}