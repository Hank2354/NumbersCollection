//
//  NumFibonacciGenerator.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 05.07.2022.
//

import Foundation

final class NumFibonacciGenerator {
    // MARK: - Singleton
    static let shared: NumGeneratorInterface = NumFibonacciGenerator()
    private init() {}
    
    // MARK: - Properties
    var packageSize: Int = 30
    
    /**
     Данный метод позволяет получить следующее число фибоначчи после двух предыдущих, переденных в качестве пары целых чисел
     
     - parameter pair: Пара последних двух чисел из ряда фибоначчи
     - returns: Следующее число в ряду
     - warning: Сложность алгоритма O(1)
     
     */
    private func fibonacciNextItem(from pair: (Int, Int)) -> Int {
        if pair.0 <= Int.max - pair.1 {
        return pair.0 + pair.1
        } else {
            return pair.1
        }
    }
}

extension NumFibonacciGenerator: NumGeneratorInterface {
    
    // O(n)
    func getNumbers(from initValue: NumGeneratorInitValue) -> [Int] {
        if case let .fibonacci(pair) = initValue {
            var values = [Int]()
            if pair.0 == 0 || pair.1 == 1 { values.append(contentsOf: [pair.0, pair.1]) }
            var fibPair = pair
            while values.count < packageSize {
                let nextFibValue = fibonacciNextItem(from: fibPair)
                let nextPair = (fibPair.1, nextFibValue)
                values.append(nextFibValue)
                fibPair = nextPair
            }
            return values
        } else { return [] }
    }
}

