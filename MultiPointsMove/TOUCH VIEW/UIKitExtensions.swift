//
//  UIKitExtensions.swift
//  MultiPointsMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

extension UIScreen {
    
    class func width() -> CGFloat {
        
        Self.main.bounds.width
    }
    
    class func height() -> CGFloat {
        
        Self.main.bounds.height
    }
    
}


public enum GestureDirection: Int {
    case up, down, left, right, none
    public var isVertical: Bool { return [.up, .down].contains(self) }
    public var isHorizontal: Bool { return [.left, .right].contains(self) }
}

public extension UIPanGestureRecognizer {
    
    var direction: GestureDirection {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return .none
        }
    }
    
}
