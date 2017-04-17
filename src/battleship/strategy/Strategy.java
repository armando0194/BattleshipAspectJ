package battleship.strategy;
import java.util.HashMap;
import java.util.List;
import battleship.model.Place;

public abstract class Strategy
{
	public final int firstElement = 0;
	public HashMap<Integer, Place> possibleMoves; 
	public List<Integer> possibleMoveKeys;
	
	abstract protected void move();
	abstract protected void generatePossibleMoveKeys();
	
	public Strategy(){}
	public Strategy(Iterable<Place> places) {
		generatePossibleMoves(places);
	}
	
	public void generatePossibleMoves(Iterable<Place> places){
		possibleMoves = new HashMap<Integer, Place>();
		int index = 1;
		
		//Traverse the places and stores it in a List
		for (Place place : places) {
			possibleMoves.put(index++, place);
		}
	}
	
	/**
	 * Removes a possible move from the HashMap 
	 * @param key - key of the element that will be removed
	 */
	public void removePlaceByIndex(int key){
		possibleMoveKeys.remove(key);
	}
	
	/**
	 * Removes a possible move from the HashMap 
	 * @param key - key of the element that will be removed
	 */
	public void removePlaceByValue(Integer value){
		possibleMoveKeys.remove(value);
	}
}