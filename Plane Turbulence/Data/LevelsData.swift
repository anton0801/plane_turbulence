//
//  LevelsData.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import Foundation

struct Level {
    var name: String
    var level: Int
    var speedObstacles: Double
    var time: Int
    var resizePlane: Bool
}

// MARK: To do add shtorm

let levelsCount = 24
var levels = [Level]()

func createLevels() {
    for i in 1...levelsCount {
        let levelData = Level(name: "level_\(i)", level: i, speedObstacles: 1 + (0.1 * Double(i)), time: 15 + (5 * i), resizePlane: i >= 5)
        levels.append(levelData)
    }
}
