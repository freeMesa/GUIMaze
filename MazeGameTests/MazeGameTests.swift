//
//  MazeGameTests.swift
//  MazeGameTests
//
//  Created by Kaid Malone on 10/20/26.
//

import Testing
@testable import MazeGame

@Suite("Maze Backend Tests")
struct MazeTests {
    

    @Test("Making sure the maze is connected.", arguments: [256, 800, 1565, 10000234, 32473])
    func mazeSolvable(seed: Int) {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
        
        
        // TODO: Test that all nodes are reachable
    }
    
    @Test("Making sure the reset function works.", arguments: [256, 800, 1565, 1000234, 32473])
    func resetMaze(seed: Int) {
        
    }
    
    @Test("Testing the equivilence under same seeding.", arguments: [256, 800, 1565, 10000234, 32473])
    func mazeEquivilence(seed: Int) {
        
        // TODO: Create two mazes and test that they are equivilent with the same seed
        
    }
    
    @Test("Testing movement.", arguments: [(-1, 1), (5, 5), (3, 2)])
    func movementTest(x: Int, y: Int) {
        
        // TODO: Create a prebaked maze of size 5x5 random generate the walls
        // Walls don't matter, as the movement is just checking whether the directional movement actually satisfies the condition
        var prebakedMaze: [[MazeNode]] = (0..<5).map { rowIndex in // Blank maze
            (0..<5).map { colIndex in
                var node = MazeNode()
                node.pos = Position(x: colIndex, y: 5 - rowIndex - 1)
                return node
            }
        }
        
        for i in 0..<5 {
            for j in 0..<5 {
                
                for dir in Directions.allCases {
                    var toggle = Bool.random()
                    prebakedMaze[j][i].walls[dir]! = toggle
                }
            }
        }
        
        prebakedMaze[prebakedMaze.count - 1][0].walls[.west] = false
        
        var maze = LogicMaze(seedInput: 20) // Seed is irrelevant
        
        
        
        // TODO: Set player position
        
        // TODO: Call move function foreach direction
        // TODO: Check that the player is in the correct position
        // TODO: Reset player position each time
    }
    
    @Test("Testing the visualization pipeline.")
    func nodeVisualization() {
        
        // TODO: Create a prebaked maze (actually this time) 5x5
        var prebakedMaze: [[MazeNode]] = (0..<5).map { rowIndex in // Blank maze
            (0..<5).map { colIndex in
                var node = MazeNode()
                node.pos = Position(x: colIndex, y: 5 - rowIndex - 1)
                return node
            }
        }
        // TODO: Define the nodes that should be visualized after move
        // TODO: player move
        // Check that it matches
        
        // TODO: Do this multiple times for the same maze differen positions nad moves
    }

}

@Suite("Utility Data Class Tests")
struct DataClassTests {
    
    
}

@Suite("Random Generation Tests")
struct RandomTest {
    
}
