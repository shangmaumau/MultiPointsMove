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
    
    public func addPoints(_ points: [BSDPoint]) {
        for p_ in points {
            addPoint(p_)
        }
    }
    
    /// 添加点
    ///
    /// 如果数组中已经有此点，则不添加
    /// - Parameter point: 要添加的点
    public func addPoint(_ point: BSDPoint) {
        
        guard points.firstIndex(of: point) == nil else {
            return
        }
        
        points.append(point)
    }
    
    public func setUpAllPoints() {
        
        for (idx, var _p) in points.enumerated() {
            _p.addBondPoints(points)
            points[idx] = _p
        }
    }
    
    /// 移除点
    /// - Parameter point: 要移除的点
    public func removePoint(_ point: BSDPoint) {
        
        guard points.firstIndex(of: point) != nil else {
            return
        }
        
        points.remove(at: points.firstIndex(of: point)!)
    }
    
    /// 更新点
    /// - Note: 更新点的时候，必须是已经添加了所有需要用到的点
    /// - Parameter point: 要更新的点
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
    
    public func limitPoint(_ newPoint: BSDPoint) -> BSDPoint? {
        
        if var nP = pointFromLevel(newPoint.level) {
            nP.limitPoint(newPoint.point)
            updatePoint(nP)
            // 返回更新之后的点
            return pointFromLevel(nP.level)
        }
        
        return nil
    }
    
    private func pointFromLevel(_ level: CGPoint) -> BSDPoint? {
        
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
        return Self.init(top: nil, left: nil, right: nil, bottom: nil)
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
    
    /// 构造函数
    /// - Parameters:
    ///   - horizontalLevel: 水平方向的层级，从 0 开始
    ///   - verticalLevel: 垂直方向的层级，从 0 开始
    ///   - point: 一般来说，这里应该是像素点
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
    
    /// 关联点方位
    public enum BondPointPosition: String {
        /// 与此点无关系的点
        case none
        /// 在此点上方
        case top
        /// 在此点左方
        case left
        /// 在此点右方
        case right
        /// 在此点下方
        case bottom
        /// 左上方
        case topLeft
        /// 右上方
        case topRight
        /// 左下方
        case bottomLeft
        /// 右下方
        case bottomRight
    }
    
    public var level: CGPoint = CGPoint.zero
    public var point: CGPoint = CGPoint.zero
    private var sideColor: BSDSideColor
    
    public var bondPoints = [BondPointPosition : BSDPoint]()
    public var bondColors: [BondPointPosition : UIColor?] {
        [ .top: sideColor.top, .left: sideColor.left, .right: sideColor.right, .bottom: sideColor.bottom]
    }
    
    public static var zero: BSDPoint {
        return BSDPoint(horizontalLevel: 0, verticalLevel: 0, point: CGPoint.zero, sideColor: BSDSideColor.empty)
    }
    
    /// 添加多个关联点
    ///
    /// 会自动筛选，如果不是和本点有关联的点，则不添加
    ///
    /// - Parameter points:
    public mutating func addBondPoints(_ points: [BSDPoint]) {
        for p_ in points {
            addBondPoint(p_)
        }
    }
    
    /// 添加关联点
    ///
    /// 会自动筛选，如果不是和本点有关联的点，则不添加
    /// - Parameters:
    ///   - point: 点
    public mutating func addBondPoint(_ point: BSDPoint) {
        
        guard positionFromPoint(point) != .none else {
            return
        }
        let pos = positionFromPoint(point)
        
        bondPoints[pos] = point
    }
    
    /// 更新关联点
    /// - Parameter point: 与本点关联的点
    public mutating func updateBondPoint(_ point: BSDPoint) {
        
        guard positionFromPoint(point) != .none else {
            return
        }
        
        bondPoints[ positionFromPoint(point) ] = point
    }
    
    /// 由点的 level 推断出与本点的方位关系
    /// - Parameter point: 需要推断的点
    /// - Returns: 与本点的方位关系
    private func positionFromPoint(_ point: BSDPoint) -> BondPointPosition {
        
        let inLevel = point.level
        let meLevel = self.level
        
        // 上
        if inLevel.x == meLevel.x && inLevel.y == meLevel.y - 1 {
            return .top
        }
        // 左
        else if inLevel.y == meLevel.y && inLevel.x == meLevel.x - 1 {
            // 横轴最小点为 0，不能小于它
            if meLevel.x == 0 {
                return .none
            }
            return .left
        }
        // 右
        else if inLevel.y == meLevel.y && inLevel.x == meLevel.x + 1 {
            return .right
        }
        // 下
        else if inLevel.x == meLevel.x && inLevel.y == meLevel.y + 1 {
            // 纵轴最小点为 0，不能小于此点
            if meLevel.y == 0 {
                return .none
            }
            return .bottom
        }
        
        // 左上
        else if inLevel.y == meLevel.y - 1 && inLevel.x == meLevel.x - 1 {
            return .topLeft
        }
        // 左下
        else if inLevel.y == meLevel.y + 1 && inLevel.x == meLevel.x - 1 {
            return .bottomLeft
        }
        // 右下
        else if inLevel.y == meLevel.y + 1 && inLevel.x == meLevel.x + 1 {
            return .bottomRight
        }
        // 右上
        else if inLevel.y == meLevel.y - 1 && inLevel.x == meLevel.x + 1 {
            return .topRight
        }
        
        
        return .none
    }
    
    /// 限制点溢出
    /// - Parameter newPoint: 可能要移动到的新点
    /// - Returns: 限制后的只能到达的点
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
            result = bsdMax(bondPoints[.top]?.point.y, bondPoints[.topLeft]?.point.y, bondPoints[.topRight]?.point.y)
            
        case .left:
            result = bsdMax(bondPoints[.left]?.point.x, bondPoints[.topLeft]?.point.x, bondPoints[.bottomLeft]?.point.x)
            
        case .right:
            result = bsdMin(bondPoints[.right]?.point.x, bondPoints[.topRight]?.point.x, bondPoints[.bottomRight]?.point.x)
            
        case .bottom:
            result = bsdMin(bondPoints[.bottom]?.point.y, bondPoints[.bottomLeft]?.point.y, bondPoints[.bottomRight]?.point.y)
        }
        
        return result
    }
    
    private func bsdMin<T: Comparable>(_ f1: T?, _ f2: T?, _ f3: T?) -> T? {
        
        var result: T?
        if let f1 = f1, f2 == nil, f3 == nil {
            result = f1
        }
        
        else if let f2 = f2, f1 == nil, f3 == nil {
            result = f2
        }
        
        else if let f3 = f3, f1 == nil, f2 == nil {
            result = f3
        }
        
        else if let f1 = f1, let f2 = f2, f3 == nil {
            result = min(f1, f2)
        }
        
        else if let f1 = f1, let f3 = f3, f2 == nil {
            result = min(f1, f3)
        }
        
        else if let f2 = f2, let f3 = f3, f1 == nil {
            result = min(f2, f3)
        }
        
        else if let f1 = f1, let f2 = f2, let f3 = f3 {
            result = min(f1, f2, f3)
        }
        
        return result
    }
    
    private func bsdMax<T: Comparable>(_ f1: T?, _ f2: T?, _ f3: T?) -> T? {
        
        var result: T?
        if let f1 = f1, f2 == nil, f3 == nil {
            result = f1
        }
        
        else if let f2 = f2, f1 == nil, f3 == nil {
            result = f2
        }
        
        else if let f3 = f3, f1 == nil, f2 == nil {
            result = f3
        }
        
        else if let f1 = f1, let f2 = f2, f3 == nil {
            result = max(f1, f2)
        }
        
        else if let f1 = f1, let f3 = f3, f2 == nil {
            result = max(f1, f3)
        }
        
        else if let f2 = f2, let f3 = f3, f1 == nil {
            result = max(f2, f3)
        }
        
        else if let f1 = f1, let f2 = f2, let f3 = f3 {
            result = max(f1, f2, f3)
        }
        
        return result
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
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
