//
//  ViewControllerTests.swift
//  QuizTests
//
//  Created by Mytraie Chinthapatla on 6/3/24.
//

import XCTest
@testable import Quiz

final class ViewControllerTests: XCTestCase {
    
    var viewController: ViewController!

    override func setUp() {
            super.setUp()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            viewController.loadViewIfNeeded()
        }

        override func tearDown() {
            viewController = nil
            super.tearDown()
        }

        func testUpdateUIWithCurrentQuestion() {
            let mockQuizViewModel = MockQuizViewModel()
            QuizViewModelManager.shared.quizViewModel = mockQuizViewModel
            viewController.updateUIWithCurrentQuestion()
            XCTAssertEqual(viewController.qstnLabel.text, "Mock Question")
            XCTAssertEqual(viewController.option1Button.title(for: .normal), "Mock Option 1")
            XCTAssertEqual(viewController.option2Button.title(for: .normal), "Mock Option 2")
            XCTAssertEqual(viewController.option3Button.title(for: .normal), "Mock Option 3")
            XCTAssertEqual(viewController.option4Button.title(for: .normal), "Mock Option 4")
        }
    }

    class MockQuizViewModel: QuizViewModel {
        override func getCurrentQuestion() -> Result? {
            return Result(
                type: .multiple,
                difficulty: .hard,
                category: .generalKnowledge,
                question: "Mock Question",
                correctAnswer: "Mock Answer",
                incorrectAnswers: ["Mock Option1","Mock Option2","Mock Option3"])
        }
    }
