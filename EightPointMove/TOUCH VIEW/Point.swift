//
//  EPMTouchView.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit

struct EPMPoint {
    
    /// Init.
    /// - Parameters:
    ///   - level: The level of the point.
    ///   - point: Coordinate of the point.
    ///   - sideColor: Each side color of the point.
    public init(level: CGPoint, point: CGPoint, sideColor: EPMSideColor = EPMSideColor.empty) {
        self.level = level
        self.point = point
        self.sideColor = sideColor
    }
    
    private enum Side: String {
        case top
        case left
        case right
        case bottom
    }
    
    /// Bond points position.
    public enum BondPointPosition: String {
        /// No relation.
        case none
        /// Top side.
        case top
        /// Left side.
        case left
        /// Right side.
        case right
        /// Bottom side.
        case bottom
        /// Top left.
        case topLeft
        /// Top right.
        case topRight
        /// Bottom left.
        case bottomLeft
        /// Bottom right.
        case bottomRight
    }
    
    public var level: CGPoint = CGPoint.zero
    public var point: CGPoint = CGPoint.zero
    private var sideColor: EPMSideColor
    
    /// `bondPoints` can only be access deep in first level, and should only access its `point`.
    ///
    /// By the updating time, all values were updated one by one, cause `BSDPoint` is value type,
    /// so the former update one can't know the latter updated one's all properties.
    public var bondPoints = [BondPointPosition : EPMPoint]()
    
    /// Real bonded points.
    public var bondPointsR: [EPMPoint] {
        
        var bsds = [EPMPoint]()
        if let top = bondPoints[.top] {
            bsds.append(top)
        }
        if let left = bondPoints[.left] {
            bsds.append(left)
        }
        if let right = bondPoints[.right] {
            bsds.append(right)
        }
        if let bottom = bondPoints[.bottom] {
            bsds.append(bottom)
        }
        
        return bsds
    }
    
    public var bondColors: [BondPointPosition : UIColor?] {
        [ .top: sideColor.top, .left: sideColor.left, .right: sideColor.right, .bottom: sideColor.bottom]
    }
    
    public static var zero: EPMPoint {
        return EPMPoint(level: .zero, point: CGPoint.zero, sideColor: EPMSideColor.empty)
    }
    
    /// Add bonded points.
    ///
    /// Will filter, if has no relation, won't add in.
    ///
    /// - Parameter points: In points.
    public mutating func add(bondPoints points: [EPMPoint]) {
        for p_ in points {
            add(bondPoint: p_)
        }
    }
    
    /// Add bonded point.
    ///
    /// Will filter, if has no relation, won't add in.
    /// - Parameters:
    ///   - point: In point.
    public mutating func add(bondPoint point: EPMPoint) {
        
        guard position(ofPoint: point) != .none else {
            return
        }
        let pos = position(ofPoint: point)
        
        bondPoints[pos] = point
    }
    
    /// Update boned point.
    /// - Parameter point: The bonded point.
    public mutating func update(bondPoint point: EPMPoint) {
        
        guard position(ofPoint: point) != .none else {
            return
        }
        
        bondPoints[ position(ofPoint: point) ] = point
    }
    
    /// Infer the position relation by in point's level.
    /// - Parameter point: In point.
    /// - Returns: The position relation between `self`.
    public func position(ofPoint point: EPMPoint) -> BondPointPosition {
        
        let inLevel = point.level
        let meLevel = self.level
        
        if inLevel.x == meLevel.x && inLevel.y == meLevel.y - 1 {
            return .top
        }
        else if inLevel.y == meLevel.y && inLevel.x == meLevel.x - 1 {
            return .left
        }
        else if inLevel.y == meLevel.y && inLevel.x == meLevel.x + 1 {
            return .right
        }
        else if inLevel.x == meLevel.x && inLevel.y == meLevel.y + 1 {
            return .bottom
        }
        else if inLevel.y == meLevel.y - 1 && inLevel.x == meLevel.x - 1 {
            return .topLeft
        }
        else if inLevel.y == meLevel.y + 1 && inLevel.x == meLevel.x - 1 {
            return .bottomLeft
        }
        else if inLevel.y == meLevel.y + 1 && inLevel.x == meLevel.x + 1 {
            return .bottomRight
        }
        else if inLevel.y == meLevel.y - 1 && inLevel.x == meLevel.x + 1 {
            return .topRight
        }
        
        return .none
    }
    
    /// Limit point out control.
    /// - Parameter newPoint: The point will move to.
    /// - Returns: The limited point that can move to.
    @discardableResult
    public mutating func limit(point aPoint: CGPoint) -> CGPoint {
        guard aPoint != self.point else {
            return self.point
        }
        
        var outPoint = aPoint
        
        // better solution
        limit(of: &outPoint)

        self.point = outPoint
        
        return outPoint
    }

    private func limit(of point: inout CGPoint) {

        let margin: CGFloat = 10.0

        var outPoint = point

        // Top side: left
        func limitTopLeftToTop(_ p: inout CGPoint) {

            var near: CGPoint?
            
            if let topLeft = bondPoints[.topLeft]?.point,
               let top = bondPoints[.top]?.point,
               let line = CGLine(p1: topLeft, p2: top) {

                near = line.nearPointOf(point: p, type: .vert)

            }

            if let near = near, p.y <= near.y {
                p.y = near.y + margin
            }
        }

        // Top side: right
        func limitTopToTopRight(_ p: inout CGPoint) {

            var near: CGPoint?

            if let top = bondPoints[.top]?.point,
               let topRight = bondPoints[.topRight]?.point,
               let line = CGLine(p1: top, p2: topRight) {

                near = line.nearPointOf(point: p, type: .vert)

            }

            if let near = near, p.y <= near.y {
                p.y = near.y + margin
            }
        }

        // Right side: up
        func limitTopRightToRight(_ p: inout CGPoint) {

            var near: CGPoint?

            if let topright = bondPoints[.topRight]?.point,
               let right = bondPoints[.right]?.point,
               let line = CGLine(p1: topright, p2: right) {

                near = line.nearPointOf(point: p, type: .horiz)

            }

            if let near = near, p.x >= near.x {
                p.x = near.x - margin
            }

        }

        // Right side: down
        func limitRightToBottomRight(_ p: inout CGPoint) {

            var near: CGPoint?
            
            if let right = bondPoints[.right]?.point,
               let bottomright = bondPoints[.bottomRight]?.point,
               let line = CGLine(p1: bottomright, p2: right) {

                near = line.nearPointOf(point: p, type: .horiz)

            }

            if let near = near, p.x >= near.x {
                p.x = near.x - margin
            }
        }

        // Bottom side: right
        func limitBottomRightToBottom(_ p: inout CGPoint) {

            var near: CGPoint?

            if let bottomRight = bondPoints[.bottomRight]?.point,
               let bottom = bondPoints[.bottom]?.point,
               let line = CGLine(p1: bottomRight, p2: bottom) {

                near = line.nearPointOf(point: p, type: .vert)

            }

            if let near = near, p.y >= near.y {
                p.y = near.y - margin
            }
        }

        // Bottom: left
        func limitBottomToBottomLeft(_ p: inout CGPoint) {

            var near: CGPoint?

            if let bottom = bondPoints[.bottom]?.point,
               let bottomLeft = bondPoints[.bottomLeft]?.point,
               let line = CGLine(p1: bottom, p2: bottomLeft) {

                near = line.nearPointOf(point: p, type: .vert)

            }

            if let near = near, p.y >= near.y {
                p.y = near.y - margin
            }
        }

        // Left side: down
        func limitBottomLeftToLeft(_ p: inout CGPoint) {

            var near: CGPoint?

            if let bottomLeft = bondPoints[.bottomLeft]?.point,
               let left = bondPoints[.left]?.point,
               let line = CGLine(p1: bottomLeft, p2: left) {

                near = line.nearPointOf(point: p, type: .horiz)
                
            }

            if let near = near, p.x <= near.x {
                p.x = near.x + margin
            }
        }

        // Left side: up
        func limitLeftToTopLeft(_ p: inout CGPoint) {
            
            var near: CGPoint?

            if let left = bondPoints[.left]?.point,
               let topleft = bondPoints[.topLeft]?.point,
               let line = CGLine(p1: left, p2: topleft) {

                near = line.nearPointOf(point: point, type: .horiz)
                
            }

            if let near = near, p.x <= near.x {
                p.x = near.x + margin
            }
        }
        
        if let top = bondPoints[.top]?.point {
            
            if point.x <= top.x {
                limitTopLeftToTop(&outPoint)
            } else {
                limitTopToTopRight(&outPoint)
            }
            
            if bondPoints[.left]?.point == nil {
                limitTopToTopRight(&outPoint)
            }
            
            if bondPoints[.right]?.point == nil {
                limitTopLeftToTop(&outPoint)
            }
        }
        
        if let left = bondPoints[.left]?.point {
            
            if point.y <= left.y {
                limitLeftToTopLeft(&outPoint)
            } else {
                limitBottomLeftToLeft(&outPoint)
            }
            
            if bondPoints[.top]?.point == nil {
                limitBottomLeftToLeft(&outPoint)
            }
            
            if bondPoints[.bottom]?.point == nil {
                limitLeftToTopLeft(&outPoint)
            }
            
        }
        
        if let bottom = bondPoints[.bottom]?.point {
            
            if point.x >= bottom.x {
                limitBottomRightToBottom(&outPoint)
            } else {
                limitBottomToBottomLeft(&outPoint)
            }
            
            if bondPoints[.left]?.point == nil {
                limitBottomRightToBottom(&outPoint)
            }
            
            if bondPoints[.right]?.point == nil {
                limitBottomToBottomLeft(&outPoint)
            }
        }
        
        if let right = bondPoints[.right]?.point {
            
            if point.y >= right.y {
                limitRightToBottomRight(&outPoint)
            } else {
                limitTopRightToRight(&outPoint)
            }
            
            if bondPoints[.top]?.point == nil {
                limitRightToBottomRight(&outPoint)
            }
            
            if bondPoints[.bottom]?.point == nil {
                limitTopRightToRight(&outPoint)
            }
        }
        
        point = outPoint
        
    }
    
}

extension EPMPoint: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.level == rhs.level {
            return true
        }
        return false
    }
}


struct EPMSideColor {
    
    private enum Side: String {
        case top
        case left
        case right
        case bottom
    }
    
    private var colors = [Side : UIColor]()
    
    public var top: UIColor? {
        colors[.top] ?? nil
    }
    
    public var left: UIColor? {
        colors[.left] ?? nil
    }
    
    public var right: UIColor? {
        colors[.right] ?? nil
    }
    
    public var bottom: UIColor? {
        colors[.bottom] ?? nil
    }
    
    public static func make(_ top: UIColor?, _ left: UIColor?, _ right: UIColor?, _ bottom: UIColor?) -> Self {
        Self.init(top: top, left: left, right: right, bottom: bottom)
    }
    
    public static var empty: EPMSideColor {
        Self.init(top: nil, left: nil, right: nil, bottom: nil)
    }
    
    public init(top: UIColor?, left: UIColor?, right: UIColor?, bottom: UIColor?) {
        
        if let top = top {
            colors[.top] = top
        }
        
        if let left = left {
            colors[.left] = left
        }
        
        if let right = right {
            colors[.right] = right
        }
        
        if let bottom = bottom {
            colors[.bottom] = bottom
        }
        
    }
}

