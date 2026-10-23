//
//  MazeLogic.swift
//  MazeGame
//
//  Created by Kaid Malone on 10/22/26.
//
import Observation
import Foundation

struct SeededRandomGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        // A seed of 0 can stall some generators fallback to a default
        self.state = seed == 0 ? 5489 : seed
    }

    /// Mutates the state and returns the next uniform pseudo-random UInt64
    mutating func next() -> UInt64 {
        // Knuth's MMIX LCG parameters
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

@Observable
class LogicMaze {
    
    var maze: [[MazeNode]] = [] // TODO: Initialize in init
    var seed: UInt64 = 1234 // TODO: Initialize in init
    
    var steps: Int = 0
    var lettersFound: [Character] = [] // TODO: Initialize in init
    private var word: String = "" // TODO Initialize in init
    
    
    private var nodesToVisualize: [MazeNode] = [] // Treats it like a stack
    private var rndGen: SeededRandomGenerator = SeededRandomGenerator(seed: 1234) // TODO: Initialize in init
    
    init(seed: UInt64){
        
    }
    
    func move(dir: Directions) -> Bool {
        return true
    }
    
    func getNextNode() -> MazeNode? { // Returns nil if the list is empty
        return nodesToVisualize.popLast()
    }
    
    func isGuessAllowed() -> Bool {
        return true
    }
    
    func guessPassword(guess: String) -> Bool {
        return true
    }
    
    func reset(seed: UInt64){
        
    }
}
