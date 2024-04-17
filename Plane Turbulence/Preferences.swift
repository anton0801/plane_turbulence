//
//  Preferences.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import Foundation

class Preferences: ObservableObject {
    
    @Published var immunityCount = UserDefaults.standard.integer(forKey: "immunity_count") {
        didSet {
            UserDefaults.standard.set(immunityCount, forKey: "immunity_count")
        }
    }
    
    @Published var coins = UserDefaults.standard.integer(forKey: "coins") {
        didSet {
            UserDefaults.standard.set(coins, forKey: "coins")
        }
    }
    
    @Published var unlockedLevels: [String] = []
    
    var allCollections = [
        "collection_1",
        "collection_2",
        "collection_3",
        "collection_4"
    ]
    @Published var unlockedCollections: [String] = []
    
    init() {
        let unlocked = UserDefaults.standard.string(forKey: "unlocked_levels") ?? "level_1,"
        let components = unlocked.components(separatedBy: ",")
        for level in components {
            unlockedLevels.append(level)
        }
        if unlockedLevels.isEmpty {
            unlockedLevels.append("level_1")
        }
        
        let unlockedCollection = UserDefaults.standard.string(forKey: "unlockedCollections") ?? ""
        let componentsCollections = unlockedCollection.components(separatedBy: ",")
        for level in componentsCollections {
            unlockedCollections.append(level)
        }
    }
    
    func unlockNextCollection() {
        var collectionToUnlock = ""
        if unlockedCollections.isEmpty {
            collectionToUnlock = "collection_1"
        } else {
            let lastUnlockedCollection = unlockedCollections[unlockedCollections.count - 1]
            let collectionInt = Int(lastUnlockedCollection.components(separatedBy: "_")[1])
            collectionToUnlock = "collection_\(collectionInt)"
        }
        unlockedCollections.append(collectionToUnlock)
        UserDefaults.standard.set(unlockedCollections.joined(separator: ","), forKey: "unlockedCollections")
    }
    
    func buyImminity() -> Bool {
        if coins > 15 {
            immunityCount += 1
            coins -= 15
            return true
        }
        return false
    }
    
    func unlockNextLevel(currentLevel: String) {
        let levelNum = Int(currentLevel.components(separatedBy: "_")[1])!
        let nextLevelNum = levelNum + 1
        if nextLevelNum < levels.count {
            unlockedLevels.append("level_\(nextLevelNum)")
            UserDefaults.standard.set(unlockedLevels.joined(separator: ","), forKey: "unlocked_levels")
        }
    }
    
}
