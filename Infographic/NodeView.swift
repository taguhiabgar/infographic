//
//  NodeView.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/9/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

enum VisualisationStyle {
    case asynchronous
    case synchronous
    // warning: here can be more cases
}

enum NodeRenderingMode {
    case expanded
    case collapsed
}

class NodeView: UIView {
    
    // MARK: - Properties
    
    // private properties
    private var expandCoefficient = nodeTapDefaultCoefficient
    private var node: Node
    private let image = nodeDefaultImage!.withRenderingMode(.alwaysTemplate)
    private var progressLines: [CAShapeLayer] = []
    
    // public properties
    public var nodeRenderingMode = NodeRenderingMode.collapsed
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    // MARK: - Initializers
    
    init() {
        self.node = Node()
        super.init(frame: cgRectZero)
    }
    
    init(frame: CGRect, node: Node) {
        self.node = node
        super.init(frame: frame)
        loadNib()
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.node = Node()
        super.init(coder: aDecoder)
        loadNib()
    }
    
    // MARK: - Methods
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nodeViewNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    private func updateView() {
        // make node view transparent
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.imageView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        // set image
        self.imageView.image = self.image
        // update labels
        updateLabels(animated: false)
    }
    
    public func tapAction(visualisationStyle: VisualisationStyle) {
        tapAction(visualisationStyle: visualisationStyle, coefficient: self.expandCoefficient)
    }
    
    public func tapAction(visualisationStyle: VisualisationStyle, coefficient: CGFloat) {
        self.expandCoefficient = coefficient
        switch self.nodeRenderingMode {
        case .collapsed:
            expand(visualisation: visualisationStyle)
        case .expanded:
            collapse()
        }
        updateLabels(animated: true)
    }
    
    private func updateLabels(animated: Bool) {
        self.titleLabel.text = self.node.title
        self.explanationLabel.text = self.node.explanation
        self.summaryLabel.text = self.node.summary
        
        if animated {
            print("implementation missing: updateLabels")
        } else {
            print("implementation missing: updateLabels")
        }
        
        switch self.nodeRenderingMode {
        case .expanded:
            self.titleLabel.isHidden = false
            self.explanationLabel.isHidden = false
            self.summaryLabel.isHidden = true
        case .collapsed:
            self.titleLabel.isHidden = true
            self.explanationLabel.isHidden = true
            self.summaryLabel.isHidden = false
        }
    }
    
    private func collapse() {
        self.nodeRenderingMode = .collapsed
        // remove progress lines
        for line in progressLines {
            line.removeFromSuperlayer()
        }
        progressLines = []
        // animate
        let frame = calculateFrame(mode: .collapsed)
        UIView.animate(withDuration: makeNodeBiggerDuration, delay: makeNodeBiggerDelay, usingSpringWithDamping: makeNodeBiggerSpringDamping, initialSpringVelocity: makeNodeBiggerVelocity, options: .curveEaseOut, animations: {
            self.imageView.frame = frame
        }, completion: nil)
    }
    
    private func calculateFrame(mode: NodeRenderingMode) -> CGRect {
        var frame = cgRectZero
        let startFrame = self.imageView.frame
        var coefficient = self.expandCoefficient
        if mode == .collapsed {
            coefficient = 1 / coefficient
        }
        frame.size = CGSize(width: startFrame.width * coefficient, height: startFrame.height * coefficient)
        frame.origin = CGPoint(x: startFrame.origin.x + (startFrame.width - frame.width) / 2.0, y: startFrame.origin.y + (startFrame.height - frame.height) / 2.0)
        return frame
    }
    
    private func expand(visualisation: VisualisationStyle) {
        self.nodeRenderingMode = .expanded
        let frame = calculateFrame(mode: .expanded)
        if self.nodeRenderingMode == .collapsed {
            // remove all progress lines
            for line in progressLines {
                line.removeFromSuperlayer()
            }
            self.progressLines = []
        }
        // animate
        UIView.animate(withDuration: makeNodeBiggerDuration, delay: makeNodeBiggerDelay, usingSpringWithDamping: makeNodeBiggerSpringDamping, initialSpringVelocity: makeNodeBiggerVelocity, options: .curveEaseOut, animations: {
            self.imageView.frame = frame
        }, completion: nil)
        // animate progress lines
        switch visualisation {
        case .asynchronous:
            self.asyncAnimateProgressLines(nodeData: self.node.data)
        case .synchronous:
            self.syncAnimateProgressLines(nodeData: self.node.data)
        }
    }
    
    private func syncAnimateProgressLines(nodeData: [NodeComponent]) {
        
        
        // set up some values to use in the curve
        let margin = progressLineMarginCoefficient * self.imageView.frame.width
        let tempFrame = self.imageView.frame
        let ovalRect = CGRect(
            x: tempFrame.origin.x - margin,
            y: tempFrame.origin.y - margin,
            width: tempFrame.width + 2 * margin,
            height: tempFrame.height + 2 * margin)
        var currentDegree = 270.0 // current degree's initial value is the start angle
        
        CATransaction.begin()
        
        // create a basic animation
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 0.6
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        // draw all progress lines
        for nodeMember in nodeData {
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
            currentProgressLine.strokeColor = white.cgColor // warning: change!
            currentProgressLine.fillColor = UIColor.clear.cgColor
            currentProgressLine.lineWidth = progressLineWidth
            currentProgressLine.lineCap = kCALineCapRound
            // add the progress line to the screen
            self.layer.addSublayer(currentProgressLine)
            // add current progress line to array
            progressLines.append(currentProgressLine)
            // add the animation
            currentProgressLine.add(animateStrokeEnd, forKey: "animate stroke end animation")
        }
        // --- TRY THIS ---
        
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
    }
    
    private func asyncAnimateProgressLines(nodeData: [NodeComponent]) {
        // set up some values to use in the curve
        let margin = progressLineMarginCoefficient * self.imageView.frame.width
        let tempFrame = self.imageView.frame
        let ovalRect = CGRect(
            x: tempFrame.origin.x - margin,
            y: tempFrame.origin.y - margin,
            width: tempFrame.width + 2 * margin,
            height: tempFrame.height + 2 * margin)
        var currentDegree = 270.0 // current degree's initial value is the start angle
        // draw all progress lines
        for nodeMember in nodeData {
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
            currentProgressLine.strokeColor = white.cgColor // warning: change!
            currentProgressLine.fillColor = UIColor.clear.cgColor
            currentProgressLine.lineWidth = progressLineWidth
            currentProgressLine.lineCap = kCALineCapRound
            // add the progress line to the screen
            self.layer.addSublayer(currentProgressLine)
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
    
    // warning: this should be in other class
    private func radiansByDegrees(degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }    
    
}

