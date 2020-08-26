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
    ///   - horizontalLevel: Horizontal level, start from 0.
    ///   - verticalLevel: Vertical level, start from 0.
    ///   - point: Coordinate of the point.
    public init(horizontalLevel: Int, verticalLevel: Int, point: CGPoint, sideColor: EPMSideColor = EPMSideColor.empty) {
        level = CGPoint(x: horizontalLevel, y: verticalLevel)
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
        return EPMPoint(horizontalLevel: 0, verticalLevel: 0, point: CGPoint.zero, sideColor: EPMSideColor.empty)
    }
    
    /// Add bonded points.
    ///
    /// Will filter, if has no relation, won't add in.
    ///
    /// - Parameter points: In points.
    public mutating func addBondPoints(_ points: [EPMPoint]) {
        for p_ in points {
            addBondPoint(p_)
        }
    }
    
    /// Add bonded point.
    ///
    /// Will filter, if has no relation, won't add in.
    /// - Parameters:
    ///   - point: In point.
    public mutating func addBondPoint(_ point: EPMPoint) {
        
        guard positionFromPoint(point) != .none else {
            return
        }
        let pos = positionFromPoint(point)
        
        bondPoints[pos] = point
    }
    
    /// Update boned point.
    /// - Parameter point: The bonded point.
    public mutating func updateBondPoint(_ point: EPMPoint) {
        
        guard positionFromPoint(point) != .none else {
            return
        }
        
        bondPoints[ positionFromPoint(point) ] = point
    }
    
    /// Infer the position relation by in point's level.
    /// - Parameter point: In point.
    /// - Returns: The position relation between `self`.
    public func positionFromPoint(_ point: EPMPoint) -> BondPointPosition {
        
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
    public mutating func limitPoint(_ newPoint: CGPoint, _ direction: GestureDirection) -> CGPoint {
        guard newPoint != self.point else {
            return self.point
        }
        
        debugPrint("newPoint: \(newPoint)")
        
        var outPoint = newPoint
        
        let margin: CGFloat = 10.0
        
        /// 求出更近的点
        func nearestOf(p1: CGPoint?, p2: CGPoint?) -> CGPoint? {
            
            var dis1: CGFloat?
            var dis2: CGFloat?
            
            if let point1 = p1 {
                dis1 = distanceOf(p1: point1, p2: newPoint)
            }
            
            if let point2 = p2 {
                dis2 = distanceOf(p1: point2, p2: newPoint)
            }
            
            if dis1 != nil && dis2 == nil {
                return p1
            }
            else if dis2 != nil && dis1 == nil {
                return p2
            }
            else if dis1 == nil && dis2 == nil {
                return nil
            }
            else if dis1! >= dis2! {
                return p2
            }
            else if dis2! > dis1! {
                return p1
            }
            
            return nil
        }
        
        
        // new solution
        
        debugPrint("点往左边移动")
        
        var near11: CGPoint?
        var near21: CGPoint?
        
        // 左上线的限制点
        if let left = bondPoints[.left]?.point,
           let topleft = bondPoints[.topLeft]?.point,
           let line = CGLine(p1: left, p2: topleft) {
            
            near11 = line.nearpointOf(point: newPoint)
            
            debugPrint("near1 \(near11!)")
        }
        
        // 左下线的限制点
        if let left = bondPoints[.bottomLeft]?.point,
           let bottomLeft = bondPoints[.left]?.point,
           let line = CGLine(p1: bottomLeft, p2: left) {
            
            near21 = line.nearpointOf(point: newPoint)
            
            debugPrint("near2 \(near21!)")
        }
        
        // 横轴方向，限制 x
        // 对于左侧限制，不让此点靠近距离左线最近点的右边 10
        if let tar = nearestOf(p1: near11, p2: near21) {
            
            debugPrint("tar \(tar)")
            
            if newPoint.x < tar.x {
                outPoint.x = tar.x + margin
            }
        }
        
        
        var near12: CGPoint?
        var near22: CGPoint?
        
        // 右上线的限制点
        if let topright = bondPoints[.topRight]?.point,
           let right = bondPoints[.right]?.point,
           let line = CGLine(p1: topright, p2: right) {
            
            near12 = line.nearpointOf(point: newPoint)
            
        }
        
        // 右下线的限制点
        if let right = bondPoints[.right]?.point,
           let bottomright = bondPoints[.bottomRight]?.point,
           let line = CGLine(p1: bottomright, p2: right) {
            
            near22 = line.nearpointOf(point: newPoint)
            
        }
        
        // 横轴方向，限制 x
        // 对于右侧限制，不让此点靠近距离右线（两根线四个点）最近点的右边 10
        if let tar = nearestOf(p1: near12, p2: near22) {
            
            if newPoint.x > tar.x {
                outPoint.x = tar.x - margin
            }
        }
        
        
        var near13: CGPoint?
        var near23: CGPoint?
        
        // 上左 线的限制点
        if let topright = bondPoints[.topLeft]?.point,
           let right = bondPoints[.top]?.point,
           let line = CGLine(p1: topright, p2: right) {
            
            near13 = line.nearpointOf(point: newPoint)
            
        }
        
        // 上右 线的限制点
        if let right = bondPoints[.top]?.point,
           let bottomright = bondPoints[.topRight]?.point,
           let line = CGLine(p1: bottomright, p2: right) {
            
            near23 = line.nearpointOf(point: newPoint)
            
        }
        
        // 横轴方向，限制 x
        // 对于右侧限制，不让此点靠近距离右线（两根线四个点）最近点的右边 10
        if let tar = nearestOf(p1: near13, p2: near23) {
            
            if newPoint.y < tar.y {
                outPoint.y = tar.y + margin
            }
        }
        
        
        var near14: CGPoint?
        var near24: CGPoint?
        
        // 下右 线的限制点
        if let topright = bondPoints[.bottomRight]?.point,
           let right = bondPoints[.bottom]?.point,
           let line = CGLine(p1: topright, p2: right) {
            
            near14 = line.nearpointOf(point: newPoint)
            
        }
        
        // 下左 线的限制点
        if let right = bondPoints[.bottom]?.point,
           let bottomright = bondPoints[.bottomLeft]?.point,
           let line = CGLine(p1: bottomright, p2: right) {
            
            near24 = line.nearpointOf(point: newPoint)
            
        }
        
        // 横轴方向，限制 x
        // 对于右侧限制，不让此点靠近距离右线（两根线四个点）最近点的右边 10
        if let tar = nearestOf(p1: near14, p2: near24) {
            
            if newPoint.y > tar.y {
                outPoint.y = tar.y - margin
            }
        }
        
        debugPrint("outPoint: \(outPoint)")
        self.point = outPoint
        
        return outPoint
        
        
        // old solution
//        if let topLimit = limitSide(.top) {
//            if newPoint.y < topLimit {
//                outPoint.y = topLimit + margin
//            }
//        }
//
//        if let leftLimit = limitSide(.left) {
//            if newPoint.x < leftLimit {
//                outPoint.x = leftLimit + margin
//            }
//        }
//
//        if let rightLimit = limitSide(.right) {
//            if newPoint.x > rightLimit {
//                outPoint.x = rightLimit - margin
//            }
//        }
//
//        if let bottomLimit = limitSide(.bottom) {
//            if newPoint.y > bottomLimit {
//                outPoint.y = bottomLimit - margin
//            }
//        }
//
//        self.point = outPoint
//
//        return outPoint
    }
    
    
    private func limitSide(_ side: Side) -> CGFloat? {
        
        var result: CGFloat?
        
        switch side {
        case .top:
            result = bsdMax2(bondPoints[.top]?.point.y, bondPoints[.topLeft]?.point.y, bondPoints[.topRight]?.point.y)
            
        case .left:
            result = bsdMax2(bondPoints[.left]?.point.x, bondPoints[.topLeft]?.point.x, bondPoints[.bottomLeft]?.point.x)
            
        case .right:
            result = bsdMin2(bondPoints[.right]?.point.x, bondPoints[.topRight]?.point.x, bondPoints[.bottomRight]?.point.x)
            
        case .bottom:
            result = bsdMin2(bondPoints[.bottom]?.point.y, bondPoints[.bottomLeft]?.point.y, bondPoints[.bottomRight]?.point.y)
        }
        
        return result
    }
    
    private func bsdMax2<T: Comparable>(_ f1: T?...) -> T? {
        
        var ts = [T]()
        
        for xiaoT in f1 {
            if let reT = xiaoT {
                ts.append(reT)
            }
        }
        
        ts.sort()
        
        return ts.last
    }
    
    private func bsdMin2<T: Comparable>(_ f1: T?...) -> T? {
        
        var ts = [T]()
        
        for xiaoT in f1 {
            if let reT = xiaoT {
                ts.append(reT)
            }
        }
        
        ts.sort()
        
        return ts.first
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


class EPMView: UIView {
    
    private var bsdTouches = [EPMTouchView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setUp()
        
    }
    
    private func setUp() {
        
        let sideColors: [EPMSideColor] = [ .make(nil, nil, .red, .blue),
                                           .make(.blue, nil, .red, nil),
                                           .make(nil, .red, .yellow, .red),
                                           .make(.red, .red, .yellow, nil),
                                           .make(nil, .yellow, .orange, .yellow),
                                           .make(.yellow, .yellow, .orange, nil),
                                           .make(nil, .orange, nil, .orange),
                                           .make(.orange, .orange, nil, nil) ]
        
        let levels: [CGPoint] = [ .make(0, 0), .make(0, 1),
                                  .make(1, 0), .make(1, 1),
                                  .make(2, 0), .make(2, 1),
                                  .make(3, 0), .make(3, 1)]
        
        let oriCoordi: [CGPoint] = [ .make(334/2.0, 174/2.0), .make(322/2.0, 682/2.0),
                                     .make(568/2.0, 168/2.0), .make(692/2.0, 682/2.0),
                                     .make(850/2.0, 166/2.0), .make(976/2.0, 682/2.0),
                                     .make(1172/2.0, 162/2.0), .make(1260/2.0, 682/2.0)]
        
        var points = [EPMPoint]()
        
        let size = CGSize(width: 50, height: 50)
        
        for idx in 0..<8 {
            
            let ori = oriCoordi[idx]
            
            let bsdP = EPMPoint(horizontalLevel: Int(levels[idx].x) , verticalLevel: Int(levels[idx].y), point: oriCoordi[idx], sideColor: sideColors[idx])
            points.append(bsdP)
            
            let bsdTP = EPMTouchView(frame: CGRect(origin: ori, size: size), point: bsdP)
            
            bsdTP.panBlock = { (_, viewPoint) in
                
                UIView.animate(withDuration: 0.1) {
                    bsdTP.center = viewPoint
                }
                
                EPMShapeLayerManager.default.updatePoint(EPMPointManager.default.pointFromLevel(bsdP.level)!, view: self)
            }
            
            bsdTP.center = bsdTP.frame.origin
            
            addSubview(bsdTP)
            
            bsdTouches.append(bsdTP)
        }
        
        EPMPointManager.default.addPoints(points)
        EPMPointManager.default.setUpAllPoints()
        
        EPMShapeLayerManager.default.addPoints(EPMPointManager.default.points, view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
