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
    
    var points = [BSDPoint]()
    
    /// 添加点
    /// - Parameter point: 要添加的点
    public func addPoint(_ point: BSDPoint) {
        
        guard points.firstIndex(of: point) == nil else {
            return
        }
        
        points.append(point)
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
    func updatePoint(_ point: BSDPoint) {
        for var point_ in points {
            point_.updateBondPoint(point: point)
        }
    }
    
    
}

struct BSDPoint: Equatable {
    
    /// 构造函数
    /// - Parameters:
    ///   - horizontalLevel: 水平方向的层级，从 0 开始
    ///   - verticalLevel: 垂直方向的层级，从 0 开始
    ///   - point: 一般来说，这里应该是像素点
    init(horizontalLevel: Int, verticalLevel: Int, point: CGPoint) {
        level = CGPoint(x: horizontalLevel, y: verticalLevel)
        self.point = point
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.level == rhs.level {
            return true
        }
        return false
    }
    
    /// 关联点方位
    enum BondPointPosition: String {
        /// 与此点无关系的点
        case none
        /// 在此点上方
        case up
        /// 在此点左方
        case left
        /// 在此点右方
        case right
        /// 在此点下方
        case down
    }

    public var level: CGPoint = CGPoint.zero
    public var point: CGPoint = CGPoint.zero
    public var bondPoints = [BondPointPosition : BSDPoint]()
    public var bondColors = [BondPointPosition : UIColor]()
    
    /// 添加关联点
    /// - Parameters:
    ///   - point: 点
    ///   - color: 与本点的连线的颜色
    mutating func addBondPoint(point: BSDPoint, color: UIColor) {
        
        guard pointToPosition(point) != .none else {
            return
        }
        let pos = pointToPosition(point)
        
        bondPoints[pos] = point
        bondColors[pos] = color
    }
    
    /// 更新关联点
    /// - Parameter point: 与本点关联的点
    mutating func updateBondPoint(point: BSDPoint) {
        
        guard pointToPosition(point) != .none else {
            return
        }
        
        bondPoints[ pointToPosition(point) ] = point
    }
    
    /// 由点的 level 推断出与本点的方位关系
    /// - Parameter point: 需要推断的点
    /// - Returns: 与本点的方位关系
    private func pointToPosition(_ point: BSDPoint) -> BondPointPosition {
        
        let inLevel = point.level
        let meLevel = self.level
        if inLevel.x == meLevel.x && inLevel.y == meLevel.y + 1 {
            return .up
        }
        
        if inLevel.y == meLevel.y && inLevel.x == meLevel.x - 1 {
            return .left
        }
        
        if inLevel.y == meLevel.y && inLevel.x == meLevel.x + 1 {
            return .right
        }
        
        if inLevel.x == meLevel.x && inLevel.y == meLevel.y - 1 {
            return .down
        }
        
        return .none
    }
    
    /// 限制点溢出
    /// - Parameter newPoint: 可能要移动到的新点
    /// - Returns: 限制后的只能到达的点
    @discardableResult
    public mutating func limitPoint(newPoint: CGPoint) -> CGPoint {
        guard newPoint != self.point else {
            return self.point
        }
        
        var outPoint = newPoint
        
        if let upPoint = bondPoints[.up] {
            if newPoint.y > upPoint.point.y {
                outPoint.y = upPoint.point.y
            }
        }
        
        if let leftPoint = bondPoints[.left] {
            if newPoint.x < leftPoint.point.x {
                outPoint.x = leftPoint.point.x
            }
        }
        
        if let rightPoint = bondPoints[.right] {
            if newPoint.x > rightPoint.point.x {
                outPoint.x = rightPoint.point.x
            }
        }
        
        if let downPoint = bondPoints[.down] {
            if newPoint.y < downPoint.point.y {
                outPoint.y = downPoint.point.y
            }
        }
        
        self.point = outPoint
        
        return outPoint
    }
    
    

}

class BSDTouchPoint: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
