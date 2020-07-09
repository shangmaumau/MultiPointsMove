//
//  BSDTouchPoint.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/7/7.
//

import UIKit

class BSDPointManager: NSObject {
    
    public static let `default`: BSDPointManager = {
        return BSDPointManager()
    }()
    
    public private(set) var points = [BSDPoint]()
    
    // MARK:- Add point
    
    /// Add points.
    /// - Parameter points: In points.
    public func addPoints(_ points: [BSDPoint]) {
        for p_ in points {
            addPoint(p_)
        }
    }
    
    /// Add point.
    ///
    /// If `points` contains this point, won't add in.
    /// - Parameter point: In point.
    public func addPoint(_ point: BSDPoint) {
        
        guard points.firstIndex(of: point) == nil else {
            return
        }
        
        points.append(point)
    }
    
    // MARK:- Set up points
    
    /// Set up all points.
    public func setUpAllPoints() {
        
        for (idx, var _p) in points.enumerated() {
            _p.addBondPoints(points)
            points[idx] = _p
        }
    }
    
    /// Remove point.
    /// - Parameter point: In point.
    public func removePoint(_ point: BSDPoint) {
        
        guard points.firstIndex(of: point) != nil else {
            return
        }
        
        points.remove(at: points.firstIndex(of: point)!)

        // TODO: Should add the handle after removement.
    }
    
    /// Update point.
    /// - Note: Call this after all the points were added.
    /// - Parameter point: In point.
    private func updatePoint(_ point: BSDPoint) {
        
        guard let idx = points.firstIndex(of: point) else {
            return
        }
        points[idx] = point
        
        for (idx, var point_) in points.enumerated() {
            point_.updateBondPoint(point)
            points[idx] = point_
        }
        
    }
    
    // MARK:- Limit point.
    
    public func limitPoint(_ newPoint: BSDPoint) -> BSDPoint? {
        
        if var nP = pointFromLevel(newPoint.level) {
            nP.limitPoint(newPoint.point)
            updatePoint(nP)
            return pointFromLevel(nP.level)
        }
        
        return nil
    }
    
    // MARK:- Methods
    
    /// Fetch the element by its `level`.
    /// - Parameter level: Element's level.
    /// - Returns: The point.
    public func pointFromLevel(_ level: CGPoint) -> BSDPoint? {
        
        for point in points {
            if point.level == level {
                return point
            }
        }
        return nil
    }
    
}

struct BSDSideColor {
    
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
    
    public static var empty: BSDSideColor {
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

struct BSDPoint {
    
    /// Init.
    /// - Parameters:
    ///   - horizontalLevel: Horizontal level, start from 0.
    ///   - verticalLevel: Vertical level, start from 0.
    ///   - point: Coordinate of the point.
    public init(horizontalLevel: Int, verticalLevel: Int, point: CGPoint, sideColor: BSDSideColor = BSDSideColor.empty) {
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
    private var sideColor: BSDSideColor
    
    /// `bondPoints` can only be access deep in first level, and should only access its `point`.
    ///
    /// By the updating time, all values were updated one by one, cause `BSDPoint` is value type,
    /// so the former update one can't know the latter updated one's all properties.
    public var bondPoints = [BondPointPosition : BSDPoint]()
    
    /// Real bonded points.
    public var bondPointsR: [BSDPoint] {
        
        var bsds = [BSDPoint]()
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
    
    public static var zero: BSDPoint {
        return BSDPoint(horizontalLevel: 0, verticalLevel: 0, point: CGPoint.zero, sideColor: BSDSideColor.empty)
    }
    
    /// Add bonded points.
    ///
    /// Will filter, if has no relation, won't add in.
    ///
    /// - Parameter points: In points.
    public mutating func addBondPoints(_ points: [BSDPoint]) {
        for p_ in points {
            addBondPoint(p_)
        }
    }
    
    /// Add bonded point.
    ///
    /// Will filter, if has no relation, won't add in.
    /// - Parameters:
    ///   - point: In point.
    public mutating func addBondPoint(_ point: BSDPoint) {
        
        guard positionFromPoint(point) != .none else {
            return
        }
        let pos = positionFromPoint(point)
        
        bondPoints[pos] = point
    }
    
    /// Update boned point.
    /// - Parameter point: The bonded point.
    public mutating func updateBondPoint(_ point: BSDPoint) {
        
        guard positionFromPoint(point) != .none else {
            return
        }
        
        bondPoints[ positionFromPoint(point) ] = point
    }
    
    /// Infer the position relation by in point's level.
    /// - Parameter point: In point.
    /// - Returns: The position relation between `self`.
    public func positionFromPoint(_ point: BSDPoint) -> BondPointPosition {
        
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
    public mutating func limitPoint(_ newPoint: CGPoint) -> CGPoint {
        guard newPoint != self.point else {
            return self.point
        }
        
        var outPoint = newPoint
        
        let margin: CGFloat = 10.0
        
        if let topLimit = limitSide(.top) {
            if newPoint.y < topLimit {
                outPoint.y = topLimit + margin
            }
        }
        
        if let leftLimit = limitSide(.left) {
            if newPoint.x < leftLimit {
                outPoint.x = leftLimit + margin
            }
        }
        
        if let rightLimit = limitSide(.right) {
            if newPoint.x > rightLimit {
                outPoint.x = rightLimit - margin
            }
        }
        
        if let bottomLimit = limitSide(.bottom) {
            if newPoint.y > bottomLimit {
                outPoint.y = bottomLimit - margin
            }
        }
        
        self.point = outPoint
        
        return outPoint
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

extension BSDPoint: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.level == rhs.level {
            return true
        }
        return false
    }
}

class BSDTouchPoint: UIView {
    
    public var point: BSDPoint = BSDPoint.zero
    public var panBlock: ((UIGestureRecognizer.State, CGPoint) -> Void)?
    
    public init(frame: CGRect, point: BSDPoint) {
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
        
        if sender.state == .began {
            backgroundColor = UIColor.cyan.withAlphaComponent(0.4)
        }
        if sender.state == .ended || sender.state == .cancelled {
            backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        if sender.state == .changed {
            
            point.point = sender.location(in: self.superview)
            
            if let limitPoint = BSDPointManager.default.limitPoint(point) {
                // 更新 touch 的 point
                self.point = limitPoint
                panBlock?(sender.state, limitPoint.point)
            }
            
        }
    }
    
}

class BSDShapeLayer: CAShapeLayer {
    
    public var identifier: String!
    
    init(identifier: String) {
        super.init()
        self.identifier = identifier
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BSDShapeLayerManager: NSObject {
    
    public static let `default`: BSDShapeLayerManager = {
       return BSDShapeLayerManager()
    }()
    
    private static func identifierFrom(p1: CGPoint, p2: CGPoint) -> String {
        var ps = [ p1, p2 ]
        ps.sort()
        var identi = ""
        for ele in ps {
            identi = identi + " \(ele.x)" + " \(ele.y)"
        }
        return identi
    }
    
    public func addPoints(_ points: [BSDPoint], view: UIView) {
        for p_ in points {
            addLayersFrom(point: p_, view: view)
        }
    }
    
    public func updatePoint(_ point: BSDPoint, view: UIView) {
        removeLayersFrom(point: point, view: view)
        addLayersFrom(point: point, view: view)
    }
    
    private func removeLayersFrom(point: BSDPoint, view: UIView) {
        
        var ids = [String]()
        for pp in point.bondPointsR {
            ids.append( Self.identifierFrom(p1: point.level, p2: pp.level) )
        }
        
        if let layers = view.layer.sublayers {
            for layer in layers {
                if let layer = layer as? BSDShapeLayer {
                    if ids.firstIndex(of: layer.identifier) != nil {
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    private func addLayersFrom(point: BSDPoint, view: UIView) {
        
        var ids = [String]()
        for pp in point.bondPointsR {
            ids.append( Self.identifierFrom(p1: point.level, p2: pp.level) )
        }
        
        if let layers = view.layer.sublayers {
            for layer in layers {
                if let layer = layer as? BSDShapeLayer {
                    if let idx = ids.firstIndex(of: layer.identifier) {
                        ids.remove(at: idx)
                    }
                }
            }
        }
        
        for pp in point.bondPointsR {
            
            if ids.firstIndex(of: Self.identifierFrom(p1: point.level, p2: pp.level)) != nil {
                addLineLayer(p0: point, p1: pp, view: view)
            }
        }
        
    }
    
    private func addLineLayer(p0: BSDPoint, p1: BSDPoint, view: UIView) {
        
        let linePath = UIBezierPath()
        linePath.move(to: p0.point)
        linePath.addLine(to: p1.point)
        
        let color = p0.bondColors[ p0.positionFromPoint(p1) ]
        
        let lineLayer = BSDShapeLayer.init(identifier: Self.identifierFrom(p1: p0.level, p2: p1.level))
        lineLayer.lineWidth = 5.0
        lineLayer.strokeColor = color!!.cgColor
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = nil
        view.layer.addSublayer(lineLayer)
    }
    
}
