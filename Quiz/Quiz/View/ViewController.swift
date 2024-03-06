//
//  ViewController.swift
//  Quiz
//
//  Created by Mytraie Chinthapatla on 28/2/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var qstnLabel: UILabel!
    @IBOutlet weak var nxtButton: UIButton!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    var circleLayer = CAShapeLayer()
    var quizVM: QuizViewModel {
        return QuizViewModelManager.shared.quizViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        displayScore()
        circleLayer = timerView.createCircleLayer()
        timerView.layer.addSublayer(circleLayer)
        timerView.startTimer()
        updateUIWithCurrentQuestion()
    }
    
    func updateUIWithCurrentQuestion() {
        DispatchQueue.main.async { [weak self] in
            if let currentQuestion = self?.quizVM.getCurrentQuestion() {
                self?.qstnLabel.text = currentQuestion.question.decodedHTMLString
                self?.option1Button.setTitle(currentQuestion.incorrectAnswers[0].decodedHTMLString, for: .normal)
                self?.option2Button.setTitle(currentQuestion.incorrectAnswers[1].decodedHTMLString, for: .normal)
                self?.option3Button.setTitle(currentQuestion.incorrectAnswers[2].decodedHTMLString, for: .normal)
                self?.option4Button.setTitle(currentQuestion.incorrectAnswers[3].decodedHTMLString, for: .normal)
            }
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard let currentQuestion = quizVM.getCurrentQuestion() else {
            print("No more questions.")
            return
        }
        self.displayScore()
        
        for button in answerButtons {
            let isCorrectAnswer = button.currentTitle == currentQuestion.correctAnswer
            if button == sender {
                button.backgroundColor = isCorrectAnswer ? UIColor.systemGreen : UIColor.systemRed
                if isCorrectAnswer {
                    let isWithinTimerRange = timerView.elapsedTime <= 20.0
                    if isWithinTimerRange {
                        quizVM.addScore(value: 1)
                    }
                }
                quizVM.handleAnswer(isCorrect: isCorrectAnswer)
                displayScore()
            } else {
                button.backgroundColor = isCorrectAnswer ? UIColor.systemGreen : UIColor.systemBackground
            }
            button.isUserInteractionEnabled = false
        }
        nxtButton.isEnabled = true
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let nextQuestion = quizVM.getNextQuestion() {
            self.resetValues()
            timerView.resetTimer()
            timerView.updateTimerForNewQstn()
            updateUIWithCurrentQuestion()
        } else {
            print("No more questions.")
            displayScore()
            UserDefaults.standard.removeObject(forKey: "userScore")
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "mainToScoreSegue", sender: self)
        }
        
    }
    
    func displayScore() {
        if let currentScore = quizVM.currentScore {
            scoreLabel.text = "Score : \(currentScore)"
        }
    }
    
    func resetValues() {
        for button in answerButtons {
            button.isUserInteractionEnabled = true
            button.backgroundColor = UIColor.white
            nxtButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToScoreSegue" {
            if let scoreVC = segue.destination as? ScoreViewController {
                scoreVC.score = quizVM.currentScore
            }
        }
    }
}


class TimerView: UIView {
    private var circleLayer = CAShapeLayer()
    private var timerLabel = UILabel()
    
    private var timer: Timer?
    private var totalTime: TimeInterval = 20.0
    var elapsedTime: TimeInterval = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        circleLayer = createCircleLayer()
        layer.addSublayer(circleLayer)
        timerLabel = createTimerLabel()
        addSubview(timerLabel)
    }
    
    func createCircleLayer() -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(ovalIn: bounds)
        circleLayer.path = circlePath.cgPath
        let customColor = UIColor(red: 62/255.0, green: 184/255.0, blue: 213/255.0, alpha: 1.0)
        circleLayer.strokeColor = customColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 5.0
        circleLayer.strokeEnd = 0.0
        
        return circleLayer
    }
    
    private func createTimerLabel() -> UILabel {
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.text = "\(Int(totalTime))"
        
        return label
    }
    
    func resetTimer() {
        timer?.invalidate()
        elapsedTime = 0.0
    }
    
    func updateTimerForNewQstn() {
        startTimer()
    }
    
    func handleTap() {
        if timer == nil {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer() {
        elapsedTime += 0.1
        let progress = Float(elapsedTime / totalTime)
        
        circleLayer.strokeEnd = CGFloat(progress)
        timerLabel.text = "\(Int(totalTime - elapsedTime))"
        
        if elapsedTime >= totalTime {
            stopTimer()
        }
    }
}




