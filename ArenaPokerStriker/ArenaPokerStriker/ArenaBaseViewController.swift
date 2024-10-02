//
//  ArenaBaseViewController.swift
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

import UIKit

class ArenaBaseViewController: UIViewController {

    let bg = UIImageView(image: UIImage(named: "bg"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bg.contentMode = .scaleAspectFill
        bg.frame = UIScreen.main.bounds
        view.addSubview(bg)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bg.frame = self.view.bounds
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
