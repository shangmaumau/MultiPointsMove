//
//  PointManager.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

class EPMPointManager: NSObject {
    
    public static let `default`: EPMPointManager = {
        return EPMPointManager()
    }()
    
    public private(set) var points = [EPMPoint]()
    
    // MARK:- Add point
    
    /// Add points.
    /// - Parameter points: In points.
    public func addPoints(_ points: [EPMPoint]) {
        for p_ in points {
            addPoint(p_)
        }
    }
    
    /// Add point.
    ///
    /// If `points` contains this point, won't add in.
    /// - Parameter point: In point.
    public func addPoint(_ point: EPMPoint) {
        
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
    public func removePoint(_ point: EPMPoint) {
        
        guard points.firstIndex(of: point) != nil else {
            return
        }
        
        points.remove(at: points.firstIndex(of: point)!)
        
        // TODO: Should add the handle after removement.
    }
    
    /// Update point.
    /// - Note: Call this after all the points were added.
    /// - Parameter point: In point.
    private func updatePoint(_ point: EPMPoint) {
        
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
    
    public func limitPoint(_ newPoint: EPMPoint, _ direction: GestureDirection) -> EPMPoint? {
        
        if var nP = pointFromLevel(newPoint.level) {
            nP.limitPoint(newPoint.point, direction)
            updatePoint(nP)
            return pointFromLevel(nP.level)
        }
        
        return nil
    }
    
    // MARK:- Methods
    
    /// Fetch the element by its `level`.
    /// - Parameter level: Element's level.
    /// - Returns: The point.
    public func pointFromLevel(_ level: CGPoint) -> EPMPoint? {
        
        for point in points {
            if point.level == level {
                return point
            }
        }
        return nil
    }
    
}
