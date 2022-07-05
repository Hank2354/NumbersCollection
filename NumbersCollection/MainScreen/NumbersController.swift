//
//  NumbersController.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersControllerProtocol: UIViewController {
    var selectedSegment: SegmentItem { get set }
    var numbers: [Int] { get }
}

final class NumbersController: UIViewController {

    // MARK: - Properties
    internal var selectedSegment: SegmentItem = ConfigConstants.startSegment
    private let contentView: NumbersViewProtocol = NumbersView(frame: .zero, segmentItems: ConfigConstants.segmentedItems)
    private var primeNumbers = [Int]()
    private var fibanacciNumbers = [Int]()
    
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
        contentView.configure(with: ConfigConstants.segmentedItems.firstIndex(of: selectedSegment) ??
                                    ConfigConstants.segmentedItems.startIndex)
    }
}

// MARK: - Protocol execution
extension NumbersController: NumbersControllerProtocol {
    var numbers: [Int] {
        switch selectedSegment {
        case .prime:     return primeNumbers
        case .fibonacci: return fibanacciNumbers
        }
    }
}

// MARK: - View delegate execution
extension NumbersController: NumbersViewDelegate {
    
    func didSelectSegment(_ segment: Any) {
        // Реагируем на выбор нового сегмента
        guard let segment = segment as? SegmentItem else { return }
        selectedSegment = segment
        contentView.display(numbers, animated: true)
    }
    
    func didDisplayDetector() {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async { [weak self] in
            guard let self = self else { return }
            switch self.selectedSegment {
            case .prime:
                self.primeNumbers.append(contentsOf: NumPrimeGenerator.shared.getNumbers(from: .prime(self.primeNumbers.last ?? 0)))
                self.contentView.display(self.primeNumbers, animated: false)
            case .fibonacci:
                if self.fibanacciNumbers.count >= 2 {
                    let pair = (self.fibanacciNumbers[self.fibanacciNumbers.count - 2],
                                self.fibanacciNumbers[self.fibanacciNumbers.count - 1])
                    self.fibanacciNumbers.append(contentsOf: NumFibonacciGenerator.shared.getNumbers(from: .fibonacci(pair.0, pair.1)))
                    self.contentView.display(self.fibanacciNumbers, animated: false)
                } else {
                    self.fibanacciNumbers.append(contentsOf: NumFibonacciGenerator.shared.getNumbers(from: .fibonacci(0, 1)))
                    self.contentView.display(self.fibanacciNumbers, animated: false)
                }
            }
        }
    }
}

// MARK: - Configuration constants
extension NumbersController {
    struct ConfigConstants {
        static var mainTitle: String = "Числовой контроллер"
        static var viewBackgroundColor: UIColor { .systemGray3 }
        static var segmentedItems: [SegmentItem] { [.prime, .fibonacci] }
        static var startSegment: SegmentItem { segmentedItems[segmentedItems.startIndex] }
        static var defaultPacketSize: Int { 30 }
    }
}


