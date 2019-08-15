
//  DegreeScaleView.swift
//  CompassExample
//
//  Created by Liu Chuan on 2018/3/8.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

/// Scale view
class DegreeScaleView: UIView {
    
    /// Background view

    private lazy var backgroundView = UIView()
    
    /// Horizontal view
    private lazy var levelView: UIView = {
        let levelView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 2 / 2, height: 1))
        levelView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        levelView.backgroundColor = .white
        return levelView
    }()
    
    /// Vertical view
    private lazy var verticalView: UIView = {
        let verticalView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: self.frame.size.height / 2 / 2))
        verticalView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        verticalView.backgroundColor = .white
        return verticalView
    }()
    
    /// Pointer view
    private lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: self.frame.size.width / 2 - 1.5, y: self.frame.size.height/2 - (self.frame.size.width/2 - 50) - 50, width: 3, height: 60))
        lineView.backgroundColor = .white
        return lineView
    }()
    
    // MARK: - system method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 2
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        addSubview(backgroundView)
        addSubview(levelView)
        addSubview(verticalView)
        insertSubview(lineView, at: 0)
        configScaleDial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configuration scale
    private func configScaleDial() {

        /// 360
        let degree_360: CGFloat = CGFloat.pi
        
        /// 180
        let degree_180: CGFloat = degree_360 / 2
        
        /// angle
        let angle: CGFloat = degree_360 / 90
        
        /// Direction array
        let directionArray = ["N", "E", "S", "W"]
        
        /// point
        let po = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        // Draw a circle, draw an arc every 2°, a total of 180
        for i in 0 ..< 180 {
            
            /// Starting angle
            let startAngle: CGFloat = -(degree_180 + degree_360 / 180 / 2) + angle * CGFloat(i)
  
            /// End angle
            let endAngle: CGFloat = startAngle + angle / 2
            
            // Create a path object
            let bezPath = UIBezierPath(arcCenter: po, radius: frame.size.width / 2 - 50, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            /// Deformation layer
            let shapeLayer = CAShapeLayer()
            
            if i % 15 == 0 {
                // Set the stroke color
                shapeLayer.strokeColor = UIColor.white.cgColor
                shapeLayer.lineWidth = 20
            }else {
                shapeLayer.strokeColor = UIColor.gray.cgColor
                shapeLayer.lineWidth = 20
            }
            shapeLayer.path = bezPath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor    // Set the fill path color
            backgroundView.layer.addSublayer(shapeLayer)
            
            // Marking of scale
            if i % 15 == 0 {
                // Marking of scale 0 30 60...
                var tickText = "\(i * 2)"
                
                let textAngle: CGFloat = startAngle + (endAngle - startAngle) / 2
                
                let point: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 1.2)
                
                // UILabel
                let label = UILabel(frame: CGRect(x: point.x, y: point.y, width: 30, height: 20))
                label.center = point
                label.text = tickText
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 15)
                label.textAlignment = .center
                backgroundView.addSubview(label)
                
                if i % 45 == 0 {    // North east south west
                    
                    tickText = directionArray[i / 45]
                    
                    let point2: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 0.8)
                    // UILabel
                    let label2 = UILabel(frame: CGRect(x: point2.x, y: point2.y, width: 30, height: 20))
                    label2.center = point2
                    label2.text = tickText
                    label2.textColor = .white
                    label2.font = UIFont.systemFont(ofSize: 20)
                    label2.textAlignment = .center
                    
                    if tickText == "北" {
                        /// Red Arrow
                        let redArrowLabel = UILabel(frame: CGRect(x: point.x, y: point.y, width: 8, height: 8))
                        redArrowLabel.center = CGPoint(x: point.x, y: point.y + 10)
                        redArrowLabel.clipsToBounds = true
                        redArrowLabel.layer.cornerRadius = redArrowLabel.frame.size.height / 2
                        redArrowLabel.backgroundColor = .red
                        redArrowLabel.textAlignment = .center
                        backgroundView.addSubview(redArrowLabel)
                    }
                    backgroundView.addSubview(label2)
                }
            }
        }
    }
    
    
    
    /// Calculation center coordinates
    ///
    /// - Parameters:
    ///   - center: Center point
    ///   - angle: angle
    ///   - scale: Scale
    /// - Returns: CGPoint
    private func calculateTextPositon(withArcCenter center: CGPoint, andAngle angle: CGFloat, andScale scale: CGFloat) -> CGPoint {
        let x = (self.frame.size.width / 2 - 50) * scale * CGFloat(cosf(Float(angle)))
        let y = (self.frame.size.width / 2 - 50) * scale * CGFloat(sinf(Float(angle)))
        return CGPoint(x: center.x + x, y: center.y + y)
    }
    
    /// Rotate the direction of the reset scale mark
    ///
    /// - Parameter heading: course
    public func resetDirection(_ heading: CGFloat) {
        
        backgroundView.transform = CGAffineTransform(rotationAngle: heading)
        
        for label in backgroundView.subviews {
            label.transform = CGAffineTransform(rotationAngle: -heading)
        }
    }


}
