//
//  ShapeLayer.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

class EPMShapeLayer: CAShapeLayer {
    
    public var identifier: String!
    
    init(identifier: String) {
        super.init()
        self.identifier = identifier
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EPMShapeLayerManager: NSObject {
    
    private static func identifierFrom(p1: CGPoint, p2: CGPoint) -> String {
        var ps = [ p1, p2 ]
        ps.sort()
        var identi = ""
        for ele in ps {
            identi = identi + " \(ele.x)" + " \(ele.y)"
        }
        return identi
    }
    
    public func addPoints(_ points: [EPMPoint], view: UIView) {
        for p_ in points {
            addLayersFrom(point: p_, view: view)
        }
    }
    
    public func updatePoint(_ point: EPMPoint, view: UIView) {
        removeLayersFrom(point: point, view: view)
        addLayersFrom(point: point, view: view)
    }
    
    private func removeLayersFrom(point: EPMPoint, view: UIView) {
        
        var ids = [String]()
        for pp in point.bondPointsR {
            ids.append( Self.identifierFrom(p1: point.level, p2: pp.level) )
        }
        
        if let layers = view.layer.sublayers {
            for layer in layers {
                if let layer = layer as? EPMShapeLayer {
                    if ids.firstIndex(of: layer.identifier) != nil {
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    private func addLayersFrom(point: EPMPoint, view: UIView) {
        
        var ids = [String]()
        for pp in point.bondPointsR {
            ids.append( Self.identifierFrom(p1: point.level, p2: pp.level) )
        }
        
        if let layers = view.layer.sublayers {
            for layer in layers {
                if let layer = layer as? EPMShapeLayer {
                    if let idx = ids.firstIndex(of: layer.identifier) {
                        ids.remove(at: idx)
                    }
                }
            }
        }
        
        for pp in point.bondPointsR {
            
            if ids.firstIndex(of: Self.identifierFrom(p1: point.level, p2: pp.level)) != nil {
                addLineLayer(p0: point, p1: pp, view: view)
            }
        }
        
    }
    
    private func addLineLayer(p0: EPMPoint, p1: EPMPoint, view: UIView) {
        
        let linePath = UIBezierPath()
        linePath.move(to: p0.point)
        linePath.addLine(to: p1.point)
        
        let color = p0.bondColors[ p0.positionFromPoint(p1) ]
        
        let lineLayer = EPMShapeLayer.init(identifier: Self.identifierFrom(p1: p0.level, p2: p1.level))
        lineLayer.lineWidth = 5.0
        lineLayer.strokeColor = color!!.cgColor
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = nil
        view.layer.addSublayer(lineLayer)
    }
    
}
