//
//  CARD_SUIT.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

enum CARD_SUIT: String {
    case SPADES
    case HEARTS
    case CLUBS
    case DIAMONDS

    func getImageName() -> String {
        switch self {
        case .SPADES:
            return "spade"
        case .HEARTS:
            return "heart"
        case .CLUBS:
            return "club"
        case .DIAMONDS:
            return "diamond"
        }
    }
}
