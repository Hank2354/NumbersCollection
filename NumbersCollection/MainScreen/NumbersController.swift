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
        NumGeneratorService.shared.packageSize = ConfigConstants.defaultPacketSize
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
    
    func loadMorePrimeNumbers(from lastNumber: Int) {
        // Запускаем в утилити потоке алгоритм подбора новых чисел
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async { [weak self] in
            guard let self = self else { return }
            let newNumbers = NumGeneratorService.shared.getPrimeNumbers(from: lastNumber)
            self.contentView.insertNewNumbers(newNumbers, into: .prime)
        }
    }
    
    func loadMoreFibanacciNumbers(from lastPair: (Int, Int)) {
        // Запускаем в утилити потоке алгоритм подбора новых чисел
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async { [weak self] in
            guard let self = self else { return }
            let newNumbers = NumGeneratorService.shared.getFibanacciNumbers(from: lastPair)
            self.contentView.insertNewNumbers(newNumbers, into: .fibonacci)
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


