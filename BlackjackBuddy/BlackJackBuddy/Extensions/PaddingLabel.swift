//
//  PaddingLabel.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation
import UIKit
class PaddingLabel: UILabel {
    let padding = UIEdgeInsets(top: CGFloat(Configuration.LABEL_PADDING_Y), left: CGFloat(Configuration.LABEL_PADDING_X), bottom: CGFloat(Configuration.LABEL_PADDING_Y), right: CGFloat(Configuration.LABEL_PADDING_X))
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }

    // Override -intrinsicContentSize: for Auto layout code
    func intrinsicContentSize() -> CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

    // Override -sizeThatFits: for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
