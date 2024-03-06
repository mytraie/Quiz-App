//
//  StartViewController.swift
//  Quiz
//
//  Created by Mytraie Chinthapatla on 5/3/24.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var quizVM: QuizViewModel {
        return QuizViewModelManager.shared.quizViewModel
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        UserDefaults.standard.set(0, forKey: "userScore")
        UserDefaults.standard.synchronize()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.quizVM.getQuizData { [weak self] in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.performSegue(withIdentifier: "startToMainSegue", sender: self)
                }
            }
        }
    }
}
