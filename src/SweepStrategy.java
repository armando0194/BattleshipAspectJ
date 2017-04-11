import java.util.stream.Collectors;
import java.util.stream.IntStream;

import battleship.model.Place;

public class SweepStrategy extends Strategy{

	public SweepStrategy(Iterable<Place> places) {
		super(places);
		generatePossibleMoveKeys();
	}

	@Override
	protected void move() {
		if(possibleMoveKeys.isEmpty()) return;
		int nextIndex = possibleMoveKeys.get(firstElement);
		Place randomPlace = possibleMoves.get(nextIndex);
		randomPlace.hit();
		removePlaceByValue(firstElement);
		System.out.println("stop");
	}

	@Override
	protected void generatePossibleMoveKeys() {
		possibleMoveKeys = IntStream.rangeClosed(1, 100).boxed().collect(Collectors.toList()); 	
		System.out.println("stop");
	}

}
