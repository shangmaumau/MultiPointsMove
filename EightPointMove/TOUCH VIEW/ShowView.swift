//
//  ShowView.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

class EPMView: UIView {
    
    private var bsdTouches = [EPMTouchView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setUp()
        
    }
    
    private func setUp() {
        
        let sideColors: [EPMSideColor] = [ .make(nil, nil, .red, .blue),
                                           .make(.blue, nil, .red, nil),
                                           .make(nil, .red, .yellow, .red),
                                           .make(.red, .red, .yellow, nil),
                                           .make(nil, .yellow, .orange, .yellow),
                                           .make(.yellow, .yellow, .orange, nil),
                                           .make(nil, .orange, nil, .orange),
                                           .make(.orange, .orange, nil, nil) ]
        
        let levels: [CGPoint] = [ .make(0, 0), .make(0, 1),
                                  .make(1, 0), .make(1, 1),
                                  .make(2, 0), .make(2, 1),
                                  .make(3, 0), .make(3, 1)]
        
        let oriCoordi: [CGPoint] = [ .make(334/2.0, 174/2.0), .make(322/2.0, 682/2.0),
                                     .make(568/2.0, 168/2.0), .make(692/2.0, 682/2.0),
                                     .make(850/2.0, 166/2.0), .make(976/2.0, 682/2.0),
                                     .make(1172/2.0, 162/2.0), .make(1260/2.0, 682/2.0)]
        
        var points = [EPMPoint]()
        
        let size = CGSize(width: 50, height: 50)
        
        for idx in 0..<8 {
            
            let ori = oriCoordi[idx]
            
            let bsdP = EPMPoint(horizontalLevel: Int(levels[idx].x) , verticalLevel: Int(levels[idx].y), point: oriCoordi[idx], sideColor: sideColors[idx])
            points.append(bsdP)
            
            let bsdTP = EPMTouchView(frame: CGRect(origin: ori, size: size), point: bsdP)
            
            bsdTP.panBlock = { (_, viewPoint) in
                
                UIView.animate(withDuration: 0.1) {
                    bsdTP.center = viewPoint
                }
                
                EPMShapeLayerManager.default.updatePoint(EPMPointManager.default.pointFromLevel(bsdP.level)!, view: self)
            }
            
            bsdTP.center = bsdTP.frame.origin
            
            addSubview(bsdTP)
            
            bsdTouches.append(bsdTP)
        }
        
        EPMPointManager.default.addPoints(points)
        EPMPointManager.default.setUpAllPoints()
        
        EPMShapeLayerManager.default.addPoints(EPMPointManager.default.points, view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

