//
//  NumPrimeGenerator.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation

final class NumPrimeGenerator {
    // MARK: - Singleton
    static let shared: NumGeneratorInterface = NumPrimeGenerator()
    private init() {}
    
    // MARK: - Properties
    var packageSize: Int = 30
    
    // MARK: - Private methods
    /**
     Данный метод позволяет определить, является ли переданное в функцию число - простым. Двойка всегда вернет true, для остальных проверяем, что число больше 2, и что оно не четное (потому что все четные числа делятся без остатка на 2, а значит априори не простые). Ход проверки: Мы создаем последовательность от 3 до квадратного корня из переданного числа, с шагом 2 (т.к нас интересуют такие же нечетные числа), и проверяем, что переданное при делении на любое число из последовательности будет давать какой то остаток от деления. Если получили остаток равный 0 - число не простое, возвращаем false, в остальные случаях вернем true
     
     - parameter n: Число, которое проверяем.
     - returns: True - если переданное число простое, False - если переданное число не простое
     - warning: Сложность алгоритма O(Sqrt(n)/2)
     
     */
    private func isPrime(_ n: Int) -> Bool {
        guard n >= 2     else { return false }
        guard n != 2     else { return true  }
        guard n % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(n))), by: 2).contains { n % $0 == 0 }
    }
}

extension NumPrimeGenerator: NumGeneratorInterface {
    
    // O((Sqrt(n)/2)^2) -> O(n/4)
    func getNumbers(from initValue: NumGeneratorInitValue) -> [Int] {
        if case let .prime(value) = initValue {
            var values = [Int]()
            var checkingValue = value + 1
            while values.count < packageSize {
                if isPrime(checkingValue) { values.append(checkingValue) }
                if checkingValue < Int.max { checkingValue += 1 }
            }
            return values
        } else { return [] }
    }
}
