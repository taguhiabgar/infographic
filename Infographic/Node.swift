//
//  Node.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/7/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

// Node model
class Node {
    
    // MARK: - Properties
    
    public var summary: String
    public var title: String
    public var explanation: String
    public var data: [NodeData] // node information
    
    // MARK: - Initializers
    
    init() {
        data = []
        title = nodeDefaultTitle
        explanation = nodeDefaultExplanation
        summary = nodeDefaultSummary
    }
    
    init(summary: String, title: String, explanation: String, data: [NodeData]) {
        self.data = data
        self.summary = summary
        self.title = title
        self.explanation = explanation
    }
    
    // MARK: - Methods ?
    
}

