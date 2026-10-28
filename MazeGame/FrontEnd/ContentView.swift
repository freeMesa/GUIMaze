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


struct StaticDetailView: View {
    @State private var volume = 0.5
    @State private var showSlider = false
    var body: some View {
        ScrollView{
            VStack {
                Canvas { context, size in
                    let gridSpacing: CGFloat = 30.0
                    var path = Path()
                    // 1. Draw Vertical Lines
                    for x in stride(from: 0, through: size.width, by: gridSpacing) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }
                    
                    // 2. Draw Horizontal Lines
                    for y in stride(from: 0, through: size.height, by: gridSpacing) {
                        path.move(to: CGPoint(x: 0, y: y)) // Note: Ensure x is 0, y is y
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }
                    
                    // 3. Render the full path onto the canvas context
                    context.stroke(
                        path,
                        with: .color(.black.opacity(0.4)),
                        lineWidth: 1.0
                    )
                }
                .containerRelativeFrame(.horizontal)
                .containerRelativeFrame(.vertical)
                .background(Color(.systemGray))
                
                
            }
            .containerRelativeFrame(.horizontal)
            .containerRelativeFrame(.vertical)
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
