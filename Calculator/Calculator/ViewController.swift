//
//  ViewController.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 11/05/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInMiddleOfTyping: Bool = false
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view, typically from a nib.
    //    }
    //
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let number = sender.currentTitle!
        let currentValue = display.text!
        
        if userIsInMiddleOfTyping {
            display.text = currentValue + number
        } else {
            display.text = number
            userIsInMiddleOfTyping = true
        }
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performanceOperation(_ sender: UIButton) {
        brain.setOperand(displayValue)
        userIsInMiddleOfTyping = false
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
            displayValue = brain.result!
        }
    }
}

