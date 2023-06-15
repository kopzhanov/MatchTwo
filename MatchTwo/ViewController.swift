//
//  ViewController.swift
//  MatchTwo
//
//  Created by Alikhan Kopzhanov on 31.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    
    var moves = 0
    var count = 0
    var time = 0
    var guessedCorrect = 0
    var button1 = UIButton()
    var button2 = UIButton()
    var timer = Timer()
    var pauseTimer = false
    var images = ["?": 0,"starboy" : 0,"without_warning" : 0,"b&b":0,"astroworld":0,"xx":0,"2004":0,"nobody_is_listening":0]
    var imageSet:[UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        newGame()
        // Do any additional setup after loading the view.
    }
    
    @objc func timerUpdate(){
        if !pauseTimer{
            time += 1
        } else {
            return
        }
        label.text = timeToString(time)
    }

    @IBAction func game(_ sender: UIButton) {
        sender.setBackgroundImage(imageSet[sender.tag-1], for: .normal)
        switch count{
        case 0:
            button1 = sender
            count += 1
        case 1:
            button2 = sender
            view.isUserInteractionEnabled = false
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(checkImages), userInfo: nil, repeats: false)
            count = 0
        default: return
        }
    }
    
    @objc func checkImages(){
        if button1.currentBackgroundImage == button2.currentBackgroundImage{
            button1.isEnabled = false
            button2.isEnabled = false
            button1.alpha = 0.75
            button2.alpha = 0.75
            guessedCorrect += 1
        } else {
            button1.setBackgroundImage(UIImage(named: "square"), for: .normal)
            button2.setBackgroundImage(UIImage(named: "square"), for: .normal)
        }
        moves += 1
        movesLabel.text = "Moves: \(moves)"
        view.isUserInteractionEnabled = true
        if guessedCorrect == 8{
            pauseTimer = true
            guessedCorrect = 0
            let alert = UIAlertController(title: "You won", message: "Time: \(timeToString(time)), Moves: \(moves)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.newGame()}))
            present(alert, animated: true)
        }
    }
    
    func newGame(){
        moves = 0
        movesLabel.text = "Moves: \(moves)"
        pauseTimer = false
        time = 0
        imageSet = []
        for tag in 1...16{
            let button = view.viewWithTag(tag) as! UIButton
            button.setBackgroundImage(UIImage(named: "square"), for: .normal)
            button.alpha = 1
            button.isEnabled = true
        }
        startGame()
    }
    
    func startGame(){
        var images1 = images
        for _ in 0...15{
            guard let randomImage = images1.randomElement()?.key else { return }
            imageSet.append(UIImage(named: randomImage)!)
            images1[randomImage]! += 1
            if images1[randomImage] == 2{
                images1[randomImage] = nil
            }
        }
    }
    
    func timeToString (_ intTime: Int) -> String{
        let seconds = intTime % 60
        let minutes = (intTime / 60) % 60
        let hours = intTime / 3600
        
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}

