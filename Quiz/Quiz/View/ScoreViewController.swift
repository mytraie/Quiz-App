//
//  ScoreViewController.swift
//  Quiz
//
//  Created by Mytraie Chinthapatla on 6/3/24.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet var scoreLabel: UILabel!
    var score: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let score = score {
            scoreLabel.text = "Score : \(String(describing: score))"
        }
    }
}
