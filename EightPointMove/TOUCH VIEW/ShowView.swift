//
//  ShowView.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit
import SnapKit

class EPMView: UIView {
    
    var bsdTouches = [CGPoint : EPMTouchViewRound]()
    
    var touchLine: EPMTouchViewLine!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setUp()
        
    }
    
    func setUp() {
        
        let sideColors: [EPMSideColor] = [ .make(nil, nil, .red, .red),
                                           .make(.red, nil, .red, nil),
                                           .make(nil, .red, .yellow, .red),
                                           .make(.red, .red, .yellow, nil),
                                           .make(nil, .yellow, .green, .yellow),
                                           .make(.yellow, .yellow, .green, nil),
                                           .make(nil, .green, nil, .green),
                                           .make(.green, .green, nil, nil) ]
        
        let levels: [CGPoint] = [ .make(0, 0), .make(0, 1),
                                  .make(1, 0), .make(1, 1),
                                  .make(2, 0), .make(2, 1),
                                  .make(3, 0), .make(3, 1)]
        
//        let oriCoordi: [CGPoint] = [ .make(334/2.0, 174/2.0), .make(322/2.0, 682/2.0),
//                                     .make(568/2.0, 168/2.0), .make(692/2.0, 682/2.0),
//                                     .make(850/2.0, 166/2.0), .make(976/2.0, 682/2.0),
//                                     .make(1172/2.0, 162/2.0), .make(1260/2.0, 682/2.0) ]
        
        let oriCoordi: [CGPoint] = [ .make(319/2.0, 347/2.0), .make(319/2.0, 719/2.0),
                                     .make(424/2.0, 347/2.0), .make(473/2.0, 719/2.0),
                                     .make(582/2.0, 347/2.0), .make(731/2.0, 719/2.0),
                                     .make(742/2.0, 347/2.0), .make(960/2.0, 719/2.0) ]
        
        var points = [EPMPoint]()
        
        let size = CGSize(width: 50, height: 50)
        
        for idx in 0..<8 {
            
            let ori = oriCoordi[idx]
            
            let bsdP = EPMPoint(horizontalLevel: Int(levels[idx].x) , verticalLevel: Int(levels[idx].y), point: oriCoordi[idx], sideColor: sideColors[idx])
            points.append(bsdP)
            
            let bsdTP = EPMTouchViewRound(frame: CGRect(origin: ori, size: size), point: bsdP)
            
//            bsdTP.setPanBlock { (_, viewPoint) in
//
//                UIView.animate(withDuration: 0.1) {
//                    bsdTP.center = viewPoint
//                }
//
//                EPMShapeLayerManager.default.updatePoint(EPMPointManager.default.point(ofLevel: bsdP.level)!, view: self)
//            }
            
            bsdTP.center = bsdTP.frame.origin
            
            addSubview(bsdTP)
            
            bsdTouches[levels[idx]] = bsdTP
        }
        
        EPMPointManager.default.addPoints(points)
        EPMPointManager.default.setUpAllPoints()
        
        EPMShapeLayerManager.default.addPoints(EPMPointManager.default.points, view: self)
        
        addTouchLine()
    }
    
    func addTouchLine() {
        
        if var p00 = EPMPointManager.default.point(ofLevel: .make(0, 0)),
           let p01 = EPMPointManager.default.point(ofLevel: .make(0, 1)),
           var p10 = EPMPointManager.default.point(ofLevel: .make(1, 0)),
           let p11 = EPMPointManager.default.point(ofLevel: .make(1, 1)),
           var p20 = EPMPointManager.default.point(ofLevel: .make(2, 0)),
           let p21 = EPMPointManager.default.point(ofLevel: .make(2, 1)),
           var p30 = EPMPointManager.default.point(ofLevel: .make(3, 0)),
           let p31 = EPMPointManager.default.point(ofLevel: .make(3, 1)) {
            
            let lheight: CGFloat = 30.0
            let lineRect = CGRect.make(p00.point.x, p00.point.y - lheight / 2.0, p30.point.x - p00.point.x, lheight)
            
            if let line0 = CGLine(p1: p00.point, p2: p01.point),
               let line1 = CGLine(p1: p10.point, p2: p11.point),
               let line2 = CGLine(p1: p20.point, p2: p21.point),
               let line3 = CGLine(p1: p30.point, p2: p31.point) {
                
                touchLine = EPMTouchViewLine(frame: lineRect, point: .zero)
                
                touchLine.setPanBlock { [weak self] (state, point) in
                    
                    guard let self = self else { return }
                    
                    let newy = point.y
                    let newp = CGPoint.make(p00.point.x, newy)
                    
                    let ptoline0 = line0.nearPointOf(point: newp, type: .horiz)
                    let ptoline1 = line1.nearPointOf(point: newp, type: .horiz)
                    let ptoline2 = line2.nearPointOf(point: newp, type: .horiz)
                    let ptoline3 = line3.nearPointOf(point: newp, type: .horiz)
                    
                    p00.point = ptoline0
                    p10.point = ptoline1
                    p20.point = ptoline2
                    p30.point = ptoline3
                    
                    EPMPointManager.default.updatePoint(p00)
                    EPMPointManager.default.updatePoint(p10)
                    EPMPointManager.default.updatePoint(p20)
                    EPMPointManager.default.updatePoint(p30)
                    
                    EPMPointManager.default.setUpAllPoints()
                    
                    EPMShapeLayerManager.default.updatePoint(EPMPointManager.default.point(ofLevel: .make(0, 0))!, view: self)
                    EPMShapeLayerManager.default.updatePoint(EPMPointManager.default.point(ofLevel: .make(1, 0))!, view: self)
                    EPMShapeLayerManager.default.updatePoint(EPMPointManager.default.point(ofLevel: .make(2, 0))!, view: self)
                    EPMShapeLayerManager.default.updatePoint(EPMPointManager.default.point(ofLevel: .make(3, 0))!, view: self)
                    
                    let newwidth = abs(ptoline3.x - p00.point.x)
                    
                    UIView.animate(withDuration: 0.05) {
                        self.touchLine.frame = lineRect.new(y: newy - lheight / 2.0).new(width: newwidth)
                        
                        // 更新 touch point 的位置
                        
                        self.bsdTouches[.make(0, 0)]?.center = ptoline0
                        self.bsdTouches[.make(1, 0)]?.center = ptoline1
                        self.bsdTouches[.make(2, 0)]?.center = ptoline2
                        self.bsdTouches[.make(3, 0)]?.center = ptoline3
                        
                    }
                    
                }
                
                addSubview(touchLine)
                
            }
            
            
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

