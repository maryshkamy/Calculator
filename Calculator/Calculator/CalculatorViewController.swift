//
//  ViewController.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 11/05/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    private var userIsInMiddleOfTyping: Bool = false
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInMiddleOfTyping {
            if digit != "." || display.text!.range(of: ".") == nil {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                display.text = "0\(digit)"
            }
            else {
                display.text = digit
            }
        }
        userIsInMiddleOfTyping = true
    }
    
    @IBAction func performanceOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperation(displayValue)
            userIsInMiddleOfTyping = false
        }
        
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        
        displayValue = brain.result!
        descriptionDisplay.text = brain.description!
    }
}

