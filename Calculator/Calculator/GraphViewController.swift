//
//  GraphViewController.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 12/07/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            let pinch = UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.changeScale(_:)))
            graphView.addGestureRecognizer(pinch)
            
            let move = UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.panGraph(_:)))
            graphView.addGestureRecognizer(move)
            
            let doubleTap = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.doubleTap(_:)))
            doubleTap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTap)
        }
    }

}
