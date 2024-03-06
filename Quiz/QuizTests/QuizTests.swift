//
//  QuizTests.swift
//  QuizTests
//
//  Created by Mytraie Chinthapatla on 6/3/24.
//

import XCTest
@testable import Quiz

final class QuizTests: XCTestCase {
    
    var quizViewModel: MockQuizViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        quizViewModel = MockQuizViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        quizViewModel = nil
        super.tearDown()
    }
    
    func testGetCurrentQuestion() {
        let initialIndex = quizViewModel.currentQstnIndex
        let firstQuestion = quizViewModel.getCurrentQuestion()
        XCTAssertEqual(quizViewModel.currentQstnIndex, initialIndex)
    }
    
    func testAddScore() {
        let initialScore = quizViewModel.currentScore ?? 0
        quizViewModel.addScore(value: 5)
        XCTAssertEqual(quizViewModel.currentScore, initialScore + 5)
    }
    
    func testHandleAnswer() {
        let initialScore = quizViewModel.currentScore ?? 0
        quizViewModel.handleAnswer(isCorrect: true)
        XCTAssertEqual(quizViewModel.currentScore, initialScore + 4)
        quizViewModel.handleAnswer(isCorrect: false)
        XCTAssertEqual(quizViewModel.currentScore, initialScore + 4 - 2)
    }
    
    func testGetNextQuestion() {
        let initialIndex = quizViewModel.currentQstnIndex
        let nextQuestion = quizViewModel.getNextQuestion()
        XCTAssertEqual(quizViewModel.currentQstnIndex, initialIndex + 1)
    }
    
    func testSaveAndLoadScore() {
        let initialScore = quizViewModel.currentScore
        quizViewModel.saveScoreToUserDefaults()
        let loadedScore = quizViewModel.loadScoreFromUserDefaults()
        XCTAssertEqual(loadedScore, initialScore)
    }
    
    func testGetQuizData() {
        let expectation = self.expectation(description: "Fetching quiz data")
        quizViewModel.getQuizData {
            XCTAssertNotNil(self.quizViewModel.quizData)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
