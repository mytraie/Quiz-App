//
//  QuizDataManager.swift
//  Quiz
//
//  Created by Mytraie Chinthapatla on 1/1/24.
//

import Foundation

struct QuizApp: Codable {
    var responseCode: Int
    var results: [Result]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct Result: Codable {
    var type: TypeEnum
    var difficulty: Difficulty
    var category: Category
    var question, correctAnswer: String
    var incorrectAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

enum Category: String, Codable {
    case generalKnowledge = "General Knowledge"
}

enum Difficulty: String, Codable {
    case hard = "hard"
}

enum TypeEnum: String, Codable {
    case multiple = "multiple"
}

struct QuizQuestion {
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
}
