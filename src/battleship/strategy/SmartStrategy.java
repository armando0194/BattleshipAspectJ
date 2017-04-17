package battleship.strategy;

import java.util.Collections;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import battleship.model.Place;

public class SmartStrategy extends Strategy {

	/** Stack that save potential ship locations when a ship is hit */
	Stack<Integer> potentialShipLocations;
	
	/** Flag that determines if the computer is in hunt or sunk */
	boolean isShipFound = false;
	
	/**
	 * Constructor that generates all the possible moves in
	 * a smart strategy
	 * @param places - places in the board
	 */
	public SmartStrategy(Iterable<Place> places) {
		super(places);
		generatePossibleMoveKeys();
		potentialShipLocations = new Stack<Integer>();
	}

	/**
	 * Generates a move using an smart strategy and it hits it
	 */
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
		
		// if a ship was hit, then add potential moves to the stack
		if(move.isHitShip()){
			isShipFound = true;
			generatePotentialShipLocations(move, moveIndex);	
		}
	}

	/**
	 * Checks if the cells adjacent to the hit place are already hit. if not, 
	 * it adds them to the stack
	 * @param move - computer generated move  
	 * @param cell - index of the move
	 */
	private void generatePotentialShipLocations(Place move, int cell) {
		// if the cell above exists and hasn't been hit, add it to potential move
		if( move.getY() > 1  && !possibleMoves.get(cell-1).isHit()) 
			potentialShipLocations.push(cell-1);
		
		// if the cell below exists and hasn't been hit, add it to potential move
		if( move.getY() < 10 && !possibleMoves.get(cell + 1).isHit()) 
			potentialShipLocations.push(cell+1);
		
		// if the cell to the left exists and hasn't been hit, add it to potential move
		if( move.getX() > 1 && !possibleMoves.get(cell-10).isHit()) 
			potentialShipLocations.push(cell-10);
		
		// if the cell to the right exists  and hasn't been hit, add it to potential move
		if( move.getX() < 10  && !possibleMoves.get(cell+10).isHit()) 
			potentialShipLocations.push(cell + 10);	
	}

	/**
	 * Generates possible moves based on parity. It generates places
	 * that are separated by one cell
	 */
	@Override
	protected void generatePossibleMoveKeys() {
		// generates 50 moves, that are separated by one cell
		possibleMoveKeys = IntStream.iterate(2, i -> isMoveValid(i) )
				.limit(50)
				.boxed()
				.collect(Collectors.toList());
		Collections.shuffle(possibleMoveKeys);
	}
	
	/**
	 * checks if the move generated is valid
	 * @param i - index of the move
	 * @return - index that is valid
	 */
	protected int isMoveValid(int i){
		if(i % 10 == 0) 
		// if the move is at the end of the column, add one to it
			i+= 1;
		else if(i % 10 == 9)
		// else if the move is second to last, then add 3 to it
			i+= 3;
		else
		// otherwise add 2
			i+= 2;
		
		return i;
	}

}
