//
//  NumGeneratorService.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation

final class NumGeneratorService {
    // MARK: - Singleton
    static let shared: NumGeneratorInterface = NumGeneratorService()
    private init() {}
    
    // MARK: - Properties
    var packageSize: Int = 60
    
    // MARK: - Private methods
    /**
     Данный метод позволяет определить, является ли переданное в функцию число - простым. Двойка всегда вернет true, для остальных проверяем, что число больше 2, и что оно не четное (потому что все четные числа делятся без остатка на 2, а значит априори не простые). Ход проверки: Мы создаем последовательность от 3 до квадратного корня из переданного числа, с шагом 2 (т.к нас интересуют такие же нечетные числа), и проверяем, что переданное при делении на любое число из последовательности будет давать какой то остаток от деления. Если получили остаток равный 0 - число не простое, возвращаем false, в остальные случаях вернем true
     
     - parameter n: Число, которое проверяем.
     - returns: True - если переданное число простое, False - если переданное число не простое
     - warning: Сложность алгоритма O(Sqrt(n)/2)
     
     */
    func isPrime(_ n: Int) -> Bool {
        guard n >= 2     else { return false }
        guard n != 2     else { return true  }
        guard n % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(n))), by: 2).contains { n % $0 == 0 }
    }
}

extension NumGeneratorService: NumGeneratorInterface {
    
    func getPrimeNumbers(from initValue: Int) -> [Int] {
        var values = [Int]()
        var checkingValue = initValue
        while values.count < packageSize {
            if isPrime(checkingValue) { values.append(checkingValue) }
            checkingValue += 1
        }
        return values
    }
    
    func getFibanacciNumbers(from initValue: Int) -> [Int] {
        var x = [Int]()
        for i in 0...packageSize { x.append(Int.random(in: 0...100)) }
        return x
        
    }
    
    
}
