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
    
    private var expandCoefficient = nodeTapDefaultCoefficient
    private var node: Node
    private var nodeRenderingMode = NodeRenderingMode.collapsed
    private let image = nodeDefaultImage!.withRenderingMode(.alwaysTemplate)
    
    private var progressLines: [CAShapeLayer] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
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
        self.titleLabel.text = self.node.title
        self.explanationLabel.text = self.node.explanation
    }
    
    public func tapAction(visualisationStyle: VisualisationStyle) {
        tapAction(visualisationStyle: visualisationStyle, coefficient: self.expandCoefficient)
    }
    
    public func tapAction(visualisationStyle: VisualisationStyle, coefficient: CGFloat) {
        self.expandCoefficient = coefficient
        // don't expand if node is already expanded
        if self.nodeRenderingMode == .collapsed {
            switch visualisationStyle {
            case .asynchronous:
                asyncExpand(coefficient: coefficient)
            case .synchronous:
                syncExpand(coefficient: coefficient)
            }
        } else {
            collapse()
        }
    }
    
    private func syncExpand(coefficient: CGFloat) {
        print("NOT IMPLEMENTED: syncExpand")
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
        switch mode {
        case .collapsed:
            coefficient = 1 / coefficient
        case .expanded:
            break
        }
        frame.size = CGSize(width: startFrame.width * coefficient, height: startFrame.height * coefficient)
        frame.origin = CGPoint(x: startFrame.origin.x + (startFrame.width - frame.width) / 2.0, y: startFrame.origin.y + (startFrame.height - frame.height) / 2.0)
        return frame
    }
    
    private func asyncExpand(coefficient: CGFloat) {
        self.nodeRenderingMode = .expanded
        // calculate destination frame of node
        let sideCoefficient: CGFloat = (self.nodeRenderingMode == .expanded) ? coefficient : 1 / coefficient
        let newSide = self.imageView.frame.width * sideCoefficient
        let newOriginDifference = (newSide - self.imageView.frame.width) / 2
        let frame = CGRect(x: self.imageView.frame.origin.x - newOriginDifference, y: self.imageView.frame.origin.y - newOriginDifference, width: newSide, height: newSide)
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
            if self.nodeRenderingMode == .expanded {
                self.asyncAnimateDetailedInformation(nodeData: self.node.data)
            }
        }, completion: { finished in })
    }
    
    private func asyncAnimateDetailedInformation(nodeData: [NodeData]) {
        // set up some values to use in the curve
        let margin = progressLineMarginCoefficient * self.imageView.frame.width
        let tempFrame = self.imageView.frame
        let ovalRect = CGRect(x: tempFrame.origin.x - margin, y: tempFrame.origin.y - margin, width: tempFrame.width + 2 * margin, height: tempFrame.height + 2 * margin)
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
            currentProgressLine.strokeColor = nodeMember.color.cgColor
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

