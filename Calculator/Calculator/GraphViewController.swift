//
//  GraphViewController.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 12/07/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    var function: ((CGFloat) -> Double)?
    
    func getBounds() -> CGRect {
        return navigationController?.view.bounds ?? view.bounds
    }
    
    func getYCoordinate(_ x: CGFloat) -> CGFloat? {
        if let function = function {
            return CGFloat(function(x))
        }
        
        return nil
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            
            let pinch = UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.pinchGraph(_:)))
            graphView.addGestureRecognizer(pinch)
            
            let move = UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.moveGraph(_:)))
            graphView.addGestureRecognizer(move)
            
            let doubleTap = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.doubleTap(_:)))
            doubleTap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTap)
        }
    }

}
