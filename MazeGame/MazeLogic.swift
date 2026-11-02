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
    
    var maze: [[MazeNode]] = []
    var playerPos: Position = Position(x: -1, y: -1)
    var isPlayerStart: Bool = true // @
    var seed: Int // TODO: Initialize in init
    
    var steps: Int = 0 // @
    var lettersFound: [Character] = [] // TODO: Initialize in init
    private var word: String = "" // TODO Initialize in init
    
    
    private var rndGen: SeededRandomGenerator // TODO: Initialize in init
    
    init(seedInput: Int){
        // Initialization
        let generator = SeededRandomGenerator(seed: seedInput)
        self.rndGen = generator
        self.seed = seedInput
        
        
        // Calling of the setup function
        self.generateMaze()
    }
    
    private func generateMaze() { // TODO: Utilize wordlist to generate word
        
        let size = rndGen.nextRange(min: 16, max: 20) // Can define these later
        
        self.playerPos = Position(x: -1, y: size - 1)
        
        self.maze = (0..<size).map { rowIndex in // Blank maze
            (0..<size).map { colIndex in
                var node = MazeNode()
                node.pos = Position(x: colIndex, y: size - rowIndex - 1)
                return node
            }
        }
        
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
        
        steps += 1
        
        // Checking for letter
        if newNode.letter != -1 {
            
            let index = word.index(word.startIndex, offsetBy: newNode.letter)
            lettersFound[newNode.letter] = word[index]
            
            newNode.letter = -1 // Removes it from the maze
        }
        //
        
        func makeVisible(currNode: inout MazeNode, dist: Int, totDist: Int) {
            // Make visible
            currNode.visualized = true
            
            if(dist >= totDist){
                return
            }
            
            for (dir, adder) in dirEncoding {
                
                if(!currNode.walls[dir]!) {
                    
                    var np = Position.addPositions(a: adder, b: currNode.pos)
                    
                    var newNode = maze[np.y][np.x]
                    
                    makeVisible(currNode: &newNode, dist: dist + 1, totDist: totDist)
                }
            }
            
        }
        
        makeVisible(currNode: &newNode, dist: 0, totDist: 2)
        
        return true
    }
    
    func getNode(x: Int, y: Int) -> MazeNode? {
        let c = maze.count
        return x > c || y > c ? nil : maze[c - y - 1][x]
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
        
        self.maze = []
        self.playerPos = Position(x: -1, y: -1)
        self.isPlayerStart = true // @
        self.seed = seed // TODO: Initialize in init
        
        self.steps = 0 // @
        self.lettersFound = [] // TODO: Initialize in init
        self.word = "" // TODO Initialize in init
        
        self.rndGen = SeededRandomGenerator(seed: seed) // TODO: Initialize in init
        
        generateMaze()
    }
}
