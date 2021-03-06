//
//  RGBColor.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/8/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

class RGBColor {
    
    // MARK: - Properties
    static public var maxValue: Int = 255
    private let solidColorAlpha = 1.0
    
    public var red: Int = 0
    public var green: Int = 0
    public var blue: Int = 0
    
    // MARK: - Initializers
    
    init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    // MARK: - Methods
    
    // returns UIColor value
    public func uiColor() -> UIColor {
        return UIColor(red: CGFloat(red) / CGFloat(RGBColor.maxValue),
                       green: CGFloat(green) / CGFloat(RGBColor.maxValue),
                       blue: CGFloat(blue) / CGFloat(RGBColor.maxValue),
                       alpha: CGFloat(solidColorAlpha))
    }
    
    // returns darker color
    // NOTE: - Coefficient should be in range [0, 1] - the smaller the coefficient, the darker is color
    public func darkerColor(coefficient: CGFloat) -> RGBColor {
        if coefficient <= 1 && coefficient >= 0 {
            let redValue = CGFloat(red) * coefficient
            let greenValue = CGFloat(green) * coefficient
            let blueValue = CGFloat(blue) * coefficient
            return RGBColor(red: Int(redValue), green: Int(greenValue), blue: Int(blueValue))
        } else {
            return self
        }
    }
    
}
