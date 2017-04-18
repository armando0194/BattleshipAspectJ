package battleship.strategy;

import java.util.stream.Collectors;
import java.util.stream.IntStream;

import battleship.model.Place;

/**
 * @author Manuel Hernandez
 * @author Sebastian Perez
 */
public class SweepStrategy extends Strategy{

	/**
	 * Constructor 
	 * @param places - Places in the board
	 * @see Place
	 */
	public SweepStrategy(Iterable<Place> places) {
		super(places);
		generatePossibleMoveKeys();
	}

	/**
	 * Generates a move using the sweep strategy, and it hits it
	 */
	@Override
	protected void move() {
		if(possibleMoveKeys.isEmpty()) return;
		int nextIndex = possibleMoveKeys.get(firstElement);
		Place randomPlace = possibleMoves.get(nextIndex);
		randomPlace.hit();
		removePlaceByIndex(firstElement);
	}

	
	/**
	 * Generates all the possible moves in order, so the computer uses the sweep strategy
	 */
	@Override
	protected void generatePossibleMoveKeys() {
		possibleMoveKeys = IntStream.rangeClosed(1, 100).boxed().collect(Collectors.toList()); 	
	}

}
