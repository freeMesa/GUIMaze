//
//  DataClass.swift
//  MazeGame
//
//  Created by Kaid Malone on 10/22/26.
//

let oppDirections: [Directions: Directions] = [.north: .south, .east: .west, .south: .north, .west: .east];
let dirEncoding: [Directions: Position] = [.north: Position(x: 0, y: 1), .east: Position(x: 1, y: 0), .south: Position(x: 0, y: -1), .west: Position(x: -1, y: 0)];

enum Directions : CaseIterable {
    case north;
    case east;
    case south;
    case west;
}


struct Position {
    var x: Int;
    var y: Int;
    
    func addPositions(a: Position, b: Position) -> Position {
        
        return Position(x: a.x + b.x, y: a.y + b.y);
    }
}

struct MazeNode {
    
    // True if there is a wall in the direction
    var walls: [Directions: Bool] = [.north: true, .east: true, .south: true, .west: true];
    
    var letters: [String] = [];
    
    // Will mark it as falls through the first pass, then true as they are queued for visualization
    var visualized: Bool = true;
    var pos: Position;
    
}
