//
//  MazeGameTests.swift
//  MazeGameTests
//
//  Created by Kaid Malone on 10/20/26.
//

import Testing
@testable import MazeGame

@Suite("Maze Backend Tests")
@MainActor
struct MazeTests {
    

    @Test("Making sure the maze is connected.", arguments: [256, 800, 1565, 10000234, 32473])
    func mazeSolvable(seed: Int) {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
        
        
        // TODO: Test that all nodes are reachable
        let testMaze = LogicMaze(seedInput: seed)
        
        print("Testing seed: \(seed), size: \(testMaze.maze.count)")
        
        let size = testMaze.maze.count
        #expect(size >= 16 && size <= 20)
            
        var visited = Set<Position>()
        var queue: [Position] = []
            
        // Start traversal from the bottom-left or top-left corner (e.g., 0,0)
        let startPos = Position(x: 0, y: 0)
        queue.append(startPos)
        visited.insert(startPos)
            
        while !queue.isEmpty {
            let currentPos = queue.removeFirst()
            let currentNode = testMaze.maze[size - currentPos.y - 1][currentPos.x]
                
            // Check all 4 directions
            for (dir, adder) in dirEncoding {
                // Only traverse if there is NO wall blocking the path
                if !currentNode.walls[dir]! {
                    let nextPos = Position.addPositions(a: currentPos, b: adder)
                    
                    // If it's inside bounds and hasn't been visited yet, visit it
                    if testMaze.isInBounds(pos: nextPos) && !visited.contains(nextPos) {
                        visited.insert(nextPos)
                        queue.append(nextPos)
                    }
                }
            }
        }
            
            // Total nodes in a square maze is size * size
        #expect(visited.count == (size * size))
        var testVal = true
        for i in 0..<testMaze.maze.count {
            for j in 0..<testMaze.maze.count {
                var alltrue = true
                for dir in Directions.allCases {
                    if(!testMaze.maze[i][j].walls[dir]!){
                        alltrue = false
                        break
                    }
                }
                
                if alltrue { testVal = false }
            }
        }
        
        #expect(testVal)
    }
    
    @Test("Making sure the reset function works.", arguments: [256, 800, 1565, 1000234, 32473])
    func resetMaze(seed: Int) {
        
        let maze1 = LogicMaze(seedInput: 1243)
        let maze2 = LogicMaze(seedInput: seed)
        
        #expect(!(maze1 == maze2))
        maze1.reset(seed: seed)
        
        #expect(maze1 == maze2)
    }
    
    @Test("Testing the equivilence under same seeding.", arguments: [256, 800, 1565, 10000234, 32473])
    func mazeEquivilence(seed: Int) {
        
        // TODO: Create two mazes and test that they are equivilent with the same seed
        let maze1 = LogicMaze(seedInput: seed)
        let maze2 = LogicMaze(seedInput: seed)
        let maze3 = LogicMaze(seedInput: 1234)
        
        #expect(maze1 == maze2)
        #expect(!(maze1 == maze3))
        
        
    }
    
    @Test("Testing movement.", arguments: [234, 3442, 1234832, 8, 25])
    func startingMovement(seed: Int) {
        
        // TODO: Create a prebaked maze of size 5x5 random generate the walls
        // Walls don't matter, as the movement is just checking whether the directional movement actually satisfies the condition
        let maze1 = LogicMaze(seedInput: seed)
        
        #expect(!(maze1.move(dir: .north)))
        #expect(!(maze1.move(dir: .north)))
        
        #expect(maze1.move(dir: .east))
        
        #expect(!(maze1.move(dir: .west)))
    
    }


}

@Suite("Utility Data Class Tests")
@MainActor
struct DataClassTests {
    
    
    @Test("Testing position adding")
    func positionAddingTest() {
        
        let pos: Position = Position(x: 5, y: -2)
        let adder: Position = Position(x: 5, y: 3)
        
        #expect(Position.addPositions(a: pos, b: adder).x == 10)
        #expect(Position.addPositions(a: pos, b: adder).y == 1)
    }
    
    @Test("Equality of members")
    func equalityOfStructs() {
        
        let mazeNode = MazeNode()
        let mazeNodeCmp = MazeNode()
        
        #expect(mazeNode == mazeNodeCmp)
        
        mazeNode.pos = Position(x: 2, y: 2)
        mazeNodeCmp.pos = Position(x: 3, y: 2)
        
        #expect(!(mazeNode == mazeNodeCmp))
        
        mazeNodeCmp.pos = Position(x: 2, y: 2)
        
        #expect(mazeNode == mazeNodeCmp)

        mazeNode.walls[Directions.east]! = false
        
        #expect(!(mazeNode == mazeNodeCmp))
        
        mazeNodeCmp.walls[.east]! = false
        
        #expect(mazeNode == mazeNodeCmp)

    }
    
}

@Suite("Random Generation Tests")
struct RandomTest {
    
    
    @Test("Testing whether the random value is repeatable", arguments: [252, 2374, 8901, 38234, 34234434, 5, 25])
    func seededReliability(seed: Int) {
        
        var rndFunc1 = SeededRandomGenerator(seed: seed)
        var rndFunc2 = SeededRandomGenerator(seed: seed)
        
        #expect(rndFunc1.next() == rndFunc2.next())
        
        #expect(rndFunc1.next() == rndFunc2.next())
        
        #expect(rndFunc1.next() == rndFunc2.next())
        

    }
}
