//
//  NumbersController.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import UIKit

protocol NumbersControllerProtocol: UIViewController {
    var selectedSegment: SegmentItem { get set }
    var numbers: [Int] { get set }
    var generator: NumGeneratorInterface { get }
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
        get {
            switch selectedSegment {
            case .prime:     return primeNumbers
            case .fibonacci: return fibanacciNumbers
            }
        }
        set {
            switch selectedSegment {
            case .prime:     primeNumbers = newValue
            case .fibonacci: fibanacciNumbers = newValue
            }
        }
    }
    
    var generator: NumGeneratorInterface {
        switch selectedSegment {
        case .prime: return NumPrimeGenerator.shared
        case .fibonacci: return NumFibonacciGenerator.shared
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
            self.numbers.append(contentsOf: self.generator.getNumbers(from: self.numbers))
            self.contentView.display(self.numbers, animated: false)
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


