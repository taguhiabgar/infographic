//
//  ViewController.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/6/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

// warning: this is a test information
let nodeInformation = [
    NodeData(percentage: 17, color: plum, explanation: "food"),
    NodeData(percentage: 45, color: darkViolet, explanation: "drinks"),
    NodeData(percentage: 11, color: orchid, explanation: "online payments"),
    NodeData(percentage: 3, color: darkOrchid, explanation: "taxes"),
    NodeData(percentage: 5, color: magenta, explanation: "insurance"),
    NodeData(percentage: 19, color: indigo, explanation: "other"),
]

// warning: this is a test information
let testFrame = CGRect(x: 100, y: 100, width: 200, height: 200)

// warning: this is a test information
let testNode = Node(summary: "Living Room", title: "928", explanation: "Avg.Wh/hour", data: nodeInformation)

class ViewController: UIViewController {
    
    private var nodeView = NodeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBColor(red: 25, green: 25, blue: 25).uiColor()
        setupNodes()
    }
    
    private func setupNodes() {
        nodeView = NodeView(frame: testFrame, node: testNode)
        nodeView.titleLabel.textColor = indigo
        nodeView.explanationLabel.textColor = indigo
        nodeView.summaryLabel.textColor = indigo
        nodeView.imageView.tintColor = lavender
        makeNodeClickable()
        self.view.addSubview(nodeView)
    }
    
    private func makeNodeClickable() {
        // add tap recognizer to node
        nodeView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(nodeViewTapAction))
        nodeView.addGestureRecognizer(gesture)
    }
    
    @objc private func nodeViewTapAction() {
        nodeView.tapAction(visualisationStyle: .asynchronous)
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
