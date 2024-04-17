//
//  GameScene.swift
//  Plane Turbulence
//
//  Created by Anton on 16/4/24.
//

import Foundation
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameId: String = UUID().uuidString
    
    var levelData: Level?
    
    var lastYPosition: CGFloat = 0
    
    private let obstacles = ["cloud_1", "cloud_2", "lighting"]
    
    var obstaclesTimer = Timer()
    var coinSpawnTimer = Timer()
    var gameTimer = Timer()
    
    var obstacleSpeed = 5.0
    
    var plane: SKSpriteNode!
    var restartGame: SKSpriteNode!
    var pauseBtn: SKSpriteNode!
    var immunityBtn: SKSpriteNode!
    
    var immunityLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var gameTimeLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    var gameTimePassed: Int = 0 {
        didSet {
            gameTimeLabel.text = "Time: \(gameTimePassed)"
        }
    }
    var immunityCount = UserDefaults.standard.integer(forKey: "immunity_count") {
        didSet {
            UserDefaults.standard.set(immunityCount, forKey: "immunity_count")
        }
    }
    var coins = UserDefaults.standard.integer(forKey: "coins") {
        didSet {
            UserDefaults.standard.set(coins, forKey: "coins")
            coinsLabel.text = "\(coins)"
        }
    }
    
    var immunityActive = false
    
    var needAddComplications = Bool.random()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = CGSize(width: 750, height: 1335)
        addBackground()
        createPlane()
        
        obstaclesTimer = .scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(spawnRandomObstacle), userInfo: nil, repeats: true)
        coinSpawnTimer = .scheduledTimer(timeInterval: 20, target: self, selector: #selector(spawnCoin), userInfo: nil, repeats: true)
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimeUp), userInfo: nil, repeats: true)
        
        makeRestartGameBtn()
        makePauseGameBtn()
        
        if let levelData = levelData {
            obstacleSpeed -= levelData.speedObstacles
            
            if needAddComplications {
                if levelData.resizePlane {
                    resizePlaneInRandomDifTime()
                }
            }
        }
        
        makeLevelLabel()
        makeTimerLabel()
        makeInvisibleRec()
        
        makeImmunityBtn()
        makeCoinsLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumeGame), name: Notification.Name("RESUME_GAME"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(obsrRestartGame), name: Notification.Name("RESTART_GAME"), object: nil)

    }
    
    @objc private func resumeGame() {
        isPaused = false
    }    
    
    @objc private func obsrRestartGame() {
        restartGameScene()
    }
    
    private func resizePlaneInRandomDifTime() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int.random(in: 5..<10))) {
            let action = SKAction.resize(toWidth: self.plane.size.width * 1.3, height: self.plane.size.width * 1.3, duration: 0.5)
            let actionWait = SKAction.wait(forDuration: 5)
            let action3 = SKAction.resize(toWidth: self.plane.size.width / 1.3, height: self.plane.size.width / 1.3, duration: 0.5)
            let actionWait2 = SKAction.wait(forDuration: 3)
            let actionSequince = SKAction.sequence([action, actionWait, action3, actionWait2])
            let repeateActions = SKAction.repeat(actionSequince, count: 3)
            self.plane.run(repeateActions)
        }
    }
    
    private func makeCoinsLabel() {
        let coinsBack = SKSpriteNode(imageNamed: "level_back")
        coinsBack.position = CGPoint(x: size.width / 2, y: 75)
        coinsBack.size = CGSize(width: 400, height: 95)
        addChild(coinsBack)
        
        coinsLabel = SKLabelNode(text: "\(coins)")
        coinsLabel.position = CGPoint(x: size.width / 2, y: 55)
        coinsLabel.fontName = "ZenAntique-Regular"
        coinsLabel.fontSize = 52
        addChild(coinsLabel)
        
        let coinNode = SKSpriteNode(imageNamed: "coin")
        coinNode.position = CGPoint(x: size.width / 2 + 80, y: 75)
        coinNode.size = CGSize(width: 52, height: 52)
        addChild(coinNode)
    }
    
    private func makeImmunityBtn() {
        immunityBtn = SKSpriteNode(imageNamed: "immunity_btn")
        immunityBtn.position = CGPoint(x: size.width - 70, y: 80)
        immunityBtn.size = CGSize(width: 100, height: 85)
        addChild(immunityBtn)
        
        immunityLabel = SKLabelNode(text: "x\(immunityCount)")
        immunityLabel.position = CGPoint(x: size.width - 110, y: 30)
        immunityLabel.fontName = "ZenAntique-Regular"
        immunityLabel.fontSize = 28
        addChild(immunityLabel)
    }
    
    @objc private func gameTimeUp() {
        if !isPaused {
            gameTimePassed += 1
            if gameTimePassed == levelData?.time {
                // game win
                gameOver()
                addSoundEffect(fileName: "win")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: Notification.Name("GAME_WIN"), object: nil, userInfo: ["gameId": self.gameId])
                }
            }
        }
    }
    
    private func gameOver() {
        gameTimer.invalidate()
        obstaclesTimer.invalidate()
        coinSpawnTimer.invalidate()
    }
    
    private func makeRestartGameBtn() {
        restartGame = SKSpriteNode(imageNamed: "ic_restart")
        restartGame.position = CGPoint(x: size.width - 70, y: size.height - 80)
        restartGame.size = CGSize(width: 100, height: 85)
        addChild(restartGame)
    }
    
    private func makePauseGameBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "ic_pause")
        pauseBtn.position = CGPoint(x: 70, y: size.height - 80)
        pauseBtn.size = CGSize(width: 100, height: 85)
        addChild(pauseBtn)
    }
    
    private func makeLevelLabel() {
        let levelBack = SKSpriteNode(imageNamed: "level_back")
        levelBack.position = CGPoint(x: size.width / 2, y: size.height - 140)
        levelBack.size = CGSize(width: 400, height: 95)
        addChild(levelBack)
        
        levelLabel = SKLabelNode(text: "Level \(levelData?.level ?? 1)")
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 160)
        levelLabel.fontName = "ZenAntique-Regular"
        levelLabel.fontSize = 52
        addChild(levelLabel)
    }
    
    private func makeTimerLabel() {
        let timeBack = SKSpriteNode(imageNamed: "level_back")
        timeBack.position = CGPoint(x: size.width / 2, y: size.height - 240)
        timeBack.size = CGSize(width: 250, height: 75)
        addChild(timeBack)
        
        gameTimeLabel = SKLabelNode(text: "Time: \(gameTimePassed)")
        gameTimeLabel.position = CGPoint(x: size.width / 2, y: size.height - 255)
        gameTimeLabel.fontName = "ZenAntique-Regular"
        gameTimeLabel.fontSize = 36
        addChild(gameTimeLabel)
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "game_bg")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
    }
    
    private func createPlane() {
        plane = SKSpriteNode(imageNamed: "plane")
        plane.position = CGPoint(x: 150, y: size.height / 2)
        plane.size = CGSize(width: 150, height: 80)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.isDynamic = false
        plane.physicsBody?.categoryBitMask = GameBitMasks.plane
        plane.physicsBody?.contactTestBitMask = GameBitMasks.obstacle | GameBitMasks.coin
        plane.physicsBody?.collisionBitMask = GameBitMasks.obstacle | GameBitMasks.coin
        addChild(plane)
        
        addMusic(to: plane, fileName: "plane")
    }
    
    private func makeInvisibleRec() {
        let invisibleRectangle = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 10))
        invisibleRectangle.position = CGPoint(x: self.size.width / 2, y: 0)
        invisibleRectangle.name = "bounds1"
        invisibleRectangle.physicsBody = SKPhysicsBody(rectangleOf: invisibleRectangle.size)
        invisibleRectangle.physicsBody?.isDynamic = false
        invisibleRectangle.physicsBody?.affectedByGravity = false
        invisibleRectangle.physicsBody?.categoryBitMask = GameBitMasks.invisibleRec
        invisibleRectangle.physicsBody?.contactTestBitMask = GameBitMasks.obstacle | GameBitMasks.coin
        invisibleRectangle.physicsBody?.collisionBitMask = GameBitMasks.obstacle | GameBitMasks.coin
        addChild(invisibleRectangle)
    }
    
    private func addMusic(to background: SKNode, fileName: String) {
        if UserDefaults.standard.bool(forKey: "is_music_on") {
            let music = SKAudioNode(fileNamed: fileName)
            background.addChild(music)
        }
    }
    
    private func addSoundEffect(fileName: String) {
        if UserDefaults.standard.bool(forKey: "is_sounds_on") {
            let soundAction = SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
            run(soundAction)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let currentYPosition = location.y
        let deltaY = currentYPosition - lastYPosition
        
        if deltaY > 0 {
            let action = SKAction.rotate(toAngle: 0.5, duration: 0.2)
            let moveToDown = SKAction.move(to: CGPoint(x: plane.position.x, y: location.y - 0.5), duration: 0.1)
            let actionRepeate = SKAction.repeatForever(moveToDown)
            let sequince = SKAction.sequence([action, actionRepeate])
            plane.run(sequince)
        } else if deltaY < 0 {
            let action = SKAction.rotate(toAngle: -0.5, duration: 0.2)
            let moveToDown = SKAction.move(to: CGPoint(x: plane.position.x, y: location.y - 0.5), duration: 0.1)
            let actionRepeate = SKAction.repeatForever(moveToDown)
            let sequince = SKAction.sequence([action, actionRepeate])
            plane.run(sequince)
        }
        
        lastYPosition = currentYPosition
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        
        guard !object.contains(restartGame) else {
            restartGameScene()
            return
        }
        
        guard !object.contains(pauseBtn) else {
            pauseGame()
            return
        }
        
        guard !object.contains(immunityBtn) else {
            immunityActivateIfAvailable()
            return
        }
    }
    
    private func immunityActivateIfAvailable() {
        if immunityCount > 0 {
            immunityActive = true
            immunityCount -= 1
            
            let actionFadeOut = SKAction.fadeOut(withDuration: 0.2)
            let actionFadeIn = SKAction.fadeIn(withDuration: 0.2)
            let actionSequince = SKAction.sequence([actionFadeOut, actionFadeIn])
            let actionRepeate = SKAction.repeat(actionSequince, count: 15)
            plane.run(actionRepeate)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                self.immunityActive = false
            }
        }
    }
    
    private func pauseGame() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("PAUSE_GAME"), object: nil, userInfo: nil)
    }
    
    private func restartGameScene() {
        let newScene = GameScene()
        newScene.levelData = self.levelData
        newScene.size = CGSize(width: 750, height: 1335)
        newScene.scaleMode = .fill
        view?.presentScene(newScene)
    }
    
    @objc private func spawnRandomObstacle() {
        if !isPaused {
            let obstacleNode = SKSpriteNode(imageNamed: obstacles.randomElement() ?? "cloud_1")
            let randomPosYRange = (Int(size.height) / 2 - 300)...(Int(size.height) / 2 + 300)
            obstacleNode.name = "obstacle"
            obstacleNode.position = CGPoint(x: size.width, y: CGFloat(Int.random(in: randomPosYRange)))
            obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: obstacleNode.size)
            obstacleNode.physicsBody?.affectedByGravity = false
            obstacleNode.physicsBody?.isDynamic = true
            obstacleNode.physicsBody?.categoryBitMask = GameBitMasks.obstacle
            obstacleNode.physicsBody?.contactTestBitMask = GameBitMasks.plane
            obstacleNode.physicsBody?.collisionBitMask = GameBitMasks.plane
            addChild(obstacleNode)
            
            let action = SKAction.move(to: CGPoint(x: -100, y: obstacleNode.position.y), duration: obstacleSpeed)
            obstacleNode.run(action)
        }
    }
    
    @objc private func spawnCoin() {
        if !isPaused {
            let obstacleNode = SKSpriteNode(imageNamed: "coin")
            let randomPosYRange = (Int(size.height) / 2 - 300)...(Int(size.height) / 2 + 300)
            obstacleNode.name = "obstacle"
            obstacleNode.position = CGPoint(x: size.width, y: CGFloat(Int.random(in: randomPosYRange)))
            obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: obstacleNode.size)
            obstacleNode.physicsBody?.affectedByGravity = false
            obstacleNode.physicsBody?.isDynamic = true
            obstacleNode.physicsBody?.categoryBitMask = GameBitMasks.coin
            obstacleNode.physicsBody?.contactTestBitMask = GameBitMasks.plane
            obstacleNode.physicsBody?.collisionBitMask = GameBitMasks.plane
            addChild(obstacleNode)
            
            let action = SKAction.move(to: CGPoint(x: -100, y: obstacleNode.position.y), duration: obstacleSpeed)
            obstacleNode.run(action)
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA
        let nodeB = contact.bodyB
        
        if (nodeA.categoryBitMask == GameBitMasks.obstacle && nodeB.categoryBitMask == GameBitMasks.invisibleRec) ||
           (nodeA.categoryBitMask == GameBitMasks.coin && nodeB.categoryBitMask == GameBitMasks.invisibleRec) {
            if nodeA.categoryBitMask == GameBitMasks.obstacle || nodeA.categoryBitMask == GameBitMasks.coin {
                collisionObstacleOrCoin(object: nodeA.node!, rec: nodeB.node!)
            } else {
                collisionObstacleOrCoin(object: nodeB.node!, rec: nodeA.node!)
            }
        }
        
        if !immunityActive {
            if nodeA.categoryBitMask == GameBitMasks.plane && nodeB.categoryBitMask == GameBitMasks.obstacle {
                nodeA.node?.removeFromParent()
                gameOver()
                addSoundEffect(fileName: "lose")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: Notification.Name("GAME_LOSE"), object: nil, userInfo: ["gameId": self.gameId])
                }
            }
        }
        
        if nodeA.categoryBitMask == GameBitMasks.plane && nodeB.categoryBitMask == GameBitMasks.coin {
            nodeB.node?.removeFromParent()
            coins += 1
        }
            
    }
    
    private func collisionObstacleOrCoin(object: SKNode, rec: SKNode) {
        object.removeFromParent()
    }
    
    struct GameBitMasks {
        static let coin: UInt32 = 0x01
        static let obstacle: UInt32 = 0x1001
        static let plane: UInt32 = 0x10100
        static let invisibleRec: UInt32 = 0x1001
    }
    
}


#Preview {
    VStack {
        SpriteView(scene: GameScene())
            .ignoresSafeArea()
    }
}
