//
//  MainMenuViewController.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation
import UIKit

final class MainMenuViewController: HBBaseViewController<MainMenuViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var highestScoreLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    
    // MARK: - Variables
    
    private var highestScore: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareScore()
        prepareUI()
    }
    
    // MARK: - UI
    
    func prepareUI() {
        highestScoreLabel.text = "Highscore \(highestScore) point"
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
        self.hideLeftBarButton(true)
    }
    
    func prepareScore() {
        highestScore = UserDefaults.standard.integer(forKey: "highestScore")
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: Any) {
        let vc = QuestionsViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}
