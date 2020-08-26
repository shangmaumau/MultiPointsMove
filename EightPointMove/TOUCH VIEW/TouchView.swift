//
//  TouchView.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

class EPMTouchView: UIView {
    
    public var point: EPMPoint = EPMPoint.zero
    public var panBlock: ((UIGestureRecognizer.State, CGPoint) -> Void)?
    
    public init(frame: CGRect, point: EPMPoint) {
        super.init(frame: frame)
        self.point = point
        // addLongPressGesture()
        addPanGesture()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        layer.cornerRadius = frame.width/2.0
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent(_:)))
        self.addGestureRecognizer(longPress)
    }
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func longPressEvent(_ sender: UILongPressGestureRecognizer) {
        guard sender.view != nil else {
            return
        }
        panBlock?(sender.state, sender.location(in: self))
    }
    
    @objc private func panEvent(_ sender: UIPanGestureRecognizer) {
        guard sender.view != nil else {
            return
        }
        
        // superview?.bringSubviewToFront(self)
        
        if sender.state == .began {
            backgroundColor = UIColor.cyan.withAlphaComponent(0.4)
        }
        if sender.state == .ended || sender.state == .cancelled {
            backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        if sender.state == .changed {
            
            point.point = sender.location(in: self.superview)
            
            let direction = sender.direction
            debugPrint("pan direction \(direction)")
            
            if let limitPoint = EPMPointManager.default.limitPoint(point, direction) {
                // 更新 touch 的 point
                self.point = limitPoint
                panBlock?(sender.state, limitPoint.point)
            }
            
        }
    }
    
}
