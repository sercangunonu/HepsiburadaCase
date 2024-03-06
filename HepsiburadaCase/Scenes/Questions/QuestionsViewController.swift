//
//  QuestionsView.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation
import UIKit
import SDWebImage

final class QuestionsViewController: HBBaseViewController<QuestionsViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    
    private var questions: [Question]?
    private var answers: [[String: String]] = []
    private var collectionViewCell = QuestionCollectionViewCell()
    
    private var answerKeys: [String] = []
    private var answerValues: [String] = []
    
    private var questionNumber = 1
    private var totalScore = 0
    private var questionIndex = 0
    
    private let indicator = HBLoadingView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        prepareCollectionView()
        prepareTableView()
        prepareLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.showLoadingIndicator()
        self.viewModel.fetchQuestions()
        
        prepareUI()
    }
    
    // MARK: - Prepare Cells
    
    private func prepareCollectionView() {
        let nib = UINib(nibName: "QuestionCollectionViewCell", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "QuestionCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        let layout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenSize.width - 50, height: 250)
        collectionView.collectionViewLayout = layout
    }
    
    private func prepareTableView() {
        let tableNib = UINib(nibName: "AnswerTableViewCell", bundle: nil)
        self.tableView.register(tableNib, forCellReuseIdentifier: "AnswerTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        tableView.reloadData()
    }
    
    // MARK: - UI
    
    private func prepareUI() {
        self.hideLeftBarButton(true)
    }
    
    private func  createNavigateBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Anasayfa", for: .normal)
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    private func prepareLoading() {
        view.addSubview(indicator)
    }
    
    @objc private func navigateBack() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MainMenuViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return
            }
        }
    }
}

// MARK: - Delegate Extensions

extension QuestionsViewController: QuestionsViewModelDelegate {
    func didFetchQuestions(response: QuestionsModel, answers: [[String : String]]) {
        self.questions = response.questions
        self.answers = answers
        
        if let questions = questions {
            headerLabel.text = "Soru \(questionNumber)/\(questions.count) Total Puanınız \(totalScore)"
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
            self.indicator.hideLoadingIndicator()
        }
    }
    
    func didGetError() {
        indicator.hideLoadingIndicator()
        setAlert()
    }
}

// MARK: - CollectionView Extensions

extension QuestionsViewController: UICollectionViewDelegate {}

extension QuestionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let questions = questions else { return QuestionCollectionViewCell()}
        collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCollectionViewCell", for: indexPath) as! QuestionCollectionViewCell
        let question = questions[indexPath.row]
        collectionViewCell.configure(score: question.score, imageURL: question.questionImageURL, question: question.question)
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions?.count ?? 0
    }
}

// MARK: - TableView Extensions

extension QuestionsViewController: UITableViewDelegate {}

extension QuestionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions?[questionIndex].answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let questions = questions else { return AnswerTableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell", for: indexPath) as! AnswerTableViewCell
        
        cell.isUserInteractionEnabled = true
        
        self.headerLabel.text = "Soru \(self.questionNumber)/\((self.questions?.count)!) Total Puanınız \(self.totalScore)"
        let correctAnswer = questions[questionIndex].correctAnswer

        buttonDatas()
        
        cell.configure(title: answerValues[indexPath.row])
        cell.buttonTappedAction = { [self] in
            
            //change each cell's userInteraction after pressed button
            for row in 0..<questions[self.questionIndex].answers.count {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AnswerTableViewCell {
                    cell.isUserInteractionEnabled = false
                }
            }
            
            let answerKey = answerKeys[indexPath.row]
            
            if answerKey == correctAnswer {
                cell.setButtonBackgroundColor(.green)
                self.totalScore = self.totalScore + questions[self.questionIndex].score
            } else {
                cell.setButtonBackgroundColor(.red)
                let correctButtonTag = answerKeys.firstIndex(of: correctAnswer) // to find correctAnswer's cell
                if let cell = tableView.cellForRow(at: IndexPath(row: correctButtonTag ?? 0, section: 0)) as? AnswerTableViewCell {
                    cell.setButtonBackgroundColor(.green)
                }
            }
            self.headerLabel.text = "Soru \(self.questionNumber)/\((self.questions?.count)!) Total Puanınız \(self.totalScore)"
            if self.questionNumber == questions.count {
                
                createNavigateBackButton()
                hideLeftBarButton(false)
                let highestScore = UserDefaults.standard.integer(forKey: "highestScore")
                
                if totalScore > highestScore {
                    UserDefaults.standard.set(totalScore, forKey: "highestScore")
                }
                return
            }
            
            self.questionNumber = self.questionNumber + 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                //push collectionView's cell to next cell
                guard let collectionViewIndexPath = self.collectionView.indexPath(for: self.collectionViewCell) else { return }
                let nextIndex = IndexPath(item: collectionViewIndexPath.item + 1, section: collectionViewIndexPath.section)
                self.collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: false)
                
                //change each cell's backgroundColor after pressed button
                for row in 0..<questions[self.questionIndex].answers.count {
                    if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AnswerTableViewCell {
                        cell.setButtonBackgroundColor(.white)
                    }
                }
                self.questionIndex = self.questionIndex + 1
                tableView.reloadData()
            }
        }
        return cell
        
    }
    
    func buttonDatas() {
        answerKeys = answers[questionIndex].map { item in
            item.key
        }
        answerValues = answers[questionIndex].map { item in
            item.value
        }
    }
}
