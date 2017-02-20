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
    NodeComponent(percentage: 17, explanation: "food"),
    NodeComponent(percentage: 45, explanation: "drinks"),
    NodeComponent(percentage: 11, explanation: "online payments"),
    NodeComponent(percentage: 3, explanation: "taxes"),
    NodeComponent(percentage: 5, explanation: "insurance"),
    NodeComponent(percentage: 19, explanation: "other"),
]

// warning: this is a test information
let testFrame = CGRect(x: 100, y: 100, width: 200, height: 200)

// warning: this is a test information
let testNode = Node(summary: "Living Room", title: "928", explanation: "Avg.Wh/hour", data: nodeInformation)

class ViewController: UIViewController {
    
    private var nodes = [NodeView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBColor(red: 25, green: 25, blue: 25).uiColor()
        setupNodes()
    }
    
    private func setupNodes() {
        let nodeView = NodeView(frame: testFrame, node: testNode)
        nodeView.titleLabel.textColor = indigo
        nodeView.explanationLabel.textColor = indigo
        nodeView.summaryLabel.textColor = indigo
        nodeView.imageView.tintColor = lavender
        nodeView.tag = 0
        // add tap recognizer to node view
        nodeView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(nodeViewTapAction))
        nodeView.addGestureRecognizer(gesture)
        // add node view to nodes collection
        nodes.append(nodeView)
        view.addSubview(nodeView)
    }
    
    @objc private func nodeViewTapAction(sender: UITapGestureRecognizer) {
        if let nodeView = sender.view as? NodeView {
            if nodeView.tag >= 0 && nodeView.tag < nodes.count {
                nodes[nodeView.tag].tapAction(visualisationStyle: .synchronous)
            } else {
                print("Error: NodeView's tag is out of range")
            }
        } else {
            print("Error: Couldn't parse sender's view to NodeView")
        }
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let nextViewController = storyBoard.instantiateViewController(withIdentifier: editNodesVCIdentifier) as? EditNodesViewController {
            navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            print("Error: Couldn't instantiate EditNodesViewController from Main.storyboard")
        }
    }
    
}
