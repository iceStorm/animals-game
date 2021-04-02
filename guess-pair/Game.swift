//
//  Game.swift
//  guess-pair
//
//  Created by Nguyen Anh Tuan on 4/1/21.
//  Copyright © 2021 BVU. All rights reserved.
//

import Foundation

protocol GameEventListener {
    func onGameStart()
    func onGameReStart()
    func onNextRound()
    
    func onScoreUpdated(scores: Int)
    func onModeChanged(mode: String)
    
    func onFirstPredict(button: AnimalButton)
    func onPredictSuccess(firstButton: AnimalButton, secondButton: AnimalButton)
    func onPredictFailed(firstButton: AnimalButton, secondButton: AnimalButton)
}

enum GameMode: String {
    case Easy = "Easy";
    case Medium = "Medium";
    case Hard = "Hard";
}


class Game {
    private var eventListener: GameEventListener
    private var lastAnimalName: String
    private var clickedCount: Int
    private var firstSelectedButton: AnimalButton!
    private var rootDataSource = [Animal]()
    public var actualData: [Animal]!
    public var isNotStarted = true
    
    private var scores = 0 {
        didSet {
            eventListener.onScoreUpdated(scores: scores)
        }
    }
    
    public var mode: GameMode {
        didSet {
            eventListener.onModeChanged(mode: mode.rawValue)
        }
    }
    
    private var totalSuccess = 0 {
        didSet {
            if totalSuccess == animalsLimited {
                print("next game...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.clickedCount = 0
                    self.totalSuccess = 0
                    self.lastAnimalName = ""
                    self.isNotStarted = true
                    self.shuffleData()
                    self.eventListener.onNextRound()
                })
            }
        }
    }
    
    public var animalsLimited: Int {
        get {
            return mode == GameMode.Easy ? 4 : mode == GameMode.Medium ? 6 : 12
        }
    }
    
    
    
    init(eventListener: GameEventListener, mode: GameMode) {
        self.eventListener = eventListener
        self.mode = mode
        
        lastAnimalName = ""
        clickedCount = 0
        
        loadGameData()
    }
    
    
    public func start() {
        isNotStarted = false
        eventListener.onGameStart()
    }
    
    public func restart() {
        isNotStarted = true
        clickedCount = 0
        lastAnimalName = ""
        shuffleData()
        eventListener.onGameReStart()
    }
    
    public func predict(animalName: String, button: AnimalButton) {
        clickedCount += 1
        
        
        if (clickedCount == 1) {
            lastAnimalName = animalName
            firstSelectedButton = button
            eventListener.onFirstPredict(button: button)
            return
        }
        
        
        //  clickedCount == 2
        //  reset
        clickedCount = 0
        
        
        if (lastAnimalName == animalName) {
            scores += 10
            totalSuccess += 1
            
            eventListener.onPredictSuccess(firstButton: firstSelectedButton, secondButton: button)
            return
        }
        
        
        scores -= 5
        eventListener.onPredictFailed(firstButton: firstSelectedButton, secondButton: button)
    }
    
    
    
    private func loadGameData() {
        let fm = FileManager.default
        let url = URL(fileURLWithPath: Bundle.main.resourcePath! + "/GameData")
        let keys = [
            URLResourceKey.localizedNameKey,
            URLResourceKey.creationDateKey,
            URLResourceKey.localizedTypeDescriptionKey
        ]
        
        
        do {
            //  container folder : contains animal name folders
            let containerFolder = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: .skipsHiddenFiles)
            
            
            //  loop through each animal name folder
            for item in containerFolder {
                
                //  files inside the animal folder (.png, .mp3)
                let files = try fm.contentsOfDirectory(at: item, includingPropertiesForKeys: keys, options: .skipsHiddenFiles)
                
                
                
                let animal = Animal(
                    name: String(files[0].lastPathComponent.split(separator: ".")[0]),
                    imageURL: files[0],
                    soundURL: files.count >= 2 ? files[1] : nil
                )
                
                
                rootDataSource.append(animal)
            }
        }
        catch let error as NSError {
            print("error inside loadGameData...")
            print(error)
        }
    }
    
    
    public func shuffleData() {
        actualData = [Animal]()
        
        
        //  shuffled animal from the source -- equal to randomizing
        let tempShuffled = rootDataSource.shuffled()
        
        
        //  creating double animals in a list
        for i in 0..<animalsLimited {
            actualData.append(tempShuffled[i])
            actualData.append(tempShuffled[i])
        }
        
        
        //  shuffling the data to get randomized animal on the board
        actualData = actualData.shuffled()
    }
    
}
