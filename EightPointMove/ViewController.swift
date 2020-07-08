//
//  ViewController.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit

extension CGPoint {
    
    public static func make(_ x: Int, _ y: Int) -> CGPoint {
        CGPoint(x: x, y: y)
    }
    
    public static func make(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: x, y: y)
    }
    
    public static func make(_ x: Double, _ y: Double) -> CGPoint {
        CGPoint(x: x, y: y)
    }
}

class ViewController: UIViewController {
    
    var bsdTouch: BSDTouchPoint?
    
    var bsdTouches = [BSDTouchPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        var sizeArray: [CGSize] = [ .init(width: 7, height: 8), .init(width: 20, height: 20) ]
        
        print("before ", sizeArray)
        for (idx, var lSize) in sizeArray.enumerated() {
            lSize.width += 5
            sizeArray[idx] = lSize
        }
        
        print("after", sizeArray)
        
        
        let sideColors: [BSDSideColor] = [ .make(nil, nil, .red, .blue),
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
        
        var points = [BSDPoint]()
         
        let size = CGSize(width: 50, height: 50)
        
        for idx in 0..<8 {
            
            let ori = oriCoordi[idx]
            
            let bsdP = BSDPoint(horizontalLevel: Int(levels[idx].x) , verticalLevel: Int(levels[idx].y), point: oriCoordi[idx], sideColor: sideColors[idx])
            points.append(bsdP)
            
            let bsdTP = BSDTouchPoint(frame: CGRect(origin: ori, size: size), point: bsdP)
            
            bsdTP.panBlock = { (_, viewPoint) in
                
                UIView.animate(withDuration: 0.1) {
                    bsdTP.center = viewPoint
                }
            }
            
            bsdTP.center = bsdTP.frame.origin
            
            view.addSubview(bsdTP)
            
            bsdTouches.append(bsdTP)
        }
        
        
        BSDPointManager.default.addPoints(points)
        BSDPointManager.default.setUpAllPoints()
        
        
    }


}

