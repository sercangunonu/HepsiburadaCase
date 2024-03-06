//
//  HBLoadingView.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 6.03.2024.
//

import Foundation
import UIKit

class HBLoadingView: UIView {
    private var activityIndicator = UIActivityIndicatorView()

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init() {
        super.init(frame: .zero)
        setupLoadingIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLoadingIndicator() {
        activityIndicator.style = .large
        activityIndicator.center = self.center
        activityIndicator.color = .white
        activityIndicator.isHidden = false
        activityIndicator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.addSubview(activityIndicator)
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        self.isUserInteractionEnabled = true
    }
}
