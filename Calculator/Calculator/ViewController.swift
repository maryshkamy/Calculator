//
//  ViewController.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 11/05/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var Display: UILabel!
    
    var userIsInMiddleOfTyping: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TouchButton(_ sender: UIButton) {
        let number = sender.currentTitle!
        let currentValue = Display.text!
        
        if userIsInMiddleOfTyping {
            Display.text = currentValue + number
        } else {
            Display.text = number
            userIsInMiddleOfTyping = true
        }
        
    }

    @IBAction func PerformanceOperation(_ sender: UIButton) {
        userIsInMiddleOfTyping = false
        if let mathematicalOperation = sender.currentTitle {
            switch mathematicalOperation {
            case "π":
                Display.text = String(Double.pi)
            default:
                break
            }
        }
    }
}

