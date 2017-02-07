//
//  UIColorExtension.swift
//  Infographic
//
//  Created by Taguhi Abgaryan on 2/7/17.
//  Copyright © 2017 Taguhi Abgaryan. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
}

// warning: remove these constants later!
let newLine = "\n"
let space = " "
let swiftComment = "// "

// warning: remove/comment this function later!
// -- this function converts AllColors.txt file into a swift code --
func convertColorDataIntoSwiftCode(data: String) -> String {
    var code = ""
    let dataArray = data.components(separatedBy: newLine) // read data line by line
    for line in dataArray {
        var words = line.components(separatedBy: space) // separate line componnents by space character
        // if there is only 1 word in line, then probably it is name of colors collection, so make it a comment
        if words.count == 1 {
            code += swiftComment + words[0] + newLine
            continue
        }
        // remove all empty strings
        var index = 0
        while index < words.count {
            if (words[index] == "") {
                words.remove(at: index)
                if index - 1 >= 0 {
                    index -= 1
                }
                continue
            }
            index += 1
        }
        if words.count < 1 {
            continue
        }
        // insert "let " in front of line
        words.reverse()
        words.append("let")
        words.reverse()
        // replace "#smth" with "="
        for index in 0...words.count - 1 {
            if words[index].hasPrefix("#") {
                words[index] = "="
            }
        }
        code += "\n" + words.joined(separator: " ")
    }
    return code
}
