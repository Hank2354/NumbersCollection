//
//  NumbersController.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersControllerProtocol: UIViewController {
    
}

final class NumbersController: UIViewController {

    // MARK: - Properties
    private let contentView: NumbersViewProtocol = NumbersView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureController()
    }
    
    // MARK: - Private methods
    private func configureController() {
        title = ConfigConstants.mainTitle
    }
}

// MARK: - Protocol execution
extension NumbersController: NumbersControllerProtocol {
    
}

// MARK: - Configuration constants
extension NumbersController {
    struct ConfigConstants {
        static var mainTitle: String = "Числовой контроллер"
    }
}


