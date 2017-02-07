//
//  ViewController.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/6/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

// -- constants --

// global
let allInDegrees = 360.0
let allInPercents = 100.0

// node
let makeNodeBiggerDuration = 0.3
let makeNodeBiggerDelay = 0.0
let makeNodeBiggerSpringDamping: CGFloat = 0 // 0.5 in previous version
let makeNodeBiggerVelocity: CGFloat = 0.0
let nodeImageName = "blue_circle"

// progress line
let progressLineWidth: CGFloat = 3.0
let progressLineMarginCoefficient: CGFloat = 0.05

// colors
let mainColor = thistle

class ViewController: UIViewController {
    
    private var isZoomed = false // this shows if a node was chosen
    private var progressLines: [CAShapeLayer] = []
    
    @IBOutlet weak var nodeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = lavender
        initialSetup()
    }
    
    private func initialSetup() {
        makeNodeClickable()
        nodeView.image = UIImage(named: nodeImageName)?.withRenderingMode(.alwaysTemplate)
        nodeView.tintColor = mainColor
        // additional setup is missing
    }
    
    private func makeNodeClickable() {
        // add tap recognizer to node
        nodeView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(nodeViewTapAction))
        nodeView.addGestureRecognizer(gesture)
    }
    
    @objc private func nodeViewTapAction() {
        isZoomed = !isZoomed
        // calculate destination frame of chosen node
        let sideCoefficient: CGFloat = (isZoomed) ? 2.5 : 1 / 2.5
        let newSide = nodeView.frame.width * sideCoefficient
        let newOriginDifference = (newSide - nodeView.frame.width) / 2
        let frame = CGRect(x: self.nodeView.frame.origin.x - newOriginDifference, y: self.nodeView.frame.origin.y - newOriginDifference, width: newSide, height: newSide)
        // warning: this as a test information
        let nodeInformation = [
            NodeMember(percentage: 17, color: plum, explanation: "food"),
            NodeMember(percentage: 45, color: darkViolet, explanation: "drinks"),
            NodeMember(percentage: 11, color: orchid, explanation: "online payments"),
            NodeMember(percentage: 3, color: darkOrchid, explanation: "taxes"),
            NodeMember(percentage: 5, color: magenta, explanation: "insurance"),
            NodeMember(percentage: 19, color: indigo, explanation: "insurance"),
            ]
        
        if !isZoomed {
            // remove all progress lines
            for line in progressLines {
                line.removeFromSuperlayer()
            }
            self.progressLines = []
        }
        // animate
        UIView.animate(withDuration: makeNodeBiggerDuration, delay: makeNodeBiggerDelay, usingSpringWithDamping: makeNodeBiggerSpringDamping, initialSpringVelocity: makeNodeBiggerVelocity, options: .curveEaseOut, animations: {
            self.nodeView.frame = frame
            if self.isZoomed {
                self.animateDetailedInformation(nodeMembers: nodeInformation)
            }
        }, completion: { finished in })
    }
    
    private func radiansByDegrees(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
    
    private func animateDetailedInformation(nodeMembers: [NodeMember]) {
        // set up some values to use in the curve
        let margin = progressLineMarginCoefficient * nodeView.frame.width
        let tempFrame = self.nodeView.frame
        let ovalRect = CGRect(x: tempFrame.origin.x - margin, y: tempFrame.origin.y - margin, width: tempFrame.width + 2 * margin, height: tempFrame.height + 2 * margin)
        var currentDegree = 270.0 // current degree's initial value is the start angle
        // draw all progress lines
        for nodeMember in nodeMembers {
            // create the bezier path
            let ovalPath = UIBezierPath()
            let degreeOfCurrentNode = nodeMember.percentage * allInDegrees / allInPercents
            ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY),
                            radius: ovalRect.width / 2,
                            startAngle: CGFloat(radiansByDegrees(degrees: currentDegree)),
                            endAngle: CGFloat(radiansByDegrees(degrees: degreeOfCurrentNode + currentDegree)), clockwise: true)
            currentDegree += degreeOfCurrentNode
            // current progress line
            var currentProgressLine = CAShapeLayer()
            currentProgressLine = CAShapeLayer()
            currentProgressLine.path = ovalPath.cgPath
            currentProgressLine.strokeColor = nodeMember.color.cgColor
            currentProgressLine.fillColor = UIColor.clear.cgColor
            currentProgressLine.lineWidth = progressLineWidth
            currentProgressLine.lineCap = kCALineCapRound
            // add the progress line to the screen
            self.view.layer.addSublayer(currentProgressLine)
            // create a basic animation
            let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            animateStrokeEnd.duration = 0.6
            animateStrokeEnd.fromValue = 0.0
            animateStrokeEnd.toValue = 1.0
            // add current progress line to array
            progressLines.append(currentProgressLine)
            // add the animation
            currentProgressLine.add(animateStrokeEnd, forKey: "animate stroke end animation")
        }
    }
}

// --- TRY THIS LATER ---

//// Begin the transaction
//CATransaction.begin()
//let animation = CABasicAnimation(keyPath: "strokeEnd")
//animation.duration = duration //duration is the number of seconds
//animation.fromValue = 0
//animation.toValue = 1
//animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//circleLayer.strokeEnd = 1.0
//
//// Callback function
//CATransaction.setCompletionBlock {
//    print("end animation")
//}
//
//// Do the actual animation and commit the transaction
//circleLayer.add(animation, forKey: "animateCircle")
//CATransaction.commit()
