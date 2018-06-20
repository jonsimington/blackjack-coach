//
//  PaddingHelper.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/19/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation
import UIKit

class PaddingHelper {
    static func leftPadButton(button: UIButton, elementToPadFrom: UIView) {
        button.frame.origin.x = elementToPadFrom.frame.origin.x + CGFloat(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
    }

    static func rightPadButton(button: UIButton, elementToPadFrom: UIView) {
        button.frame.origin.x = elementToPadFrom.frame.width -
            button.frame.width -
            CGFloat(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
    }

    static func topPadButton(button: UIButton, elementToPadFrom: UIButton) {
        button.frame.origin.y = elementToPadFrom.frame.origin.y + elementToPadFrom.frame.height + CGFloat(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
    }
}
