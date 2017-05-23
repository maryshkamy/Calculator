//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 18/05/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var accumulator: Double?
    
    private enum Operation{
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case factorial
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "=": Operation.equals,
        "+": Operation.binary({ $0 + $1 }),
        "−": Operation.binary({ $0 - $1 }),
        "×": Operation.binary({ $0 * $1 }),
        "÷": Operation.binary({ $0 / $1 }),
        "±": Operation.unary({ -$0 }),
        "%": Operation.unary({ $0 / 100 }),
        "√": Operation.unary(sqrt),
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "x²": Operation.unary({ pow($0, 2) }),
        "ln": Operation.unary({ log(Double($0)) }),
        "x!": Operation.factorial,
        "sin": Operation.unary(sin),
        "cos": Operation.unary(cos),
        "tan": Operation.unary(tan),
        "C": Operation.clear
    ]
    
    private var pbo: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let constant):
                accumulator = constant
            case .unary(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binary(let function):
                if accumulator != nil {
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                }
            case .factorial:
                let aux = factorial(number: accumulator!)
                accumulator = aux
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                clear()
            default:
                break
            }
        }
    }
    
    private mutating func factorial(number: Double) -> Double {
        if number == 0 {
            return 1
        }
        else {
            return number * factorial(number: number - 1)
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if accumulator != nil {
            accumulator = pbo?.perform(with: accumulator!)
        }
    }
    
    private mutating func clear() {
        accumulator = 0
        pbo = nil
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
