//
//  Hades_TailsViewController.swift
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

import Foundation
import UIKit
import Adjust

class ArenaHadesTailsViewController: UIViewController {

    @IBOutlet weak var hadesTailsImg: UIImageView!
    @IBOutlet weak var haedsBtn: UIButton!
    @IBOutlet weak var tailsBtn: UIButton!
    
    var haedsTailsImage = ["hades","tails"]
    var selectedOption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHowToPlayAlert()
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

    
    func checkResult(spinResult: String, userChoice: String) {
        if spinResult == userChoice {
            showAlert(title: "You Win!", message: "Lucky moment today")
            
            Adjust.trackEvent(ADJEvent.init(eventToken: "hdkshkhsk"))
        } else {
            showAlert(title: "You Lose!", message: "No luck, you can try again")
            Adjust.trackEvent(ADJEvent.init(eventToken: "hdkshkhsds"))
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
    
    func showHowToPlayAlert() {
            let message = """
            Welcome to Hades & Tails!
            
            - Select either Hades or Tails.
            - Tap the Spin button to start.
            - If the result matches your selection, you win and luck day!
            - If not, you lose.
            """
            
            let alert = UIAlertController(title: "How to Play", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default))
            present(alert, animated: true)
        }
}
