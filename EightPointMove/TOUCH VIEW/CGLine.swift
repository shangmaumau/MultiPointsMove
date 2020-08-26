//
//  CGLine.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import CoreGraphics

public func distanceOf(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return sqrt( pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2) )
}

struct CGLine {
    
    public enum LineType {
        case normal
        case horiz
        case vert
    }
    
    public var p1: CGPoint
    public var p2: CGPoint
    
    public var type: LineType {
        
        if p1.x == p2.x {
            
            return .vert
            
        } else if p1.y == p2.y {
            
            return .horiz
            
        } else {
            
            return .normal
        }
    }

    public init?(p1: CGPoint, p2: CGPoint) {
        
        if p1 == p2 {
            return nil
        }
        
        self.p1 = p1
        self.p2 = p2
    }
    
    public var theLine: ((CGFloat) -> CGFloat) {
        
        func line(x: CGFloat) -> CGFloat {
            return (x - p1.x) / (p2.x - p1.x) * (p2.y - p1.y) + p1.y
        }
        
        return line(x:)
    }
    
    public var k: CGFloat {
        
        if type == .vert {
            return .infinity
        }
        
        return (p1.y - p2.y) / (p1.x - p2.x)
    }
    
    public var b: CGFloat {
        p1.y - k * p1.x
    }
    
    public var x_line: CGFloat? {
        if type == .vert {
            return p1.x
        }
        return nil
    }
    
    public var y_line: CGFloat? {
        if type == .horiz {
            return p1.y
        }
        return nil
    }
    
    public var verticalK: CGFloat {
        -1 / k
    }
    
    public func verticalB(point: CGPoint) -> CGFloat {
        point.y - verticalK * point.x
    }
    
    public func nearpointOf(point: CGPoint) -> CGPoint {
        
        if type != .normal {
            return pedalOf(point: point)
        }
        
        let p1 = CGPoint(x: point.x, y: k * point.x + b)
        let p2 = CGPoint(x: (point.y - b) / k, y: point.y)
        
        let dis1 = distanceOf(p1: p1, p2: point)
        let dis2 = distanceOf(p1: p2, p2: point)
        
        if dis1 < dis2 {
            return p1
        }
        
        return p2
    }
    
    public func pedalOf(point: CGPoint) -> CGPoint {
        
        switch type {
        
        case .normal:
            
            let k1 = k
            let b1 = b
            
            let k2 = verticalK
            let b2 = verticalB(point: point)
            
            let tx = (b1-b2)/(k2-k1)
            let ty = tx * k1 + b1
            
            return CGPoint(x: tx, y: ty)
            
        case .vert:
            
            return CGPoint(x: x_line!, y: point.y)
            
        case .horiz:
            
            return CGPoint(x: point.x, y: y_line!)
        }
        
    }
    
}

public enum PointVectorRelation {
    case clockwise
    case anticlockwise
    case onit
}

func relation(point: CGPoint, line: CGLine) -> PointVectorRelation {
    
    let p1 = line.p1
    let p2 = line.p2
    let p3 = point
    
    let a = (p1.x - p3.x) * (p2.y - p3.y) - (p1.y - p3.y) * (p2.x - p3.x)
    
    if a > 0 {
        return .clockwise
    } else if a < 0 {
        return .anticlockwise
    } else {
        return .onit
    }
}
