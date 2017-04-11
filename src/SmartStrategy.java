import java.util.Collections;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import battleship.model.Place;

public class SmartStrategy extends Strategy {

	Stack<Integer> potentialShipLocations;
	boolean isShipFound = false;
	
	public SmartStrategy(Iterable<Place> places) {
		super(places);
		generatePossibleMoveKeys();
		potentialShipLocations = new Stack<Integer>();
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void move() {
		int moveIndex;
		Place move;
		
		// if the stack is empty, a ship has not been found
		if(potentialShipLocations.isEmpty()){
			isShipFound = false;
		}
			
		if(isShipFound){
		//if a ship was found try to shoot at the surrounding cells
			moveIndex = potentialShipLocations.pop();
			if(possibleMoveKeys.contains(moveIndex))
				removePlaceByValue( moveIndex );
		}
		else{
		//otherwise, generate random value and check if a ship was hit
			moveIndex = possibleMoveKeys.get(firstElement);
			removePlaceByIndex(firstElement);
			
		}
		
		move = possibleMoves.get(moveIndex);
		move.hit();
		
		if(move.isHitShip()){
			isShipFound = true;
			generatePotentialShipLocations(move, moveIndex);
		}
	}

	private void generatePotentialShipLocations(Place move, int cell) {
		
		// if the cell to the left exists or hasnt been hit, add it to potential move
		if( move.getY() > 1  && !possibleMoves.get(cell-1).isHit() ) {
			potentialShipLocations.push(cell-1);
			//parent::removeShot($cell-1);
		}
		
		// if the cell to the right exists or hasnt been hit, add it to potential move
		if( move.getY() < 10 && !possibleMoves.get(cell + 1).isHit() ) {
			potentialShipLocations.push(cell+1);
			//parent::removeShot($cell+1);
		}
		
		// if the cell above exists or hasnt been hit, add it to potential move
		if( move.getX() > 1 && !possibleMoves.get(cell-10).isHit() ) {
			potentialShipLocations.push(cell-10);
			//parent::removeShot($cell-10);
		}
		
		// if the cell below exists or hasnt been hit, add it to potential move
		if( move.getX() < 10  && !possibleMoves.get(cell+10).isHit() ) {
			potentialShipLocations.push(cell + 10);
			//parent::removeShot($cell+10);
		}		
	}

	/**
	 * Generates moves:
	 * - x - x - x - x - x
	 * x - x - x - x - x -
	 * - x - x - x - x - x
	 * x - x - x - x - x -
	 * - x - x - x - x - x
	 * x - x - x - x - x -
	 * - x - x - x - x - x
	 * x - x - x - x - x -
	 * - x - x - x - x - x
	 * x - x - x - x - x -
	 */
	@Override
	protected void generatePossibleMoveKeys() {
		possibleMoveKeys = IntStream.iterate(2, i -> (i % 10 == 0)? i + 1 : (i % 10 == 9) ? i + 3 : i + 2)
							.limit(50)
							.boxed()
							.collect(Collectors.toList());  
		Collections.shuffle(possibleMoveKeys);
	}

}
