//
//  ViewController.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/6/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

// some constants
let makeNodeBiggerDuration = 0.6
let makeNodeBiggerDelay = 0.0
let makeNodeBiggerSpringDamping: CGFloat = 0.5
let makeNodeBiggerVelocity: CGFloat = 0.0

class ViewController: UIViewController {
    
    private var isZoomed = false
    
    @IBOutlet weak var nodeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        // add tap recognizer to node
        nodeView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(nodeViewTapAction))
        nodeView.addGestureRecognizer(gesture)
    }
    
    @objc private func nodeViewTapAction() {
        isZoomed = !isZoomed
        // calculate destination frame of node
        let sideCoefficient: CGFloat = (isZoomed) ? 2.5 : 1 / 2.5
        let newSide = nodeView.frame.width * sideCoefficient
        let newOriginDifference = (newSide - nodeView.frame.width) / 2
        let frame = CGRect(x: self.nodeView.frame.origin.x - newOriginDifference, y: self.nodeView.frame.origin.y - newOriginDifference, width: newSide, height: newSide)
        // animate
        animateViewToFrame(view: nodeView, frame: frame)
    }
    
    private func animateViewToFrame(view: UIView, frame: CGRect) {
        UIView.animate(withDuration: makeNodeBiggerDuration, delay: makeNodeBiggerDelay, usingSpringWithDamping: makeNodeBiggerSpringDamping, initialSpringVelocity: makeNodeBiggerVelocity, options: .curveEaseOut, animations: {
            view.frame = frame
        }, completion: nil)
    }
    
}

