//
//  feedback.swift
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

import Foundation
import UIKit

class ArenaReportViewController: ArenaBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isHidden = false
        //self.navigationItem.titleView?.isHidden = false
    }
    
    @IBAction func btn(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Message", message: "successfully", preferredStyle: UIAlertController.Style.alert)
        
        let Ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(Ok)
        
       present(alert, animated: false)
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

}
