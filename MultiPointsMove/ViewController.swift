//
//  ViewController.swift
//  MultiPointsMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit


class ViewController: UIViewController {
    
    var normalView: MPMShowViewNormal?
    
    var fisheyeView: MPMShowViewFisheye?
    var dummyView: MPMShowViewDummy?
    
    var inTextView: MPMInParamsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        addFourPoints()
        
        // addInputView()
        
    }
    
    func addFourPoints() {
        
        fisheyeView = MPMShowViewFisheye(frame: .zero)
        
        view.addSubview(fisheyeView!)
        
        fisheyeView?.snp.makeConstraints({ (make) in
            
            make.edges.equalToSuperview()
        })
        
        fisheyeView?.setPanBlock { [weak self] in
            self?.dummyView?.updateRoundFourPoints(self!.fisheyeView!.pointManager.pointsMap)
        }
        
        
        dummyView = MPMShowViewDummy(frame: .zero)
        view.insertSubview(dummyView!, belowSubview: fisheyeView!)
        
        dummyView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        dummyView?.setUp(with: fisheyeView!.pointManager.pointsMap)
    }
    
    
    func addEightPoints() {
        
        normalView = MPMShowViewNormal(frame: .zero)
        
        view.addSubview(normalView!)
        
        normalView?.snp.makeConstraints({ (make) in
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

