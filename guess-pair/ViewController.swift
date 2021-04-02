//
//  ViewController.swift
//  guess-pair
//
//  Created by Nguyen Anh Tuan on 4/1/21.
//  Copyright © 2021 BVU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameEventListener,
    UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var lbMode: UILabel!
    @IBOutlet weak var lbScores: UILabel!
    @IBOutlet weak var lbCountDown: UILabel!
    
    @IBOutlet weak var btnStart: RoundedButton!
    @IBOutlet weak var btnReStart: RoundedButton!
    
    @IBOutlet weak var btnEasy: RoundedButton!
    @IBOutlet weak var btnMedium: RoundedButton!
    @IBOutlet weak var btnHard: RoundedButton!
    
    @IBOutlet weak var tbAnimals: UITableView!
    
    var game: Game!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  delegate & datasource was set in Main.Storyboard
        
        game = Game(eventListener: self, mode: GameMode.Easy)
        btnReStart.disable()
        btnEasy.sendActions(for: .touchUpInside)
    }
    
    
    
    
    func getImageAt(row: Int, col: Int) -> UIImage {
        do {
            return UIImage(data: try Data(contentsOf: game.actualData[4 * row + col].imageURL))!
        }
        catch let err as NSError {
            print("error when setting image [getImageAt]...")
            print(err)
            return getHiddenImage()
        }
    }
    
    func getAnimalAt(row: Int, col: Int) -> Animal {
        return game.actualData[4 * row + col]
    }
    
    func getCellAt(indexPath: IndexPath) -> AnimalCell {
        return tbAnimals.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalCell
    }
    
    func getHiddenImage() -> UIImage {
        return UIImage(named: "question-mark")!
    }
    
    func disableGameModeButtons() {
        btnEasy.disable()
        btnMedium.disable()
        btnHard.disable()
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.animalsLimited / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCellAt(indexPath: indexPath)
        cell.selectionStyle = .none
        
        
        //  current row index
        let theIndex = indexPath.row
        
        
        for i in 0..<4 {
            cell.columns[i].isHidden = false
            cell.columns[i].isEnabled = !game.isNotStarted
            
            
            //  set image based-on the game is started or not
            if !game.isNotStarted {
                cell.columns[i].toQuestion()
            }
            else {
                cell.columns[i].setImage(getImageAt(row: theIndex, col: i), for: .normal)
            }
            
            cell.columns[i].backgroundColor = .white
            cell.columns[i].animalName = getAnimalAt(row: theIndex, col: i).name
            cell.columns[i].rowIndex = theIndex  //  set the button's inside which row
            cell.columns[i].columnIndex = i  //  set the button's is which column
            
            
            cell.columns[i].addTarget(self, action: #selector(animalButtonClicked), for: .touchUpInside)    // add event listener
        }
        
        
        return cell
    }
    
    
    
    
    //  overriding
    func nextRound() {
        tbAnimals.reloadData()
        btnReStart.disable()
        
        
        //  start counting down
        var counter = game.animalsLimited
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.lbCountDown.text = "\(counter)"
            counter -= 1
            
            if (counter == -1) {
                timer.invalidate()
                
                self.btnReStart.enable()
                self.lbCountDown.text = "---"
                self.game.isNotStarted = false
                self.tbAnimals.reloadData()
            }
        }
    }
    
    func onGameStart() {
        disableGameModeButtons()
        btnReStart.enable()
        btnStart.disable()
        
        tbAnimals.reloadData()
    }
    
    func onGameReStart() {
        nextRound()
    }
    
    func onNextRound() {
        nextRound()
    }
    
    func onModeChanged(mode: String) {
        lbMode.text = "\(mode)"
    }
    
    func onScoreUpdated(scores: Int) {
        lbScores.text = "\(scores)"
    }
    
    func onFirstPredict(button: AnimalButton) {
        button.backgroundColor = .yellow
    }
    
    func onPredictSuccess(firstButton: AnimalButton, secondButton: AnimalButton) {
        firstButton.backgroundColor = .green
        secondButton.backgroundColor = .green
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            firstButton.backgroundColor = nil
            secondButton.backgroundColor = nil
            
            firstButton.setImage(nil, for: .normal)
            secondButton.setImage(nil, for: .normal)
        })
    }
    
    func onPredictFailed(firstButton: AnimalButton, secondButton: AnimalButton) {
        firstButton.backgroundColor = .red
        secondButton.backgroundColor = .red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            firstButton.backgroundColor = .white
            secondButton.backgroundColor = .white
            
            firstButton.setImage(self.getHiddenImage(), for: .normal)
            secondButton.setImage(self.getHiddenImage(), for: .normal)
        })
    }
    
    
    
    
    //  event handling functions...
    @objc func animalButtonClicked(_ sender: AnimalButton) {
        
        if (sender.isQuestion) {
            sender.setImage(getImageAt(row: sender.rowIndex, col: sender.columnIndex), for: .normal)
            game.predict(animalName: sender.animalName, button: sender)
        }
    }
    
    
    
    @IBAction func btnEasyClicked(_ sender: RoundedButton) {
        btnMedium.enable()
        btnHard.enable()
        
        sender.disable()
        game.mode = GameMode.Easy
        
        game.shuffleData()
        tbAnimals.reloadData()
    }
    
    @IBAction func btnMediumClicked(_ sender: RoundedButton) {
        btnEasy.enable()
        btnHard.enable()
        
        sender.disable()
        game.mode = GameMode.Medium
        
        game.shuffleData()
        tbAnimals.reloadData()
    }
    
    @IBAction func btnHardClicked(_ sender: RoundedButton) {
        btnEasy.enable()
        btnMedium.enable()
        
        sender.disable()
        game.mode = GameMode.Hard
        
        game.shuffleData()
        tbAnimals.reloadData()
    }
    
    
    
    @IBAction func btnStartClicked(_ sender: RoundedButton) {
        game.start()
    }
    
    @IBAction func btnReStartClicked(_ sender: RoundedButton) {
        game.restart()
    }
}

