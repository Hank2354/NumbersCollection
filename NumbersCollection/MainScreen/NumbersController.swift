//
//  NumbersController.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersControllerProtocol: UIViewController {
    var selectedType: CollectionType { get set }
}

final class NumbersController: UIViewController {

    // MARK: - Properties
    private let contentView: NumbersViewProtocol = NumbersView(frame: .zero, segmentItems: ConfigConstants.segmentedItems)
    internal var selectedType: CollectionType = .prime
    
    // MARK: - Lifecycle
    override func loadView() {
        contentView.delegate = self
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

extension NumbersController: NumbersViewDelegate {
    func didSelectSegment(_ segment: Any) {
        guard let segment = segment as? CollectionType else { return }
        switch segment {
        case .prime: contentView.showPrimeCollection()
        case .fibanacci: contentView.showFibanacciCollection()
        }
    }
}

// MARK: - Configuration constants
extension NumbersController {
    struct ConfigConstants {
        static var mainTitle: String = "Числовой контроллер"
        static var segmentedItems: [CollectionType] { [.prime, .fibanacci] }
    }
}


