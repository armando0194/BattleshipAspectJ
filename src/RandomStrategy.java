import java.util.Collections;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import battleship.model.Place;

public class RandomStrategy extends Strategy{
	
	public RandomStrategy(Iterable<Place> places) {
		super(places);
		generatePossibleMoveKeys();
	}

	@Override
	protected void move() { 
		if(possibleMoveKeys.isEmpty()) return;
		int randomIndex = possibleMoveKeys.get(firstElement);
		Place randomPlace = possibleMoves.get(randomIndex);
		randomPlace.hit();
		removePlaceByIndex(firstElement);
	}

	@Override
	protected void generatePossibleMoveKeys() {
		possibleMoveKeys = IntStream.rangeClosed(1, 100).boxed().collect(Collectors.toList()); 
		Collections.shuffle(possibleMoveKeys);
	}
}
