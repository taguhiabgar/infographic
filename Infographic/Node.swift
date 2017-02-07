//
//  Node.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/7/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

class NodeData {
    
    var percentage: Double
    var color: UIColor
    var explanation: String
    
    init(percentage: Double, color: UIColor, explanation: String) {
        self.percentage = percentage
        self.explanation = explanation
        self.color = color
    }
}

class Node {
    
    enum VisualisationStyle {
        case asynchronous
        case synchronous
        // warning: here can be more cases
    }
    
    // this property decides which style will animation have
    public var visualisationStyle: VisualisationStyle = .asynchronous // warning: remove this and initialize in initializer
    
    
    
}

