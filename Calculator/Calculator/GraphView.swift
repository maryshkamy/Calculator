//
//  GraphView.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 12/07/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 1.0
    var graphOrigin: CGPoint?
    var axesColor: UIColor = UIColor.black
    
    var graphCenter: CGPoint {
        if graphOrigin != nil {
            return convert(graphOrigin!, to: superview)
        }
        
        return convert(center, to: superview)
    }
    
    override func draw(_ rect: CGRect) {
        let axes = AxesDrawer(color: axesColor, contentScaleFactor: contentScaleFactor)
        axes.drawAxes(in: bounds, origin: graphCenter, pointsPerUnit: 50.0 * scale)
    }
    
}
