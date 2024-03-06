//
//  QuestionsViewModel.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation

protocol QuestionsViewModelDelegate: AnyObject {
    func didFetchQuestions(response: QuestionsModel, answers: [[String : String]])
    func didGetError()
}

final class QuestionsViewModel: HBBaseViewModel {
    weak var delegate: QuestionsViewModelDelegate?
    
    func fetchQuestions() {
        let url = URL(string: "http://demo3633203.mockable.io/hbquiz")!
        NetworkManager.shared.fetchData(with: url) { [weak self] (response: Result<QuestionsModel, DataError>) in
            DispatchQueue.main.async {
                switch response {
                case .success(let response):
                    let answers = response.questions.map { $0.answers }
                    var shuffledAnswers: [[String: String]] = []
                    
                    for answer in answers {
                        let keyValueArray = Array(answer)
                        let shuffledKeyValueArray = keyValueArray.shuffled()
                        let shuffledDictionary = Dictionary(uniqueKeysWithValues: shuffledKeyValueArray)
                        shuffledAnswers.append(shuffledDictionary)
                    }
                    self?.delegate?.didFetchQuestions(response: response, answers: shuffledAnswers)
                case .failure(_):
                    self?.delegate?.didGetError()
                }
            }
        }
    }
}
