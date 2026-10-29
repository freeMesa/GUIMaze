//
//  MazeGameTests.swift
//  MazeGameTests
//
//  Created by Kaid Malone on 10/20/26.
//

import Testing
@testable import MazeGame

struct MazeGameTests {

    @Test("Making sure the maze is connected.", arguments: [256, 800, 1565, 10000234, 32473])
    func mazeSolvable(seed: Int) {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
        
        
        // TODO: Test that all nodes are reachable
    }
    
    @Test("Testing the equivilence under same seeding.", arguments: [256, 800, 1565, 10000234, 32473])
    func mazeEquivilence(seed: Int) {
        
        // TODO: Create two mazes and test that they are equivilent with the same seed
    }

}
