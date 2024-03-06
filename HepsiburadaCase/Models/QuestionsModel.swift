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
        case question = "question"
        case answers = "answers"
        case questionImageURL = "questionImageUrl"
        case correctAnswer = "correctAnswer"
        case score = "score"
    }
}
