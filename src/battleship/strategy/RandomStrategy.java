package battleship.strategy;

import java.util.Collections;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import battleship.model.Place;

public class RandomStrategy extends Strategy{
	
	/**
	 * Constructor that generates all the possible moves in
	 * a random strategy
	 * @param places - places in the board
	 */
	public RandomStrategy(Iterable<Place> places) {
		super(places);
		generatePossibleMoveKeys();
	}

	/**
	 * Generates a random move and it hits it
	 */
	@Override
	protected void move() { 
		if(possibleMoveKeys.isEmpty()) return;
		int randomIndex = possibleMoveKeys.get(firstElement);
		Place randomPlace = possibleMoves.get(randomIndex);
		randomPlace.hit();
		removePlaceByIndex(firstElement);
	}

	/**
	 * Inserts all the possible moves in a list and it shuffles it
	 */
	@Override
	protected void generatePossibleMoveKeys() {
		possibleMoveKeys = IntStream.rangeClosed(1, 100).boxed().collect(Collectors.toList()); 
		Collections.shuffle(possibleMoveKeys);
	}
}
