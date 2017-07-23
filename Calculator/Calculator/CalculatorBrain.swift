//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 18/05/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var pbo: PendingBinaryOperation?
    private var history: [String] = []
    private var lastOperation: LastOperation = .clear
    
    private var operations: Dictionary<String, Operation> = [
        "=": Operation.equals,
        "+": Operation.binary({ $0 + $1 }),
        "−": Operation.binary({ $0 - $1 }),
        "×": Operation.binary({ $0 * $1 }),
        "÷": Operation.binary({ $0 / $1 }),
        "±": Operation.unary({ -$0 }),
        "%": Operation.percentage({ $0 / 100 }),
        "√": Operation.unary(sqrt),
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "x²": Operation.pow({ pow($0, 2) }),
        "ln": Operation.unary({ log(Double($0)) }),
        "x!": Operation.factorial,
        "sin": Operation.unary(sin),
        "cos": Operation.unary(cos),
        "tan": Operation.unary(tan),
        "C": Operation.clear
    ]
    
    var isPartialResult: Bool? {
        get {
            return pbo != nil
        }
    }
    
    var description: String? {
        get {
            if pbo != nil {
                return history.joined(separator: " ") + " "
            }
            
            return history.joined(separator: " ")
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case percentage((Double) -> Double)
        case pow((Double) -> Double)
        case factorial
        case equals
        case clear
    }
    
    private enum LastOperation {
        case digit
        case constant
        case unary
        case binary
        case percentage
        case pow
        case factorial
        case equals
        case clear
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }

    private mutating func performPendingBinaryOperation() {
        if pbo != nil {
            if accumulator != nil {
                accumulator = pbo?.perform(with: accumulator!)
                pbo = nil
            }
        }
    }
    
    private mutating func factorial(number: Double) -> Double {
        if number == 0 {
            return 1
        } else {
            return number * factorial(number: number - 1)
        }
    }
    
    private mutating func clear() {
        accumulator = 0
        pbo = nil
        history.removeAll()
        lastOperation = .clear
    }
    
    private mutating func wrapWithParens(_ symbol: String) {
        switch lastOperation {
        case .clear:
            return
            
        case .equals:
            history.insert(")", at: history.count)
            history.insert(symbol, at: 0)
            history.insert("(", at: 1)
            
        default:
            history.insert(symbol, at: history.count - 1)
            history.insert("(", at: history.count - 1)
            history.insert(")", at: history.count)
        }
    }
    
    mutating func setOperation(_ operation: Double) {
        if lastOperation == .unary {
            history.removeAll()
        }
        
        accumulator = operation
        history.append(String(operation))
        lastOperation = .digit
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let constant):
                history.append(symbol)
                accumulator = constant
                lastOperation = .constant
                
            case .unary(let function):
                if accumulator != nil {
                    wrapWithParens(symbol)
                    accumulator = function(accumulator!)
                    lastOperation = .unary
                }
                
            case .binary(let function):
                if accumulator != nil {
                    history.append(symbol)
                    performPendingBinaryOperation()
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    lastOperation = .binary
                }
                
            case .percentage(let function):
                if accumulator != nil {
                    history.append("%")
                    accumulator = function(accumulator!)
                    lastOperation = .percentage
                }

            case .pow(let function):
                if accumulator != nil {
                    history.append("²")
                    accumulator = function(accumulator!)
                    lastOperation = .pow
                }

            case .factorial:
                history.append("!")
                let aux = factorial(number: accumulator!)
                accumulator = aux
                lastOperation = .factorial

            case .equals:
                if lastOperation == .binary {
                    history.append(String(describing: accumulator))
                }
                performPendingBinaryOperation()
                lastOperation = .equals
                
            case .clear:
                clear()
                lastOperation = .clear
            }
        }
    }
}
