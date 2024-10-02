//
//  Hades_TailsViewController.swift
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

import Foundation
import UIKit

class ArenaHadesTailsViewController: UIViewController {

    @IBOutlet weak var hadesTailsImg: UIImageView!
    @IBOutlet weak var haedsBtn: UIButton!
    @IBOutlet weak var tailsBtn: UIButton!
    @IBOutlet weak var totalCoin: UILabel!
    @IBOutlet weak var betCoin: UILabel!
    @IBOutlet weak var plusCoin: UIButton!
    @IBOutlet weak var minusCoin: UIButton!
    
    var haedsTailsImage = ["hades","tails"]
    var selectedOption: String?
    var currentBet = 0
    var coins = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHowToPlayAlert()
        totalCoin.text = "\(coins)"
        betCoin.text = "\(currentBet)"
        resetSelectionUI() // Reset button selection at the beginning
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func spinBtn(_ sender: UIButton) {
        guard let selected = selectedOption else {
            let alert = UIAlertController(title: "Error", message: "Please select Hades or Tails before spinning.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let result = haedsTailsImage.randomElement()!
        
        UIView.transition(with: hadesTailsImg, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.hadesTailsImg.image = UIImage(named: result)
        }, completion: { _ in
            self.checkResult(spinResult: result, userChoice: selected)
        })
    }
    
    @IBAction func selectHadesTailsBtn(_ sender: UIButton) {
        resetSelectionUI()
        
        if sender.tag == 0 {
            selectedOption = "hades"
            haedsBtn.layer.borderWidth = 2
            haedsBtn.layer.borderColor = UIColor.white.cgColor
            print("Hades Selected")
        } else if sender.tag == 1 {
            selectedOption = "tails"
            tailsBtn.layer.borderWidth = 2
            tailsBtn.layer.borderColor = UIColor.white.cgColor
            print("Tails Selected")
        }
    }
    
    @IBAction func plusMinusCoin(_ sender: UIButton) {
        if sender.tag == 0 && currentBet + 50 <= coins {
            currentBet += 50
        } else if sender.tag == 1 && currentBet - 50 >= 0 {
            currentBet -= 50
        }
        betCoin.text = "\(currentBet)"
    }
    
    func checkResult(spinResult: String, userChoice: String) {
        if spinResult == userChoice {
            coins += currentBet * 2
            showAlert(title: "You Win!", message: "You won \(currentBet * 2) coins!")
        } else {
            coins -= currentBet
            showAlert(title: "You Lose!", message: "You lost \(currentBet) coins.")
        }
        
        totalCoin.text = "\(coins)"
        
        if coins <= 0 {
            showGameOverAlert()
        }
    }
    
    func resetSelectionUI() {
        haedsBtn.layer.borderWidth = 0
        haedsBtn.backgroundColor = UIColor.clear
        tailsBtn.layer.borderWidth = 0
        tailsBtn.backgroundColor = UIColor.clear
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Your coins are over! Restarting the game with 1000 coins.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.coins = 1000
            self.totalCoin.text = "\(self.coins)"
            self.currentBet = 0
            self.betCoin.text = "\(self.currentBet)"
            self.resetSelectionUI()
        }))
        present(alert, animated: true)
    }
    
    func showHowToPlayAlert() {
            let message = """
            Welcome to Hades & Tails!
            
            - Select either Hades or Tails.
            - Place your bet using the + and - buttons.
            - Tap the Spin button to spin the coin.
            - If the result matches your selection, you win double your bet!
            - If not, you lose your bet amount.
            - Keep spinning until your coins run out!
            """
            
            let alert = UIAlertController(title: "How to Play", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default))
            present(alert, animated: true)
        }
}
