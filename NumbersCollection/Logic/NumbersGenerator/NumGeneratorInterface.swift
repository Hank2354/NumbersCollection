//
//  NumGeneratorInterface.swift
//  NumbersCollection
//
//  Created by Vladislav Mashkov on 01.07.2022.
//

import Foundation

protocol NumGeneratorInterface: AnyObject {
    
    /// Дефолтный пресет для установки размера пакета, получаемого из данного сервиса. (Количество чисел, получаемых в массиве по запросам)
    var packageSize: Int { get set }
    
    /**
     Получение пакета чисел, начиная с указанного числа и далее (Указанное число не входит в пакет)
     
     - parameter sequence: Передаем последовательность, которую необходимо обработать для получения следующих Х чисел данной последовательности.
     - returns: Массив простых чисел, в количестве, равному установленому пресету packageSize
     - warning: При достижении максимально возможного числа в системе пакет будет заполнен последним возможным числом
     
     */
    func getNumbers(from sequence: [Int]) -> [Int]
}

