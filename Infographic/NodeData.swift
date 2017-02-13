//
//  NodeData.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/9/17.
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


