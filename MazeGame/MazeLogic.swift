//
//  MazeLogic.swift
//  MazeGame
//
//  Created by Kaid Malone on 10/22/26.
//
import Observation
import Foundation

struct SeededRandomGenerator: RandomNumberGenerator {
    var state: UInt64

    init(seed: Int) {
        // A seed of 0 can stall some generators fallback to a default
        let bitPatternSeed = UInt64(bitPattern: Int64(seed))
        self.state = bitPatternSeed == 0 ? 5489 : bitPatternSeed
    }

    /// Mutates the state and returns the next uniform pseudo-random UInt64
    mutating func next() -> UInt64 {
        // Knuth's MMIX LCG parameters
        // &+ and &* are wrap around operations which implicitly enforce mod 64
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
    
    mutating func nextRange(min: Int, max: Int) -> Int { // Fix: bounds checking to safely convert from UInt
        guard min <= max else { return min }
        
        let range = UInt64(max - min + 1)
        let offset = next() % range
        
        // Not truly random but good enough
        return min + Int(offset)
    }
}

@Observable
class LogicMaze {
    
    var maze: [[MazeNode]] = [] // TODO: Initialize in init
    var playerPos: Position = Position(x: -1, y: 0)
    let seed: Int // TODO: Initialize in init
    
    var steps: Int = 0
    var lettersFound: [Character] = [] // TODO: Initialize in init
    private var word: String = "" // TODO Initialize in init
    
    // @Deprecate most likely, and add a getter function for the nodes using relative coordinates
    private var nodesToVisualize: [MazeNode] = [] // Treat it like a stack
    private var rndGen: SeededRandomGenerator // TODO: Initialize in init
    
    init(seed: Int){
        // Initialization
        let generator = SeededRandomGenerator(seed: seed)
        self.rndGen = generator
        self.seed = seed
        
        // Calling of the setup function
        self.generateMaze()
    }
    
    private func generateMaze() {
        // TODO: Backtracking algorithm
        
        let size = rndGen.nextRange(min: 16, max: 20) // Can define these later
                
        maze = (0..<size).map { rowIndex in // Blank maze
            (0..<size).map { colIndex in
                var node = MazeNode()
                node.pos = Position(x: colIndex, y: size - rowIndex - 1)
                return node
            }
        }
        
        // TODO: Backtracking algorithm
        
        
    }
    
    func move(dir: Directions) -> Bool {
        
        // TODO: Move logic
        // TODO: Make sure the move is doable
        
        func makeVisible() {
            // Make visible
        }
        
        makeVisible()
        
        return true
    }
    
    func getNode(x: Int, y: Int) -> MazeNode? {
        let c = maze.count
        return x > c || y > c ? nil : maze[c - y - 1][x]
    }
    
    // @Deprecated
    private func getNextNode() -> MazeNode? { // Returns nil if the list is empty
        return nodesToVisualize.popLast()
    }
    
    func isGuessAllowed() -> Bool {
        let c = maze.count
        return playerPos.x == c && playerPos.y == c // Top right corner
    }
    
    func guessPassword(guess: String) -> Bool {
        return isGuessAllowed() ? word.compare(guess, options: [.caseInsensitive]) == .orderedSame : false
    }
    
    func reset(seed: UInt64){
        // TODO: reset all values (mainly seed)
        
        // TODO; reset game state values
        
        generateMaze()
    }
}
