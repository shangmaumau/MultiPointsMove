//
//  ViewController.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit

class ViewController: UIViewController {
    
    var bsdClbrView: BSDClbrView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        bsdClbrView = BSDClbrView(frame: view.frame)
        
        view.addSubview(bsdClbrView)
        
        
        
    }


}

