//
//  ViewController.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/15/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // DEALER VIEWS
    @IBOutlet var dealerHandContainer: UIView!
    @IBOutlet var dealerCard1: UIImageView!
    @IBOutlet var dealerCard2: UIImageView!
    @IBOutlet var dealerNameLabel: UILabel!

    // PLAYER VIEWS
    @IBOutlet var playerHandContainer: UIView!
    @IBOutlet var playerCard1: UIImageView!
    @IBOutlet var playerCard2: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!

    // STATS VIEWS
    @IBOutlet var statsContainer: UIView!
    @IBOutlet var deckCountLabel: UILabel!
    @IBOutlet var playerScoreLabel: UILabel!
    @IBOutlet var dealerScoreLabel: UILabel!

    // RESTART GAME VIEWS
    @IBOutlet var restartGameButton: UIButton!
    @IBAction func restartGameButtonOnClick(_: Any) {
        initGame()
    }

    // GAME RESULT VIEWS
    @IBOutlet var gameResultContainer: UIView!
    @IBOutlet var gameResultLabel: UILabel!
    @IBOutlet var gameResultRestartButton: UIButton!
    @IBAction func gameResultRestartButtonOnClick(_: Any) {
        initGame()
    }

    // PLAYER CONTROLS VIEWS
    @IBOutlet var playerControlsContainer: UIView!
    @IBOutlet var playerHitStandContainer: UIView!
    @IBOutlet var playerStandButton: UIButton!
    @IBOutlet var playerSplitButton: UIButton!
    @IBOutlet var playerDoubleDownButton: UIButton!
    @IBOutlet var playerInsuranceButton: UIButton!
    @IBOutlet var playerSurrenderButton: UIButton!
    @IBOutlet var playerHitButton: UIButton!
    @IBAction func playerHitButtonOnClick(_: Any) {
        // disable hit and stand buttons
        playerHitButton.isEnabled = false
        playerStandButton.isEnabled = false

        // reload deck and shuffle it
        if _deck?._cards.count == 0 {
            _deck?.reloadDeck()
        }

        let dealtCard = (_deck?.dealCard(player: _player!))!
        updateCardImage(card: dealtCard, image: playerCard2, imageViewName: "playerCard2")
        updateStats()

        checkIfGameIsOver()
    }

    var _player: Player?
    var _dealer: Dealer?
    var _deck: Deck?

    func updateStats() {
        playerScoreLabel.text = "\(_player?.score() ?? 0)"
        dealerScoreLabel.text = "\(_dealer?.score() ?? 0)"
        deckCountLabel.text = "\(_deck?._cards.count ?? 52) cards"
    }

    func updateCardImage(card: Card, image: UIImageView, imageViewName _: String) {
        let cardImageName = getCardImageName(card: card)
        image.image = UIImage(named: cardImageName)
    }

    func clearCardImages() {
        // clear card images
        playerCard1.image = nil
        playerCard2.image = nil
        dealerCard1.image = nil
        dealerCard2.image = nil
    }

    func initGame() {
        // hide gameResultContainer
        gameResultContainer.isHidden = true
        gameResultContainer.isUserInteractionEnabled = false

        // unhide the deal again button from this view
        restartGameButton.isHidden = false

        // init players
        _player = Player(name: "DR VAN NOSTRAND", chips: 0, cards: [])
        _dealer = Dealer(name: "DEALER", chips: 0, cards: [])

        // init player name label
        playerNameLabel.text = _player?._name.uppercased()
        playerNameLabel.sizeToFit()
        playerNameLabel.center.x = statsContainer.center.x

        // init dealer name label
        dealerNameLabel.text = _dealer?._name.uppercased()
        dealerNameLabel.sizeToFit()
        dealerNameLabel.center.x = statsContainer.center.x

        // init deck
        if _deck == nil {
            _deck = Deck()
        }
        _deck?.shuffleDeck()

        // deal to player
        var dealtCard = ((_deck?.dealCard(player: _player!)))!
        updateCardImage(card: dealtCard, image: playerCard1, imageViewName: "playerCard1")
        updateStats()

        // deal to Dealer
        dealtCard = (_deck?.dealCard(player: _dealer!))!
        updateCardImage(card: dealtCard, image: dealerCard1, imageViewName: "dealerCard1")
        updateStats()

        // deal to player again
        dealtCard = (_deck?.dealCard(player: _player!))!
        updateCardImage(card: dealtCard, image: playerCard2, imageViewName: "playerCard2")
        updateStats()

        // check to see if user got blackjack or busted
        checkIfGameIsOver()
    }

    // determines if user busted or got blackjack and updates the UI accordingly
    func checkIfGameIsOver() {
        // check if user busted
        if (_player?.score())! > 21 {
            // hide restart game button from other view
            restartGameButton.isHidden = true

            // set game over status text
            gameResultLabel.text = "Dang, broheim, you busted."
            gameResultLabel.textColor = UIColor.red

            // show the game result overlay
            gameResultContainer.backgroundColor = UIColor.darkText.withAlphaComponent(0.85)
            gameResultContainer.isUserInteractionEnabled = true
            gameResultContainer.isHidden = false

        }
        // check if user got blackjack
        else if _player?.score() == 21 {
            // hide restart game button from other view
            restartGameButton.isHidden = true

            // set game win status text
            gameResultLabel.text = "Blackjack!  You Win!"
            gameResultLabel.textColor = UIColor.green

            // show the game result overlay
            gameResultContainer.backgroundColor = UIColor.darkText.withAlphaComponent(0.85)
            gameResultContainer.isUserInteractionEnabled = true
            gameResultContainer.isHidden = false
        }
        // otherwise, user can continue playing
        else {
            // enable hit and stand buttons
            playerHitButton.isEnabled = true
            playerStandButton.isEnabled = true
        }
    }

    func getCardImageName(card: Card) -> String {
        let dealtRank = card._rank.getImageName()
        let dealtSuit = card._suit.getImageName()
        let cardImageName = "\(dealtRank)_\(dealtSuit)"
        return cardImageName
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
