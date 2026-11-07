//
//  ContentView.swift
//  MazeGame
//
//  Created by Kaid Malone on 10/20/26.
//

import SwiftUI

struct ParentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Maze-A-Don!")
                    .font(.system(size: 50, weight: .black, design: .rounded)).foregroundStyle(.blue.gradient).padding(30)
                
                // Static Navigation Link
                NavigationLink("Play Game!") {
                    StaticDetailView()
                }.padding()
                
            }
            .navigationTitle("Main Menu")
            // Handles data-driven navigation destinations
        }
    }
}

struct MazeWallsShape: Shape {
    let maze: [[MazeNode]]
    let cellSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var completePath = Path()
        
        for y in 0..<maze.count {
            for x in 0..<maze.count {
                addWalls(node: maze[y][x], x: x, y: y, to: &completePath)
            }
        }
        
        return completePath
    }
    
    private func addWalls(node: MazeNode, x: Int, y: Int, to path: inout Path) {
        
        let originX = CGFloat(x) * cellSize
        let originY = CGFloat(y) * cellSize
        
        var topLeft     = CGPoint(x: originX, y: originY)
        var topRight    = CGPoint(x: originX + cellSize, y: originY)
        var bottomLeft  = CGPoint(x: originX, y: originY + cellSize)
        var bottomRight = CGPoint(x: originX + cellSize, y: originY + cellSize)
        
        if node.walls[.north]! {
            path.move(to: topLeft)
            path.addLine(to: topRight)
        }
        
        
        
        
        
        if node.walls[.west]! {
            path.move(to: bottomLeft)
            path.addLine(to: topLeft)
        }
        
        if x == maze.count - 1 && node.walls[.east]! {
            path.move(to: bottomRight)
            path.addLine(to: topRight)
        }
        
        if y == maze.count - 1 && node.walls[.south]! {
            path.move(to: bottomLeft)
            path.addLine(to: bottomRight)
        }
    }
}

struct StaticDetailView: View {
    @State private var volume = 0.5
    @State private var showSlider = false
    
    @State var mazeBackend = LogicMaze(seedInput: Int.random(in: 255...7897324))
    var body: some View {
            ZStack {
                
                Canvas { context, size in
                    
                    let mazeSize = CGFloat(mazeBackend.maze.count)
                    let cellSize = CGFloat(20)
                    
                    let worldWidth = mazeSize * cellSize + 100
                    let worldHeight = mazeSize * (cellSize + 10)
                    
                    let scaleX = size.width / worldWidth
                    let scaleY = size.height / worldHeight
                    let fitScale = min(scaleX, scaleY)
                    
                    let remainingWidth = size.width - worldWidth * fitScale
                    let remainingHeight = size.height - worldHeight * fitScale
                    
                    context.translateBy(x: remainingWidth / 2, y: remainingHeight / 2)
                    
                    context.scaleBy(x: fitScale, y: fitScale)
                    
                    var mazeDraw: MazeWallsShape = MazeWallsShape(maze: mazeBackend.maze, cellSize: cellSize)
                    
                    var path = mazeDraw.path(in: CGRect())
                    
                    // 3. Render the full path onto the canvas context
                    context.stroke(
                        path,
                        with: .color(.black.opacity(0.4)),
                        lineWidth: 2.0
                    )
                }
                .background(Color(.systemGray))
                
                HStack{
                    Text("Something").position()
                }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showSlider.toggle()
                } label: {
                    Text("Settings")
                }
                
                .popover(isPresented: $showSlider) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Volume: \(Int(volume))%")
                            .font(.caption)
                            .bold()
                        Slider(value: $volume, in: 0...100)
                            .frame(width: 150)
                        
                        Button {
                            
                        } label: {
                            Text("Reset Maze")
                                
                        }.colorMultiply(.red)
                    }
                    .padding()
                    .presentationCompactAdaptation(.popover)
                }
            }
        }
        .navigationTitle("Maze Game")
        
    } 
        
        
}


#Preview {
    ParentView()
}
