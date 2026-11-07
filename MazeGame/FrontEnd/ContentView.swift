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
                addWalls(node: maze[y][x], x: x, y: y, to: &completePath, c: maze[y].count)
            }
        }
        
        return completePath
    }
    
    private func addWalls(node: MazeNode, x: Int, y: Int, to path: inout Path, c: Int) {
        
        let originX = CGFloat(x) * cellSize
        let originY = CGFloat(y) * cellSize
        
        var topLeft     = CGPoint(x: originX, y: originY)
        var topRight    = CGPoint(x: originX + cellSize, y: originY)
        var bottomLeft  = CGPoint(x: originX, y: originY + cellSize)
        var bottomRight = CGPoint(x: originX + cellSize, y: originY + cellSize)
//
        
        if node.walls[.north]! {
            path.move(to: topLeft)
            path.addLine(to: topRight)
        }
        
        if node.walls[.west]! {
            path.move(to: bottomLeft)
            path.addLine(to: topLeft)
        }
        
        // Draw East wall ONLY on the far-right boundary column
        if x == maze.count - 1 && node.walls[.east]! {
            path.move(to: bottomRight)
            path.addLine(to: topRight)
        }
                
        // Draw South wall ONLY on the bottom boundary row
        if y == maze.count - 1 && node.walls[.south]! {
            path.move(to: bottomLeft)
            path.addLine(to: bottomRight)
        }
    }
}

struct StaticDetailView: View {
    @State private var volume = 0.5
    @State private var showSlider = false
    
    @State var mazeBackend = LogicMaze(seedInput: 1565)
    @State private var seed: String = "1234"
    @FocusState private var isFocused: Bool
    var body: some View {
            ZStack {
                Canvas { context, size in
                    
                    let mazeSize = CGFloat(mazeBackend.maze.count)
                    let cellSize = CGFloat(20)
                    let availableWidth = size.width - 40
                    let availableHeight = size.height - 40
                    
                    let worldWidth = mazeSize * cellSize
                    let worldHeight = mazeSize * cellSize
                    
                    let scaleX = availableWidth / worldWidth
                    let scaleY = availableHeight / worldHeight
                    let fitScale = min(scaleX, scaleY)
                    
                    
                    let remainingWidth = availableWidth - worldWidth * fitScale
                    let remainingHeight = availableHeight - worldHeight * fitScale
                    
                    context.translateBy(x: remainingWidth / 2, y: remainingHeight / 2)
                    
                    context.scaleBy(x: fitScale, y: fitScale)
                    
                    var playerPath: Path = Path()
                    var playerPosition = mazeBackend.playerPos
                    
                    playerPath.addRect(CGRect(origin: CGPoint(x: playerPosition.x * 20, y: playerPosition.y * 20), size: CGSize(width: 10, height: 10)))
                    var mazeDraw: MazeWallsShape = MazeWallsShape(maze: mazeBackend.maze, cellSize: cellSize)
                    
                    var path = mazeDraw.path(in: CGRect(origin: .zero, size: CGSize(width: worldWidth, height: worldHeight)))
                    
                    for row in mazeBackend.maze {
                        for node in row  {
                            if(node.letter >= 0){
                                context.fill(Path(CGRect(x: node.pos.x * 20, y: node.pos.y * 20, width: 10, height: 10)), with: .color(.red))
                            }
                        }
                    }
                    
                    // 3. Render the full path onto the canvas context
                    context.stroke(
                        path,
                        with: .color(.black.opacity(0.4)),
                        lineWidth: 0.5
                    )
                    
                    
                    let rectangle = CGRect(x: playerPosition.x * 20, y: playerPosition.y * 20, width: 10, height: 10)
                    context.fill(Path(rectangle), with: .color(.blue))
                }
                .background(Color(.systemGray))
                .focusable()
                .focused($isFocused)
                .onAppear {
                    isFocused = true
                }
                .onKeyPress(.rightArrow) {
                    mazeBackend.move(dir: .east)
                    print("Moving left")
                    return .handled
                }
                .onKeyPress(.leftArrow) {
                    mazeBackend.move(dir: .west)
                    return .handled
                }
                .onKeyPress(.upArrow) {
                    mazeBackend.move(dir: .north)
                    return .handled
                }
                .onKeyPress(.downArrow) {
                    mazeBackend.move(dir: .south)
                    return .handled
                }
                VStack{
                    Text(mazeBackend.lettersFound.map { String($0)}.joined(separator: " ")).frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
                .frame(alignment: .top)
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
                        TextField("Enter seed", text: $seed)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            mazeBackend.reset(seed: Int(seed) ?? 1234)
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
