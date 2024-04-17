//
//  GameView.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @State var gameId: String = ""
    
    var level: Level
    
    @EnvironmentObject var preferences: Preferences
    
    @State var gameLose = false
    @State var gameWin = false
    @State var gamePaused = false
    @State var restartGame = false
    
    private var gameScene: GameScene {
        get {
            let scene = GameScene()
            scene.levelData = level
            return scene
        }
    }
    
    var body: some View {
        ZStack {
            if gamePaused {
                PausedGameView(pausedGame: $gamePaused)
                    .zIndex(2)
            } else if gameWin {
                GameWinView(restartGame: $restartGame)
                    .zIndex(2)
            } else if gameLose {
                GameLoseView(restartGame: $restartGame)
                    .zIndex(2)
            }
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .zIndex(1)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_WIN"))) { notification in
            if let gameId = notification.userInfo?["gameId"] as? String {
                    if gameId != self.gameId {
                        self.gameId = gameId
                        preferences.unlockNextLevel(currentLevel: level.name)
                        preferences.coins += 10
                        if level.level % 6 == 0 {
                            preferences.unlockNextCollection()
                        }
                        withAnimation {
                            gameWin = true
                        }
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_LOSE"))) { notification in
            if let gameId = notification.userInfo?["gameId"] as? String {
                    if gameId != self.gameId {
                        self.gameId = gameId
                        withAnimation {
                            gameLose = true
                        }
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PAUSE_GAME"))) { notification in
            self.gameId = gameId
            withAnimation {
                gamePaused = true
            }
        }
        .onChange(of: gamePaused) { _ in
            if !gamePaused {
                NotificationCenter.default.post(name: Notification.Name("RESUME_GAME"), object: nil, userInfo: nil)
            }
        }
        .onChange(of: restartGame) { _ in
            if restartGame {
                NotificationCenter.default.post(name: Notification.Name("RESTART_GAME"), object: nil, userInfo: nil)
                gameWin = false
                gameLose = false
                restartGame = false
            }
        }
    }
}

#Preview {
    GameView(level: Level(name: "level_1", level: 1, speedObstacles: 0, time: 15, resizePlane: false))
        .environmentObject(Preferences())
}
