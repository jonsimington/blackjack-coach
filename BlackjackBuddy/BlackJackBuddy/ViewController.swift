//
//  ViewController.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/15/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    // LOCAL VARS
    var _player: Player?
    var _dealer: Dealer?
    var _deck: Deck?

    // DEALER VIEWS
    @IBOutlet var dealerHandContainer: UIView!
    @IBOutlet var dealerHandCardsContainer: UIImageView!
    @IBOutlet var dealerCard1: UIImageView!
    @IBOutlet var dealerCard2: UIImageView!
    @IBOutlet var dealerNameLabel: UILabel!

    // PLAYER VIEWS
    @IBOutlet var playerHandContainer: UIView!
    @IBOutlet var playerHandCardsContainer: UIImageView!
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

        // deal card to player and check for a terminal state
        let dealtCard = (_deck?.dealCard(player: _player!))!
        updateCardImage(card: dealtCard, image: playerCard2, imageViewName: "playerCard2")
        updateStats()

        checkIfGameIsOver()
    }

    // Updates label text for player scores, remaining cards in deck
    func updateStats() {
        playerScoreLabel.text = "\(_player?.score() ?? 0)"
        playerScoreLabel.sizeToFit()
        dealerScoreLabel.text = "\(_dealer?.score() ?? 0)"
        dealerScoreLabel.sizeToFit()
        deckCountLabel.text = "\(_deck?._cards.count ?? 52) cards"
    }

    // sets the image for a UIImageView
    func updateCardImage(card: Card, image: UIImageView, imageViewName _: String) {
        let cardImageName = getCardImageName(card: card)
        image.image = UIImage(named: cardImageName)
    }

    // sets the UIImageViews associated with the player's hand and the dealer's hand
    func clearCardImages() {
        playerCard1.image = nil
        playerCard2.image = nil
        dealerCard1.image = nil
        dealerCard2.image = nil
    }

    func initPlayerHandUI(player: Player) {
        // orient cards container
        playerHandCardsContainer.frame.origin.x = CGFloat(Configuration.CARD_CONTAINER_PADDING_X)
        playerHandCardsContainer.frame.size.width = playerHandContainer.frame.width - CGFloat(Configuration.CARD_CONTAINER_PADDING_X*2)

        // orient first card
        playerCard1.frame.origin.x = playerHandCardsContainer.frame.origin.x + CGFloat(Configuration.CARD_PADDING_X)

        // orient second card to the right of first card
        playerCard2.frame.origin.x = playerCard1.frame.origin.x + playerCard1.frame.width + CGFloat(Configuration.CARD_PADDING_X)

        // init player name label
        playerNameLabel.text = player._name.uppercased()
        playerNameLabel.sizeToFit()
        playerNameLabel.center.x = playerHandContainer.center.x
        playerNameLabel.frame.origin.y = playerHandCardsContainer.frame.origin.y - playerNameLabel.frame.height - CGFloat(Configuration.PLAYER_NAME_PADDING_Y)

        // init player score label
        playerScoreLabel.sizeToFit()
        playerScoreLabel.center.y = playerNameLabel.center.y
        playerScoreLabel.frame.origin.x = playerNameLabel.frame.origin.x + playerNameLabel.frame.width + CGFloat(Configuration.PLAYER_SCORE_PADDING_X)
    }

    func initDealerHandUI(dealer: Dealer) {
        // orient cards container
        dealerHandCardsContainer.frame.origin.x = CGFloat(Configuration.CARD_CONTAINER_PADDING_X)
        dealerHandCardsContainer.frame.size.width = dealerHandContainer.frame.width - CGFloat(Configuration.CARD_CONTAINER_PADDING_X*2)

        // orient first card
        dealerCard1.frame.origin.x = dealerHandCardsContainer.frame.origin.x + CGFloat(Configuration.CARD_PADDING_X)

        // init dealer name label
        dealerNameLabel.text = dealer._name.uppercased()
        dealerNameLabel.sizeToFit()
        dealerNameLabel.center.x = dealerHandContainer.center.x
        dealerNameLabel.frame.origin.y = dealerHandCardsContainer.frame.origin.y + dealerHandCardsContainer.frame.height + CGFloat(Configuration.PLAYER_NAME_PADDING_Y)

        // init dealer score label
        dealerScoreLabel.sizeToFit()
        dealerScoreLabel.center.y = dealerNameLabel.center.y
        dealerScoreLabel.frame.origin.x = dealerNameLabel.frame.origin.x + dealerNameLabel.frame.width + CGFloat(Configuration.PLAYER_SCORE_PADDING_X)
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

        initPlayerHandUI(player: _player!)
        initDealerHandUI(dealer: _dealer!)

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

    func handlePlayerBlackJack() {
        // hide restart game button from other view
        restartGameButton.isHidden = true

        // set game win status text
        gameResultLabel.text = "Blackjack!  You Win!"
        gameResultLabel.textColor = UIColor.green
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false
    }

    func setGameResultLabelPadding(labelPadding: CGFloat) {
        // left-padding
        gameResultLabel.frame.origin.x = gameResultContainer.frame.minX + labelPadding

        // right-padding
        gameResultLabel.frame.size.width = gameResultContainer.frame.width - labelPadding*2
    }

    func handlePlayerBust() {


        // hide restart game button from other view
        restartGameButton.isHidden = true

        // set game over status text
        gameResultLabel.text = "Dang, broheim, you busted."
        gameResultLabel.textColor = UIColor.red
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)


        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false
    }

    // determines if user busted or got blackjack and updates the UI accordingly
    func checkIfGameIsOver() {
        // check if user busted
        if (_player?.score())! > 21 {
            handlePlayerBust()
        } else if _player?.score() == 21 {
            handlePlayerBlackJack()
        } else {
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
