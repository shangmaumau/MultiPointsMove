//
//  ViewController.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit


class ViewController: UIViewController {
    
    var bsdClbrView: EPMView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        bsdClbrView = EPMView(frame: view.frame)
        
        view.addSubview(bsdClbrView)
        
        
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

