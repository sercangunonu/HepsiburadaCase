//
//  QuestionsModel.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation

struct QuestionsModel: Codable {
    var questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case questions = "questions"
    }
}

struct Question: Codable {
    let question: String
    let answers: [String: String]
    let questionImageURL: String?
    let correctAnswer: String
    let score: Int

    enum CodingKeys: String, CodingKey {
        case question, answers
        case questionImageURL = "questionImageUrl"
        case correctAnswer, score
    }
}

// MARK: - Answers
//struct Answers: Codable {
//    let a, b: String
//    let c, d: String?
//
//    enum CodingKeys: String, CodingKey {
//        case a = "A"
//        case b = "B"
//        case c = "C"
//        case d = "D"
//    }
//}
