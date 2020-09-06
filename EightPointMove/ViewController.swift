//
//  ViewController.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit


class ViewController: UIViewController {
    
    var bsdClbrView: EPMView!
    
    var inputView_c: InputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        bsdClbrView = EPMView(frame: view.frame)
        
        view.addSubview(bsdClbrView)
        
        inputView_c = InputView(frame: .zero)
        
        view.addSubview(inputView_c)
        inputView_c.snp.makeConstraints { (make) in
            
            make.width.equalToSuperview().multipliedBy(0.5)
            make.top.right.bottom.equalToSuperview()
            
        }
        
        
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

