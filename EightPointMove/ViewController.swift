//
//  ViewController.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit


class ViewController: UIViewController {
    
    var epmView: EPMShowViewNormal?
    
    var fpmView: EPMShowViewFourPts?
    
    var inTextView: EPMInParamsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        addFourPoints()
        
    }
    
    func addFourPoints() {
        
        fpmView = EPMShowViewFourPts(frame: .zero)
        
        view.addSubview(fpmView!)
        
        fpmView?.snp.makeConstraints({ (make) in
            
            make.edges.equalToSuperview()
        })
    }
    
    func addEightPoints() {
        
        epmView = EPMShowViewNormal(frame: .zero)
        
        view.addSubview(epmView!)
        
        epmView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
      
    }
    
    func addInputView() {
        
        inTextView = EPMInParamsView(frame: .zero)
        
        view.addSubview(inTextView!)
        
        inTextView?.snp.makeConstraints({ (make) in
            
            make.width.equalToSuperview().multipliedBy(0.5)
            make.top.right.bottom.equalToSuperview()
        })
        
    }
    
    func addLineLayer(p0: CGPoint, p1: CGPoint, view: UIView) {
        
        let linePath = UIBezierPath()
        linePath.move(to: p0)
        linePath.addLine(to: p1)
        
        let lineLayer = CAShapeLayer()
        lineLayer.lineWidth = 5.0
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = nil
        
        view.layer.addSublayer(lineLayer)
    }


}

