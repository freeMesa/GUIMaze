//
//  MazeLogic.swift
//  MazeGame
//
//  Created by Kaid Malone on 10/22/26.
//
import Observation
import Foundation

@Observable
class LogicMaze {
    
    var maze: [[MazeNode]] = [] // TODO: Initialize in init
    var playerPos: Position = Position(x: -1, y: -1)
    var isPlayerStart: Bool = true
    let seed: Int // TODO: Initialize in init
    
    var steps: Int = 0
    var lettersFound: [Character] = [] // TODO: Initialize in init
    private var word: String = "" // TODO Initialize in init
    
    // @Deprecate most likely, and add a getter function for the nodes using relative coordinates
    private var nodesToVisualize: [MazeNode] = [] // Treat it like a stack
    private var rndGen: SeededRandomGenerator // TODO: Initialize in init
    
    init(seedInput: Int){
        // Initialization
        let generator = SeededRandomGenerator(seed: seedInput)
        self.rndGen = generator
        self.seed = seedInput
        
        
        // Calling of the setup function
        self.generateMaze()
    }
    
    private func generateMaze() {
        // TODO: Backtracking algorithm
        
        let size = rndGen.nextRange(min: 16, max: 20) // Can define these later
        
        self.playerPos = Position(x: -1, y: size - 1)
        
        self.maze = (0..<size).map { rowIndex in // Blank maze
            (0..<size).map { colIndex in
                var node = MazeNode()
                node.pos = Position(x: colIndex, y: size - rowIndex - 1)
                return node
            }
        }
        
        // TODO: Backtracking algorithm
        var currX = rndGen.nextRange(min: 0, max: size - 1)
        var currY = rndGen.nextRange(min: 0, max: size - 1)
        
        var currNode = self.maze[currY][currX]
        currNode.visualized = false
        
        var stack: [MazeNode] = [currNode]
        var nxtNode: MazeNode
        while(!stack.isEmpty){
            currNode = stack.last!
            var newDirections: [Directions] = []
            
            for (dir, pos) in dirEncoding{
                let newPos: Position = Position.addPositions(a: pos, b: currNode.pos)
                var isNewDir: Bool = isInBounds(pos: newPos)
                isNewDir = isNewDir && (maze[newPos.y][newPos.x].visualized)
                
                if(isNewDir){
                    newDirections.append(dir)
                }
                
            }
            
            if(newDirections.isEmpty){
                stack.removeLast()
            } else {
                let index = rndGen.nextRange(min: 0, max: newDirections.count)
                let dir: Directions = newDirections[index]
                
                var nPos: Position = Position.addPositions(a: dirEncoding[dir]!, b: currNode.pos)
                
                nxtNode = maze[nPos.y][nPos.x]
                
                currNode.walls[dir]! = false
                nxtNode.walls[oppDirections[dir]!]! = false
                
                nxtNode.visualized = false
                
                stack.append(nxtNode)
            }
        }
    }
    
    private func isInBounds(pos: Position) -> Bool {
        let size = maze.count
        if((pos.x >= size || pos.x < 0) || (pos.y >= size || pos.y < 0)){
            return false
        } else {
            return true
        }
    }
    
    func move(dir: Directions) -> Bool {
        
        // TODO: Move logic
        // TODO: Make sure the move is doable
        var newPosition: Position = Position.addPositions(a: playerPos, b: dirEncoding[dir]!)
        
        if(!isInBounds(pos: newPosition)){
            return false
        }
        
        var newNode: MazeNode = maze[newPosition.y][newPosition.x]
        
        if(newNode.walls[dir]!){
            return false
        }
        
        playerPos = newPosition
        
        func makeVisible(currNode: MazeNode, dist: Int, totDist: Int) {
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
    
    func reset(seed: Int){
        // TODO: reset all values (mainly seed)
        
        // TODO; reset game state values
        
        generateMaze()
    }
}
