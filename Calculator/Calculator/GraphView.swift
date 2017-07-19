//
//  GraphView.swift
//  Calculator
//
//  Created by Mariana Rios Silveira Carvalho on 12/07/17.
//  Copyright © 2017 Mariana Rios Silveira Carvalho. All rights reserved.
//

import UIKit

protocol GraphViewDataSource {
    func getBounds() -> CGRect
    func getYCoordinate(_ x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    var dataSource: GraphViewDataSource?
    
    let color: UIColor = UIColor(red: 45/255.0, green: 105/255.0, blue: 92/255.0, alpha: 1)
    let axes = AxesDrawer(color: UIColor.black)
    
    var graphCenter: CGPoint {
        if origin != nil {
            return convert(origin!, to: superview)
        }
        
        return convert(center, to: superview)
    }
    
    func pinchGraph(_ pinchGesture: UIPinchGestureRecognizer) {
        switch pinchGesture.state {
        case .changed,.ended:
            scale *= pinchGesture.scale
            pinchGesture.scale = 1
        default:
            break
        }
    }
    
    func moveGraph(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .changed: fallthrough
        case .ended:
            let translation = panGesture.translation(in: self)

            origin.x += translation.x
            origin.y += translation.y

            panGesture.setTranslation(CGPoint.zero, in: self)
        default: break
        }
    }
    
    func doubleTap(_ doubleTapGesture: UITapGestureRecognizer) {
        if doubleTapGesture.state == .ended {
            origin = doubleTapGesture.location(in: self)
        }
    }
    
    private func pathForFunction() -> UIBezierPath {
        let path = UIBezierPath()
        
        guard let data = dataSource else {
            return path
        }
        
        var pathIsEmpty = true
        var point = CGPoint()
        
        let width = Int(bounds.size.width * scale)
        
        for pixel in 0...width {
            point.x = CGFloat(pixel) / scale
            
            if let y = data.getYCoordinate((point.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    pathIsEmpty = true
                    continue
                }
                
                point.y = origin.y - y * scale
                
                if pathIsEmpty {
                    path.move(to: point)
                    pathIsEmpty = false
                } else {
                    path.addLine(to: point)
                }
            }
        }
        
        path.lineWidth = 3.0
        return path
    }
    
    override func draw(_ rect: CGRect) {
        axes.drawAxes(in: bounds, origin: graphCenter, pointsPerUnit: 50.0 * scale)
        
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        
        color.set()
        pathForFunction().stroke()
    }
    
}
