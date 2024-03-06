//
//  QuizViewModel.swift
//  Quiz
//
//  Created by Mytraie Chinthapatla on 1/1/24.
//

import Foundation

class QuizViewModel: NSObject {
    var apiService: APIService!
    var quizData: QuizApp?
    var currentQstnIndex: Int = 0 // Index to keep track of the current question
    var questions: [Result] = [] //  Array of questions
    var currentScore: Int! {
        didSet {
            saveScoreToUserDefaults()
        }
    }
    
    override init() {
        super.init()
        self.apiService = APIService()
        currentScore = loadScoreFromUserDefaults()
    }
    
    func getCurrentQuestion() -> Result? {
        guard let results = quizData?.results, currentQstnIndex < results.count else {
            return nil // Return nil if there are no more questions
        }
        
        var currentQuestion = results[currentQstnIndex]
        let shuffledAnswers = shuffleAnswers(correctAnswer: currentQuestion.correctAnswer, incorrectAnswers: currentQuestion.incorrectAnswers)
        currentQuestion.incorrectAnswers = shuffledAnswers
        
        return currentQuestion
    }
    
    func addScore(value: Int) {
        currentScore += value
    }
    
    // To shuffle correct and wrong answers
    private func shuffleAnswers(correctAnswer: String, incorrectAnswers: [String]) -> [String] {
        var allAnswers = incorrectAnswers + [correctAnswer]
        allAnswers.shuffle()
        return allAnswers
    }
    
    //For retrieving the next question and updating the index.
    func getNextQuestion() -> Result? {
        currentQstnIndex += 1
        return getCurrentQuestion()
    }
    
    func handleAnswer(isCorrect: Bool) {
        if isCorrect {
            currentScore += 4
        } else {
            currentScore -= 2
        }
    }
    
     func saveScoreToUserDefaults() {
        UserDefaults.standard.set(currentScore, forKey: "userScore")
    }
    
     func loadScoreFromUserDefaults() -> Int {
        return UserDefaults.standard.integer(forKey: "userScore")
    }
    
    // API call to fetch data
    func getQuizData(completion: @escaping () -> Void) {
        self.apiService.apiToGetQuizData { [weak self] (quizData) in
            self?.quizData = quizData
            completion()
        }
    }
}


class QuizViewModelManager {
    static let shared = QuizViewModelManager()
    var quizViewModel = QuizViewModel()
}
