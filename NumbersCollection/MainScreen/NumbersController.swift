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
        view.backgroundColor = ConfigConstants.viewBackgroundColor
        configureController()
        startLogic()
        print(Int64.max)
        print(Int32.max)
        print(Int8.max)
    }
    
    // MARK: - Private methods
    private func configureController() {
        title = ConfigConstants.mainTitle
    }
    
    private func startLogic() {
        NumGeneratorService.shared.packageSize = 30
        
        let newNumbersPrime = NumGeneratorService.shared.getPrimeNumbers(from: 0)
        let newNumbersFib = NumGeneratorService.shared.getFibanacciNumbers(from: (0, 1))
        
        contentView.insertNewNumbers(newNumbersPrime, into: .prime)
        contentView.insertNewNumbers(newNumbersFib, into: .fibanacci)
    }
}

// MARK: - Protocol execution
extension NumbersController: NumbersControllerProtocol {}

// MARK: - View delegate execution
extension NumbersController: NumbersViewDelegate {
    func didSelectSegment(_ segment: Any) {
        guard let segment = segment as? CollectionType else { return }
        selectedType = segment
        switch segment {
        case .prime: contentView.showPrimeCollection()
        case .fibanacci: contentView.showFibanacciCollection()
        }
    }
    
    func loadMorePrimeNumbers(from lastNumber: Int) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async { [weak self] in
            guard let self = self else { return }
            let newNumbers = NumGeneratorService.shared.getPrimeNumbers(from: lastNumber)
            self.contentView.insertNewNumbers(newNumbers, into: .prime)
        }
    }
    
    func loadMoreFibanacciNumbers(from lastPair: (Int, Int)) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async { [weak self] in
            guard let self = self else { return }
            let newNumbers = NumGeneratorService.shared.getFibanacciNumbers(from: lastPair)
            self.contentView.insertNewNumbers(newNumbers, into: .fibanacci)
        }
    }
}

// MARK: - Configuration constants
extension NumbersController {
    struct ConfigConstants {
        static var mainTitle: String = "Числовой контроллер"
        static var viewBackgroundColor: UIColor { .systemGray3 }
        static var segmentedItems: [CollectionType] { [.prime, .fibanacci] }
    }
}


