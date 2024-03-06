//
//  File.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 6.03.2024.
//

import Foundation

protocol MainMenuViewModelDelegate: AnyObject {
    
}

class MainMenuViewModel: HBBaseViewModel {
    weak var delegate: MainMenuViewModelDelegate?
}
