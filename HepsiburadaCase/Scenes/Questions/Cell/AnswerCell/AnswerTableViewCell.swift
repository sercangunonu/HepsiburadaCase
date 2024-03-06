//
//  AnswerTableViewCell.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation
import UIKit

final class AnswerTableViewCell: UITableViewCell {
        
    @IBOutlet private weak var answerButton: UIButton!
    
    var buttonTappedAction : (() -> Void)? = nil
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String) {
        answerButton.setTitle(title, for: .normal)
        answerButton.layer.cornerRadius = 10
        answerButton.clipsToBounds = true
        layoutIfNeeded()
    }
    
    func setButtonBackgroundColor(_ color: UIColor) {
        answerButton.backgroundColor = color
    }
    
    @IBAction func answerButtonTapped(_ sender: Any) {
        
        if let buttonTappedAction = self.buttonTappedAction
        {
            buttonTappedAction()
        }
    }
}
