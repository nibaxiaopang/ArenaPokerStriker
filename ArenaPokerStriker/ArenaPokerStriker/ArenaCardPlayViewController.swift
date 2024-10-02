//
//  CardPlayViewController.swift
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

import Foundation
import UIKit
import Adjust

class ArenaCardPlayViewController: UIViewController {

    @IBOutlet var teamBCard: [UIImageView]!
    @IBOutlet var teamCCard: [UIImageView]!
    
    @IBOutlet weak var teamBCardShow: UIImageView!
    @IBOutlet weak var teamCCardShow: UIImageView!
    
    @IBOutlet weak var insertBtn: UIButton!
    @IBOutlet weak var showbtn: UIButton!
    
    var teamBHand = [String]()
    var teamCHand = [String]()
    
    var teamBWins = 0
    var teamCWins = 0
    
    var roundIndex = 0
    
    var isEnebled = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        howToPlay()
        resetCards()
        showbtn.isEnabled = false
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func inserBtn(_ sender: UIButton) {
       
        let shuffledCards = cardImagesArray.shuffled()
        
        teamBHand = Array(shuffledCards.dropFirst(5).prefix(5))
        teamCHand = Array(shuffledCards.dropFirst(10).prefix(5))
        
        for i in 0..<5 {
            teamBCard[i].image = UIImage(named: "rotateBackCard")
            teamCCard[i].image = UIImage(named: "rotateBackCard.png")
        }
        resetCards()
        roundIndex = 0
        teamBWins = 0
        teamCWins = 0
        
       
        isEnebled = true
        buttonEnebled()
    }
    
    @IBAction func showBtn(_ sender: UIButton) {
        Adjust.trackEvent(ADJEvent(eventToken: "sfadgags"))
        
        guard roundIndex < 5 else {
           
            declareWinner()
            return
        }
       
        teamBCardShow.image = UIImage(named: teamBHand[roundIndex])
        teamCCardShow.image = UIImage(named: teamCHand[roundIndex])
        
        teamBCard[roundIndex].isHidden = true
        teamCCard[roundIndex].isHidden = true
        
       
        let bCard = cardImagesArray.firstIndex(of: teamBHand[roundIndex]) ?? 0
        let cCard = cardImagesArray.firstIndex(of: teamCHand[roundIndex]) ?? 0
        
        if bCard > cCard {
            teamBWins += 1
        } else{
            teamCWins += 1
        }
        
        roundIndex += 1
        
        if roundIndex == 5 {
            declareWinner()
        } else {
            isEnebled = true
        }
        
        buttonEnebled()
    }
    
    func declareWinner() {
        var winnerMessage = ""
        
         if teamBWins > teamCWins {
            winnerMessage = "PLAYER 1 Wins!"
        } else if teamCWins > teamBWins {
            winnerMessage = "PLAYER 2 Wins!"
        } else {
            winnerMessage = "It's a Tie!"
        }
        
       
        let alert = UIAlertController(title: "Game Over", message: winnerMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Re play", style: .default, handler: { [self] _ in
          
            inserBtn(UIButton())
        }))
        present(alert, animated: true, completion: nil)
        
        isEnebled = false
        buttonEnebled()
    }
    
    func resetCards() {

        for i in 0..<5 {
            teamBCard[i].image = UIImage(named: "rotateBackCard.png")
            teamCCard[i].image = UIImage(named: "rotateBackCard.png")
    
            teamBCard[i].isHidden = false
            teamCCard[i].isHidden = false
        }
    }
    
    func buttonEnebled() {
        if isEnebled {
            insertBtn.isEnabled = false
            showbtn.isEnabled = true
        } else {
            insertBtn.isEnabled = true
            showbtn.isEnabled = false
        }
    }
    
    func howToPlay(){
        
        let rules = """
        1.    Choose a card and click Shuffle.
        2.    Click Show to reveal all players’ cards.
        3.    The highest card wins the round.
        4.    Play 5 rounds—the player who wins the most rounds is the winner.
        
        Good luck and enjoy Poker Knights Elite!
    """
        let alert = UIAlertController(title: "How to play", message: rules, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Let's play", style: UIAlertAction.Style.cancel))
        present(alert, animated: true)
    }
}
