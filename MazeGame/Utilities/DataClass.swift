//
//  DataClass.swift
//  MazeGame
//
//  Created by Kaid Malone on 10/22/26.
//

let oppDirections: [Directions: Directions] = [.north: .south, .east: .west, .south: .north, .west: .east]

let dirEncoding: [Directions: Position] = [.north: Position(x: 0, y: -1), .east: Position(x: 1, y: 0), .south: Position(x: 0, y: 1), .west: Position(x: -1, y: 0)]

let wordList: [String] = ["prefer", "prejudice", "imposter", "consumer", "obscure", "tiptoe", "scandal", "gossip", "candle", "exotic", "slogan", "accompany", "captivate", "bubble", "advocate", "dilute", "nonremittal", "compensation", "assembly", "advice", "marketing", "secretary", "barrier"]

enum Directions : CaseIterable {
    case north
    case east
    case south
    case west
}


struct Position: Equatable, Hashable {
    var x: Int
    var y: Int
    
    static func addPositions(a: Position, b: Position) -> Position {
        
        return Position(x: a.x + b.x, y: a.y + b.y)
    }
}

class MazeNode: Equatable {
    
    // True if there is a wall in the direction
    var walls: [Directions: Bool] = [.north: true, .east: true, .south: true, .west: true]
    
    var letter: Int = -1 // Index of the letter
    var pos: Position = Position(x: -1, y: -1)
    
    // Will mark it as false through the first pass of the maze generation
    // for the backtracking toggle, then true as they are queued for visualization.
    // Will manually set to false for the frontend nodes that aren't visualized yet
    var visualized: Bool = true
    
    static func == (lhs: MazeNode, rhs: MazeNode) -> Bool {
        
        
        return lhs.letter == rhs.letter && lhs.visualized == rhs.visualized && lhs.pos == rhs.pos && lhs.walls == rhs.walls
    }
}
