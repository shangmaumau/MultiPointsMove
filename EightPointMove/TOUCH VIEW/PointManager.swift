//
//  PointManager.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

class EPMPointManager: NSObject {
    
    public private(set) var pointsMap = [CGPoint : EPMPoint]()
    
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
        
        guard pointsMap[point.level] == nil else {
            return
        }
        
        pointsMap[point.level] = point
    }
    
    // MARK:- Set up points
    
    /// Set up all points.
    public func setUpAllPoints() {
        
        let values = [EPMPoint](pointsMap.values)
        for var val in values {
            val.addBondPoints(values)
            pointsMap[val.level] = val
        }
    }
    
    /// Remove point.
    /// - Parameter point: In point.
    public func removePoint(_ point: EPMPoint) {
        
        guard pointsMap[point.level] != nil else {
            return
        }
        
        pointsMap.removeValue(forKey: point.level)
        
        // TODO: Should add the handle after removement.
    }
    
    /// Update point.
    /// - Note: Call this after all the points were added.
    /// - Parameter point: In point.
    public func updatePoint(_ point: EPMPoint) {
        
        guard pointsMap[point.level] != nil else {
            return
        }
        
        pointsMap[point.level] = point
        
        let values = [EPMPoint](pointsMap.values)

        for var val in values {
            val.updateBondPoint(point)
            pointsMap[val.level] = val
        }
        
    }
    
    // MARK:- Limit point.
    
    public func limitPoint(_ newPoint: EPMPoint) -> EPMPoint? {
        
        if var nP = point(ofLevel: newPoint.level) {
            nP.limitPoint(newPoint.point)
            updatePoint(nP)
            return point(ofLevel: nP.level)
        }
        
        return nil
    }
    
    // MARK:- Methods
    
    /// Fetch an element by a `level`.
    /// - Parameter level: In level.
    /// - Returns: Out point.
    public func point(ofLevel level: CGPoint) -> EPMPoint? {
        pointsMap[level]
    }
    
    /// Fetch elements by levels.
    /// - Parameter lvls: In levels.
    /// - Returns: Out points.
    public func points(ofLevels lvls: [CGPoint]) -> [EPMPoint] {
        
        var points = [EPMPoint]()
        
        for l in lvls {
            
            if let point = point(ofLevel: l) {
                points.append(point)
            }
        }
        
        return points
    }
    
}
