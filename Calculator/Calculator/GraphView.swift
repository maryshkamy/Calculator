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
    var scale: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    var graphOrigin: CGPoint! { didSet { setNeedsDisplay() } }
    
    // Retorna o centro do gráfico.
    var graphCenter: CGPoint {
        if graphOrigin != nil {
            return convert(graphOrigin!, to: superview)
        }
        
        return convert(center, to: superview)
    }
    
    // Altera a escala do gráfico.
    func changeScale(_ pinchGesture: UIPinchGestureRecognizer)
    {
        switch pinchGesture.state {
        case .changed,.ended:
            scale *= pinchGesture.scale
            pinchGesture.scale = 1
        default:
            break
        }
    }
    
    // Move o gráfico.
    func panGraph(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .changed: fallthrough
        case .ended:
            let translation = panGesture.translation(in: self)
            
            // Update anything that depends on the pan gesture using translation.x and translation.y
            graphOrigin.x += translation.x
            graphOrigin.y += translation.y
            
            // Cumulative since start of recognition, get 'incremental' translation
            panGesture.setTranslation(CGPoint.zero, in: self)
        default: break
        }
    }
    
    // Duplo clique. Move a origem do gráfico para onde ocorreu o gesto.
    func doubleTap(_ doubleTapGesture: UITapGestureRecognizer) {
        if doubleTapGesture.state == .ended {
            graphOrigin = doubleTapGesture.location(in: self)
        }
    }
    
    // Desenha a função no gráfico.
    private func pathForFunction() -> UIBezierPath {
        let path = UIBezierPath()
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
        let axes = AxesDrawer(color: UIColor.black, contentScaleFactor: contentScaleFactor)
        axes.drawAxes(in: bounds, origin: graphCenter, pointsPerUnit: 50.0 * scale)
        
        graphOrigin = graphOrigin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        
        UIColor(red: 45/255.0, green: 105/255.0, blue: 92/255.0, alpha: 1).setStroke()
        pathForFunction().stroke()
    }
    
}
