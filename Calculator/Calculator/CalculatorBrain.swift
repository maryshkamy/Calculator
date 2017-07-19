//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 18/05/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    typealias PropertyList = AnyObject
    
    private var currentPrecedence = Precedence.max
    
    private var descriptionAccumulator = "0" {
        didSet {
            if pbo == nil {
                currentPrecedence = Precedence.max
            }
        }
    }
    
    private var accumulator: Double = 0
    private var pbo: PendingBinaryOperation?
    private var history = [AnyObject]()
    
    private var operations: Dictionary<String, Operation> = [
        "=": Operation.equals,
        "+": Operation.binary({ $0 + $1 }, { "\($0) + \($1)" }, Precedence.min),
        "−": Operation.binary({ $0 - $1 }, { "\($0) − \($1)" }, Precedence.min),
        "×": Operation.binary({ $0 * $1 }, { "\($0) × \($1)" }, Precedence.max),
        "÷": Operation.binary({ $0 / $1 }, { "\($0) ÷ \($1)" }, Precedence.max),
        "±": Operation.unary({ -$0 }, { "-\($0)" }),
        "%": Operation.unary({ $0 / 100 }, { "\($0)%" }),
        "√": Operation.unary(sqrt, { "√\($0)" }),
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "x²": Operation.unary({ pow($0, 2) }, { "(\($0))²" }),
        "ln": Operation.unary({ log(Double($0)) }, { "ln (\($0))" }),
//        "x!": Operation.factorial({ $0 }, { "\($0)!" }),
        "sin": Operation.unary(sin, { "sin (\($0))" }),
        "cos": Operation.unary(cos, { "cos (\($0))" }),
        "tan": Operation.unary(tan, { "tan (\($0))" }),
        "C": Operation.clear
    ]
    
    var variableValues = [String:Double]()
    
    var isPartialResult: Bool {
        get {
            return pbo != nil
        }
    }
    
    var description: String {
        get {
            if pbo == nil {
                return descriptionAccumulator
            } else {
                return pbo!.descriptionFunction(pbo!.descriptionOperand, pbo!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
            }
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var program: PropertyList {
        get {
            return history as CalculatorBrain.PropertyList
        }
        
        set {
            clear()
            
            if let array = newValue as? [AnyObject] {
                for i in array {
                    if let operation = i as? Double {
                        setOperation(operation)
                    } else if let variableName = i as? String {
                        if variableValues[variableName] != nil {
                            setOperation(variableName)
                        } else if let operation = i as? String {
                            performOperation(operation)
                        }
                    }
                }
            }
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double, (String) -> String)
        case binary((Double, Double) -> Double, (String, String) -> String, Precedence)
        case null(() -> Double, String)
//        case factorial((Double) -> Double, (String) -> String)
        case equals
        case clear
    }
    
    private enum Precedence: Int {
        case min = 0, max
    }
    
    private struct PendingBinaryOperation {
        var function: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }

    private mutating func performPendingBinaryOperation() {
        if pbo != nil {
            accumulator = pbo!.function(pbo!.firstOperand, accumulator)
            descriptionAccumulator = pbo!.descriptionFunction(pbo!.descriptionOperand, descriptionAccumulator)
            pbo = nil
        }
    }
    
    private mutating func factorial(number: Double) -> Double {
        if number == 0 {
            return 1
        }
        
        return number * factorial(number: number - 1)
    }
    
    private mutating func clear() {
        if !history.isEmpty {
            history.removeLast()
            program = history as CalculatorBrain.PropertyList
        } else {
            pbo = nil
            accumulator = 0
            descriptionAccumulator = "0"
            history.removeAll()
            descriptionAccumulator = ""
        }
    }
    
    mutating func setOperation(_ operation: Double) {
        accumulator = operation
        descriptionAccumulator = String(format: "%g", operation)
        history.append(String(operation) as AnyObject)
    }
    
    mutating func setOperation(_ variableName: String) {
        variableValues[variableName] = variableValues[variableName] ?? 0.0
        accumulator = variableValues[variableName]!
        descriptionAccumulator = variableName
        history.append(variableName as AnyObject)
    }
    
    mutating func performOperation(_ symbol: String) {
        history.append(symbol as AnyObject)
        
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let constant):
                accumulator = constant
                descriptionAccumulator = symbol
                
            case .unary(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
                
            case .binary(let function, let descriptionFunction, let precedence):
                performPendingBinaryOperation()
                
                if currentPrecedence.rawValue < precedence.rawValue {
                    descriptionAccumulator = "(\(descriptionAccumulator))"
                }
                
                currentPrecedence = precedence
                pbo = PendingBinaryOperation(function: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
                
            case .null(let function, let descriptionConstant):
                accumulator = function()
                descriptionAccumulator = descriptionConstant
                
//            case .factorial(let constant, let descriptionConstant): break
//                accumulator = factorial(number: constant)
//                descriptionAccumulator = descriptionConstant
                
            case .equals:
                performPendingBinaryOperation()
                
            case .clear:
                clear()
            }
        }
    }
    
    func getDescription() -> String {
        let space = ((description.hasSuffix(" ")) ? "" : " ")
        
        return (description + space + " ")
    }
}
