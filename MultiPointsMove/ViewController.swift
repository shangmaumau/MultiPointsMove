//
//  ViewController.swift
//  MultiPointsMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit


class ViewController: UIViewController {
    
    var MPMView: MPMShowViewNormal?
    
    var fpmView: MPMShowViewFourPts?
    
    var inTextView: MPMInParamsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        addFourPoints()
        
        // addInputView()
        
    }
    
    func addFourPoints() {
        
        fpmView = MPMShowViewFourPts(frame: .zero)
        
        view.addSubview(fpmView!)
        
        fpmView?.snp.makeConstraints({ (make) in
            
            make.edges.equalToSuperview()
        })
    }
    
    func addEightPoints() {
        
        MPMView = MPMShowViewNormal(frame: .zero)
        
        view.addSubview(MPMView!)
        
        MPMView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
      
    }
    
    func addInputView() {
        
        inTextView = MPMInParamsView(frame: .zero)
        
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

