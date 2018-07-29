//
//  Dealer.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/16/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class Dealer: Player {
    public var upCard: Card {
        return _cards[0]
    }
}
