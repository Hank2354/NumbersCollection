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
    internal var selectedType: CollectionType = ConfigConstants.startSegment
    
    // MARK: - Lifecycle
    override func loadView() {
        contentView.delegate = self
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        startLogic()
    }
    
    // MARK: - Private methods
    private func configureController() {
        view.backgroundColor = ConfigConstants.viewBackgroundColor
        title = ConfigConstants.mainTitle
    }
    
    private func startLogic() {
        contentView.configure(with: ConfigConstants.segmentedItems.firstIndex(of: selectedType) ??
                              ConfigConstants.segmentedItems.startIndex)
    }
}

// MARK: - Protocol execution
extension NumbersController: NumbersControllerProtocol {}

// MARK: - View delegate execution
extension NumbersController: NumbersViewDelegate {
    func didSelectSegment(_ segment: Any) {
        // Реагируем на выбор нового сегмента
        guard let segment = segment as? CollectionType else { return }
        selectedType = segment
        contentView.showCollection(selectedType)
    }
    
    func loadMoreNumbers(_ initValues: NumGeneratorInitValue) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async { [weak self] in
            guard let self = self else { return }
            switch self.selectedType {
            case .prime:
                self.contentView.insertNewNumbers(NumPrimeGenerator.shared.getNumbers(from: initValues), into: self.selectedType)
            case .fibonacci:
                self.contentView.insertNewNumbers(NumFibonacciGenerator.shared.getNumbers(from: initValues), into: self.selectedType)
            }
        }
    }
}

// MARK: - Configuration constants
extension NumbersController {
    struct ConfigConstants {
        static var mainTitle: String = "Числовой контроллер"
        static var viewBackgroundColor: UIColor { .systemGray3 }
        static var segmentedItems: [CollectionType] { [.prime, .fibonacci] }
        static var startSegment: CollectionType { segmentedItems[segmentedItems.startIndex] }
        static var defaultPacketSize: Int { 30 }
    }
}


