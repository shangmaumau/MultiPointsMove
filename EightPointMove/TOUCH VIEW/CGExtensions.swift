//
//  CGExtensions.swift
//  yunweibao
//
//  Created by 尚雷勋 on 2020/7/9.
//  Copyright © 2020 Tongli Inc. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    public static func make(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: x, y: y)
    }
    
    public static func make(_ x: Int, _ y: Int) -> CGPoint {
        CGPoint(x: x, y: y)
    }
    
    public static func make(_ x: Double, _ y: Double) -> CGPoint {
        CGPoint(x: x, y: y)
    }

}

extension CGPoint: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        
        if lhs.x < rhs.x {
            return true
        } else if lhs.x == rhs.x {
            
            if lhs.y < rhs.y {
                return true
            }
            return false
        }
        
        return false
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        
        if lhs.x < rhs.x {
            return true
        } else if lhs.x == rhs.x {
            
            if lhs.y <= rhs.y {
                return true
            }
            return false
        }
        
        return false
        
    }
    
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        if lhs.x > rhs.x {
            return true
        } else if lhs.x == rhs.x {
            
            if lhs.y >= rhs.y {
                return true
            }
            return false
        }
        
        return false
    }
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        
        if lhs.x > rhs.x {
            return true
        } else if lhs.x == rhs.x {
            
            if lhs.y > rhs.y {
                return true
            }
            return false
        }
        
        return false
    }
}

extension CGSize {
    
    public static func make(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        CGSize(width: width, height: height)
    }
    
    public static func make(_ width: Int, _ height: Int) -> CGSize {
        CGSize(width: width, height: height)
    }
    
    public static func make(_ width: Double, _ height: Double) -> CGSize {
        CGSize(width: width, height: height)
    }
}

extension CGVector {
    
    public static func make(_ dx: CGFloat, _ dy: CGFloat) -> CGVector {
        CGVector(dx: dx, dy: dy)
    }
    
    public static func make(_ dx: Int, _ dy: Int) -> CGVector {
        CGVector(dx: dx, dy: dy)
    }
    
    public static func make(_ dx: Double, _ dy: Double) -> CGVector {
        CGVector(dx: dx, dy: dy)
    }

}

extension CGRect {
    
    public static func make(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }
    
    public static func make(_ x: Int, _ y: Int, _ width: Int, _ height: Int) -> CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }
    
    public static func make(_ x: Double, _ y: Double, _ width: Double, _ height: Double) -> CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }
    
    public static func new(y: CGFloat, _ inRect: CGRect) -> CGRect {
        CGRect(x: inRect.minX, y: y, width: inRect.width, height: inRect.height)
    }
}

public func optionalMax<T: Comparable>(_ f1: T?...) -> T? {
    
    var ts = [T]()
    
    for xiaoT in f1 {
        if let reT = xiaoT {
            ts.append(reT)
        }
    }
    
    ts.sort()
    
    return ts.last
}

public func optionalMin<T: Comparable>(_ f1: T?...) -> T? {
    
    var ts = [T]()
    
    for xiaoT in f1 {
        if let reT = xiaoT {
            ts.append(reT)
        }
    }
    
    ts.sort()
    
    return ts.first
}
