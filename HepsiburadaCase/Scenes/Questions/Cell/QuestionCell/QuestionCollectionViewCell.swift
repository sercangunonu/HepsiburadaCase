//
//  QuestionCell.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation
import UIKit

final class QuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet private weak var questionImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    
    func configure(score: Int, imageURL: String?, question: String) {

        scoreLabel.text = String(score)
        questionLabel.text = question
        guard let imageURLString = imageURL, let imageURL = URL(string: imageURLString) else {
            questionImage.image = UIImage(named: "hepsiburadaLogo")
            return
        }

        questionImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "hepsiburadaLogo"))
    }
}
