//
//  HBBaseViewController.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation
import UIKit

class HBBaseViewController<TViewModel: HBBaseViewModel>: UIViewController {
    
    public var viewModel: TViewModel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TViewModel()
    }
    
    func hideLeftBarButton(_ isHidden: Bool) {
        self.navigationItem.setHidesBackButton(isHidden, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !isHidden
    }
    
    func setAlert() {
        let alertController = UIAlertController(title: "Servis hatası", message: "Servis hatası", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            self?.dismiss(animated: false)
            self?.navigationController?.popViewController(animated: false)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
