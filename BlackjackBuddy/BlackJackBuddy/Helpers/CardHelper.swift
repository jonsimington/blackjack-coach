//
//  CardHelper.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/19/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation
import UIKit

class CardHelper {
    // sets the image for a UIImageView
    static func updateCardImage(card: Card, image: UIImageView, imageViewName _: String) {
        let cardImageName = card._isFaceUp ? CardHelper.getCardImageName(card: card) : "faceDownCard"
        image.image = UIImage(named: cardImageName)
    }

    static func getCardImageName(card: Card) -> String {
        let dealtRank = card._rank.getImageName()
        let dealtSuit = card._suit.getImageName()
        let cardImageName = "\(dealtRank)_\(dealtSuit)"
        return cardImageName
    }

    static func orientCardInHand(card: UIImageView, elementToPadFrom: UIImageView, firstCard: Bool = false) {
        if firstCard {
            card.frame.origin.x = elementToPadFrom.frame.origin.x + CGFloat(Configuration.CARD_PADDING_X)
        } else {
            card.frame.origin.x = elementToPadFrom.frame.origin.x + elementToPadFrom.frame.width + CGFloat(Configuration.CARD_PADDING_X)
        }
    }
}
