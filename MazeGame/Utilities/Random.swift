//
//  Random.swift
//  MazeGame
//
//  Created by Kaid Malone on 10/29/26.
//

import Foundation

struct SeededRandomGenerator: RandomNumberGenerator {
    var state: UInt64

    init(seed: Int) {
        // A seed of 0 can stall some generators fallback to a default
        let bitPatternSeed = UInt64(bitPattern: Int64(seed))
        self.state = bitPatternSeed == 0 ? 5489 : bitPatternSeed
    }

    /// Mutates the state and returns the next uniform pseudo-random UInt64
    mutating func next() -> UInt64 {
        // Knuth's MMIX LCG parameters
        // &+ and &* are wrap around operations which implicitly enforce mod 64
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
    
}
