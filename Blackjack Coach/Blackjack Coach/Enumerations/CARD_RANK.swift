//
//  CARD_RANK.swift
//  Blackjack Coach
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

enum CARD_RANK: Int {
    case ACE
    case TWO
    case THREE
    case FOUR
    case FIVE
    case SIX
    case SEVEN
    case EIGHT
    case NINE
    case TEN
    case JACK
    case QUEEN
    case KING

    func getValue() -> Int {
        switch self {
        case .ACE:
            return 1
        case .TWO:
            return 2
        case .THREE:
            return 3
        case .FOUR:
            return 4
        case .FIVE:
            return 5
        case .SIX:
            return 6
        case .SEVEN:
            return 7
        case .EIGHT:
            return 8
        case .NINE:
            return 9
        case .TEN:
            return 10
        case .JACK:
            return 10
        case .QUEEN:
            return 10
        case .KING:
            return 10
        }
    }

    func getImageName() -> String {
        switch self {
        case .ACE:
            return "A"
        case .TWO:
            return "2"
        case .THREE:
            return "3"
        case .FOUR:
            return "4"
        case .FIVE:
            return "5"
        case .SIX:
            return "6"
        case .SEVEN:
            return "7"
        case .EIGHT:
            return "8"
        case .NINE:
            return "9"
        case .TEN:
            return "10"
        case .JACK:
            return "Jack"
        case .QUEEN:
            return "Queen"
        case .KING:
            return "King"
        }
    }
}
