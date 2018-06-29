//
//  UIFontSize.swift
//  BlackjackBuddy
//
//  Created by CN117164 on 6/21/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    func textWidth(text: String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: self]
        return text.size(withAttributes: attributes).width
    }
}
