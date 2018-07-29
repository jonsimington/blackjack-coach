//
//  SuggestedPlayHelper.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 7/29/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation

class SuggestedPlayHelper {
    // SUGGESTED PLAY METHODS
    static func determineSuggestedPlay(_player: Player, _dealer: Dealer) -> USER_ACTION {
        let playerScore = _player.score()
        let dealerUpCard = _dealer._cards.filter { $0._isFaceUp == true }[0]

        let doubleDownIsAllowed = _player._cards.count == 2

        switch playerScore.type {
        case .HARD:
            switch dealerUpCard._rank {
            case .TWO:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .HIT
                case 13:
                    return .STAND
                case 14:
                    return .STAND
                case 15:
                    return .STAND
                case 16:
                    return .STAND
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .ACE:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return .HIT
                case 10:
                    return .HIT
                case 11:
                    return .HIT
                case 12:
                    return .HIT
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .SURRENDER
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .THREE:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .HIT
                case 13:
                    return .STAND
                case 14:
                    return .STAND
                case 15:
                    return .STAND
                case 16:
                    return .STAND
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .FOUR:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .STAND
                case 13:
                    return .STAND
                case 14:
                    return .STAND
                case 15:
                    return .STAND
                case 16:
                    return .STAND
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .FIVE:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .STAND
                case 13:
                    return .STAND
                case 14:
                    return .STAND
                case 15:
                    return .STAND
                case 16:
                    return .STAND
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .SIX:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .STAND
                case 13:
                    return .STAND
                case 14:
                    return .STAND
                case 15:
                    return .STAND
                case 16:
                    return .STAND
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .SEVEN:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .HIT
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .EIGHT:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .HIT
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .NINE:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return .HIT
                case 10:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .HIT
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .SURRENDER
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .TEN, .JACK, .QUEEN, .KING:
                switch playerScore.value {
                case 4, 5, 6, 7, 8:
                    return .HIT
                case 9:
                    return .HIT
                case 10:
                    return .HIT
                case 11:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 12:
                    return .HIT
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .SURRENDER
                case 16:
                    return .SURRENDER
                case 17, 18, 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            }
        case .SOFT:
            switch dealerUpCard._rank {
            case .TWO:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17:
                    return .HIT
                case 18:
                    return .STAND
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .ACE:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17:
                    return .HIT
                case 18:
                    return .HIT
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .THREE:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 18:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .STAND
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .FOUR:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 16:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 17:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 18:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .STAND
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .FIVE:
                switch playerScore.value {
                case 13:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 14:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 15:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 16:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 17:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 18:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .STAND
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .SIX:
                switch playerScore.value {
                case 13:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 14:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 15:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 16:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 17:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .HIT
                case 18:
                    return doubleDownIsAllowed ? .DOUBLE_DOWN : .STAND
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .SEVEN:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17:
                    return .HIT
                case 18:
                    return .STAND
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .EIGHT:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17:
                    return .HIT
                case 18:
                    return .STAND
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .NINE:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17:
                    return .HIT
                case 18:
                    return .HIT
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            case .TEN, .JACK, .QUEEN, .KING:
                switch playerScore.value {
                case 13:
                    return .HIT
                case 14:
                    return .HIT
                case 15:
                    return .HIT
                case 16:
                    return .HIT
                case 17:
                    return .HIT
                case 18:
                    return .HIT
                case 19, 20, 21:
                    return .STAND
                default:
                    return .STAND
                }
            }
        }
    }
}
