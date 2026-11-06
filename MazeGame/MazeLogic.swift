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
    
    private(set) var maze: [[MazeNode]] = []
    private(set) var playerPos: Position = Position(x: -1, y: -1)
    private(set) var isPlayerStart: Bool = true // @
    private(set) var seed: Int // TODO: Initialize in init
    
    private(set) var steps: Int = 0 // @
    private(set) var lettersFound: [Character] = [] // TODO: Initialize in init
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
        
        self.word = wordList[rndGen.nextRange(min: 0, max: wordList.count - 1)]
        self.lettersFound = Array(repeating: "_", count: self.word.count)
        
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
                isNewDir = isNewDir && (maze[size - newPos.y - 1][newPos.x].visualized)
                
                if(isNewDir){
                    newDirections.append(dir)
                }
                
            }
            
            if(newDirections.isEmpty){
                stack.removeLast()
            } else {
                let index = rndGen.nextRange(min: 0, max: newDirections.count - 1)
                let dir: Directions = newDirections[index]
                
                let nPos: Position = Position.addPositions(a: dirEncoding[dir]!, b: currNode.pos)
                
                nxtNode = maze[size - nPos.y - 1][nPos.x]
                
                currNode.walls[dir] = false
                nxtNode.walls[oppDirections[dir]!] = false
                
                nxtNode.visualized = false
                
                stack.append(nxtNode)
            }
        }
        
        // Word list appending
        for index in 0..<self.word.count {
            
            var x = rndGen.nextRange(min: 0, max: self.maze.count - 1)
            var y = rndGen.nextRange(min: 0, max: self.maze.count - 1)
            
            while(maze[y][x].letter != -1){
                x = rndGen.nextRange(min: 0, max: self.maze.count)
                y = rndGen.nextRange(min: 0, max: self.maze.count)
            }
            
            maze[y][x].letter = index
            
        }
    }
    
    func isInBounds(pos: Position) -> Bool {
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
        
        func makeVisible(currNode: MazeNode, dist: Int, totDist: Int, visitedInCurrentPath: Set<Position>) {
            // Make visible
            currNode.visualized = true
            
            if(dist >= totDist){
                return
            }
            
            var currentPath = visitedInCurrentPath
            currentPath.insert(currNode.pos)
            for (dir, adder) in dirEncoding {
                
                if(!currNode.walls[dir]!) {
                    
                    var np = Position.addPositions(a: adder, b: currNode.pos)
                    if(isInBounds(pos: np) && !currentPath.contains(np)){
                        var newNode = maze[np.y][np.x]
                        
                        makeVisible(currNode: newNode, dist: dist + 1, totDist: totDist, visitedInCurrentPath: currentPath)
                    }
                    
                }
            }
            
        }
        
        makeVisible(currNode: newNode, dist: 0, totDist: 2, visitedInCurrentPath: Set<Position>())
        
        return true
    }
    
    // Treating the top left as the origin: (0, 0)
    func isGuessAllowed() -> Bool {
        let c = maze.count - 1
        return playerPos.x == c && playerPos.y == 0 // Top right corner
    }
    
    func guessPassword(guess: String) -> Bool {
        return isGuessAllowed() ? word.compare(guess, options: [.caseInsensitive]) == .orderedSame : false
    }
    
    func reset(seed: Int){
        
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
    
    static func == (lhs: LogicMaze, rhs: LogicMaze) -> Bool {
        
        if(!(lhs.word == rhs.word)){
            return false
        }
        
        if(!(lhs.maze.count == rhs.maze.count)) {
            return false
        }
        
        for i in 0..<lhs.maze.count {
            for j in 0..<lhs.maze.count {
                if(!(lhs.maze[i][j] == rhs.maze[i][j])){
                    return false
                }
            }
        }
        
        return true
    }
}
