//
//  ViewController.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/6/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

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
        nodeView.tapAction(visualisationStyle: .synchronous)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditNodesViewController") as? EditNodesViewController {            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
}
