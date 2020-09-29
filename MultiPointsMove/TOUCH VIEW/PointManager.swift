//
//  PointManager.swift
//  MultiPointsMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

class MPMPointManager: NSObject {
    
    public private(set) var pointsMap = [CGPoint : MPMPoint]()
    
    // MARK:- Add point
    
    /// Add points.
    /// - Parameter points: In points.
    public func add(points pts: [MPMPoint]) {
        for p_ in pts {
            add(point: p_)
        }
    }
    
    /// Add point.
    ///
    /// If `points` contains this point, won't add in.
    /// - Parameter point: In point.
    public func add(point pt: MPMPoint) {
        
        guard pointsMap[pt.level] == nil else {
            return
        }
        
        pointsMap[pt.level] = pt
    }
    
    // MARK:- Set up points
    
    /// Set up all points.
    public func setUpAllPoints() {
        
        let values = [MPMPoint](pointsMap.values)
        for var val in values {
            val.add(bondPoints: values)
            pointsMap[val.level] = val
        }
    }
    
    /// Remove point.
    /// - Parameter point: In point.
    public func remove(point aPoint: MPMPoint) {
        
        guard pointsMap[aPoint.level] != nil else {
            return
        }
        
        pointsMap.removeValue(forKey: aPoint.level)
        
        // TODO: Should add the handle after removement.
    }
    
    public func removeAll() {
        pointsMap.removeAll()
    }
    
    /// Update point.
    /// - Note: Call this after all the points were added.
    /// - Parameter point: In point.
    public func update(point aPoint: MPMPoint) {
        
        guard pointsMap[aPoint.level] != nil else {
            return
        }
        
        pointsMap[aPoint.level] = aPoint
        
        let values = [MPMPoint](pointsMap.values)

        for var val in values {
            val.update(bondPoint: aPoint)
            pointsMap[val.level] = val
        }
        
    }
    
    // MARK:- Limit point.
    
    public func limit(point aPoint: MPMPoint) -> MPMPoint? {
        
        if var nP = point(ofLevel: aPoint.level) {
            nP.limit(point: aPoint.point)
            update(point: nP)
            return point(ofLevel: nP.level)
        }
        
        return nil
    }
    
    // MARK:- Methods
    
    /// Fetch an element by a `level`.
    /// - Parameter level: In level.
    /// - Returns: Out point.
    public func point(ofLevel level: CGPoint) -> MPMPoint? {
        pointsMap[level]
    }
    
    /// Fetch elements by levels.
    /// - Parameter lvls: In levels.
    /// - Returns: Out points.
    public func points(ofLevels lvls: [CGPoint]) -> [MPMPoint] {
        
        var points = [MPMPoint]()
        
        for l in lvls {
            
            if let point = point(ofLevel: l) {
                points.append(point)
            }
        }
        
        return points
    }
    
}
