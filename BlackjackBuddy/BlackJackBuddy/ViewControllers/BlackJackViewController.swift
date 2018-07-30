//
//  ViewController.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/15/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Dispatch
import HandySwift
import SnapKit
import UIKit

class BlackJackViewController: UIViewController {
    // LOCAL VARS
    var _player: Player?
    var _dealer: Dealer?
    var _deck: Deck?
    var _currentGameNumber: Int = 0
    var _playerName: String?
    var _numberOfDecks: Int?
    var _user: User?

    @IBOutlet var superView: UIView!
    @IBOutlet var middleView: UIView!

    // PLAYER RECORD VIEWS
    @IBOutlet var dealerRecordLabel: UILabel!
    @IBOutlet var dealerRecordDescriptionLabel: UILabel!
    @IBOutlet var playerRecordLabel: UILabel!
    @IBOutlet var playerRecordDescriptionLabel: UILabel!
    @IBOutlet var playerRecordContainer: UIView!
    @IBOutlet var dealerRecordContainer: UIView!

    // DEALER VIEWS
    @IBOutlet var dealerHandContainer: UIView!
    @IBOutlet var dealerHandCardsContainer: UIImageView!
    @IBOutlet var dealerNameLabel: UILabel!

    // PLAYER VIEWS
    @IBOutlet var playerHandContainer: UIView!
    @IBOutlet var playerHandCardsContainer: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!

    // STATS VIEWS
    @IBOutlet var statsContainer: UIView!
    @IBOutlet var deckCountLabel: UILabel!
    @IBOutlet var cardsInDeckLabel: UILabel!
    @IBOutlet var playerScoreLabel: UILabel!
    @IBOutlet var dealerScoreLabel: UILabel!

    // RESTART GAME VIEWS
    @IBOutlet var restartGameButton: UIButton!
    @IBOutlet var restartGameLoadingCircle: UIImageView!

    @IBAction func restartGameButtonOnClick(_: Any) {
        TapticHelper.playNotificationError()
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
    @IBOutlet var playerStandButton: UIButton!

    func checkDealerGameOver(insurance: Bool) {
        if insurance {
            if(_dealer?.score().value == 21) {
                handlePlayerInsurancePayout()
            } else {
                handlePlayerInsuranceLoss()
            }
        } else {
            if (_dealer?.score().value)! >= 17 {
                // dealer bust -> player wins
                if (_dealer?.score().value)! > 21 {
                    handleDealerBust()

                    // dealer blackjack
                } else if _dealer?.score().value == 21 {
                    handleDealerBlackJack()
                } else {
                    if _player?.score().value ?? 0 > _dealer?.score().value ?? 0 {
                        handlePlayerWinByscore()
                    } else if _dealer?.score().value ?? 0 > _player?.score().value ?? 0 {
                        handleDealerWinByscore()
                    } else if _player?.score().value ?? 0 == _dealer?.score().value ?? 0 {
                        handleTieByscore()
                    }
                }
            }
        }
    }

    fileprivate func handleDealerTurn() {
        turnOverDealerCard(insurance: false)

        // it's dealer's turn when the player stands
        // dealer draws a card until their score is >= 17
        while (_dealer?.score().value)! < 17 {
            let dealtCard = _deck?.dealCard(player: _dealer!)
            addCardToHand(cardContainer: dealerHandCardsContainer, card: dealtCard!, player: _dealer!)
            updateStats()
        }

        // check one last time if dealer lost
        checkDealerGameOver(insurance: false)
    }

    fileprivate func turnOverDealerCard(insurance: Bool = false) {
        // turn dealer's second card face up
        _dealer?._cards[1]._isFaceUp = true

        // remove dealer's card images
        clearCardImages(player: "dealer")

        // re-add the cards to the dealer's hand now that the second card is face up
        for card in (_dealer?._cards)! {
            addCardToHand(cardContainer: dealerHandCardsContainer, card: card, player: _dealer!)
        }

        // update stats now that the card is flipped
        updateStats()
        checkDealerGameOver(insurance: insurance)
    }

    @IBAction func playerStandButtonOnClick(_: Any) {
        turnOverDealerCard()

        handleDealerTurn()
    }

    @IBOutlet var playerSplitButton: UIButton!
    @IBOutlet var playerDoubleDownButton: UIButton!

    @IBAction func playerDoubleDownButtonOnClick(_ sender: Any) {
        // player places an additional bet equal to their original bet

        // player draws one card and finishes their turn
        let dealtCard = (_deck?.dealCard(player: _player!))!
        addCardToHand(cardContainer: playerHandCardsContainer!, card: dealtCard, player: _player!)
        updateStats()

        // now the dealer takes a turn
        handleDealerTurn()
    }

    @IBOutlet var playerInsuranceButton: UIButton!
    @IBAction func playerInsuranceButtonOnClick(_ sender: Any) {
        // TODO: allow user to select their wager up to half the value of the original bet

        // once player has selected wager, turn over dealer's card and check for 21
        turnOverDealerCard(insurance: true)

        if _dealer?.score().value == 21 {
            // player gets 2:1 return on their wager
            print("Dealer got blackjack, player wins wager 2:1")
        } else {
            // player loses wager
            print("Dealer did not get blackjack, player loses wager")
        }
    }

    @IBOutlet var playerSurrenderButton: UIButton!
    @IBAction func playerSurrenderButtonOnClick(_ sender: Any) {
        // player recovers half their original bet

        // restart game
        initGame()
    }

    @IBOutlet var playerHitButton: UIButton!

    @IBAction func playerHitButtonOnClick(_: Any) {
        TapticHelper.playTapticCancelled()

        // disable hit and stand buttons
        playerHitButton.isEnabled = false
        playerStandButton.isEnabled = false

        // reload deck and shuffle it
        if _deck?._cards.count == 0 {
            _deck?.reloadDeck()
        }

        // deal card to player and check for a terminal state
        let dealtCard = (_deck?.dealCard(player: _player!))!
        addCardToHand(cardContainer: playerHandCardsContainer!, card: dealtCard, player: _player!)

        // if player drew a third card, disable the double down button
        playerDoubleDownButton.isEnabled = _player?._cards.count == 2

        updateStats()

        checkIfGameIsOver()

        let suggestedPlay = SuggestedPlayHelper.determineSuggestedPlay(_player: _player!, _dealer: _dealer!)

        toggleSuggestedPlayAnimation(action: suggestedPlay)

        print("Suggested play is \(suggestedPlay)")
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // UI FUNCTIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Updates label text for player scores, remaining cards in deck
    func updateStats() {
        playerScoreLabel.text = "\(_player?.score().type ?? HAND_VALUE_TYPE.HARD) \(_player?.score().value ?? 0)"
        dealerScoreLabel.text = "\(_dealer?.score().type ?? HAND_VALUE_TYPE.HARD) \(_dealer?.score().value ?? 0)"
        deckCountLabel.text = "\(_deck?._cards.count ?? 52) CARDS REMAINING IN DECK"
    }

    // sets the UIImageViews associated with the player's hand and the dealer's hand
    func clearCardImages() {
        for v in playerHandCardsContainer.subViews(type: UIImageView.self) {
            v.removeFromSuperview()
        }
        for v in dealerHandCardsContainer.subViews(type: UIImageView.self) {
            v.removeFromSuperview()
        }
    }

    func clearCardImages(player: String) {
        if player == "dealer" {
            for v in dealerHandCardsContainer.subViews(type: UIImageView.self) {
                v.removeFromSuperview()
            }
        } else if player == "player" {
            for v in playerHandCardsContainer.subViews(type: UIImageView.self) {
                v.removeFromSuperview()
            }
        }
    }

    func clearButtonAnimations(button: UIButton) {
        button.layer.removeAllAnimations()
        button.layer.shadowOpacity = 0
    }

    func startButtonAnimation(button: UIButton) {
        let animDuration: CGFloat = 1.5
        let cornerRadius: CGFloat = 5
        let maxGlowSize: CGFloat = 20
        let minGlowSize: CGFloat = 0
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowPath = CGPath(roundedRect: button.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        button.layer.shadowColor = UIColor.cyan.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = maxGlowSize
        button.layer.shadowOpacity = 1

        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = maxGlowSize
        layerAnimation.toValue = minGlowSize
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(animDuration/2)
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        button.layer.add(layerAnimation, forKey: "glowingAnimation")

    }

    func resetPlayerControlButtonStates() {
        // set enabled status
        playerInsuranceButton.isEnabled = false
        playerSplitButton.isEnabled = false
        playerHitButton.isEnabled = true
        playerSurrenderButton.isEnabled = true
        playerDoubleDownButton.isEnabled = false
        playerStandButton.isEnabled = true

        // disable glow
        clearAllButtonAnimations()
    }

    func clearAllButtonAnimations() {
        clearButtonAnimations(button: playerInsuranceButton)
        clearButtonAnimations(button: playerSplitButton)
        clearButtonAnimations(button: playerHitButton)
        clearButtonAnimations(button: playerSurrenderButton)
        clearButtonAnimations(button: playerDoubleDownButton)
        clearButtonAnimations(button: playerStandButton)
    }

    func setGameResultLabelPadding(labelPadding: CGFloat) {
        // left-padding
        gameResultLabel.frame.origin.x = gameResultContainer.frame.minX + labelPadding

        // right-padding
        gameResultLabel.frame.size.width = gameResultContainer.frame.width - labelPadding * 2
    }

    func bringGameResultViewToFront() {
        view.addSubview(gameResultContainer)
        gameResultContainer.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
        }

        gameResultRestartButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.bottom.equalTo(playerNameLabel.snp.top).offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y * -1)
            make.left.equalTo(playerInsuranceButton)
            make.right.equalTo(playerSurrenderButton)
            make.height.equalTo(gameResultRestartButton.snp.width)
                .multipliedBy(CGFloat(1) / CGFloat(4))
        }

        gameResultLabel.sizeToFit()
        gameResultLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dealerNameLabel.snp.bottom).offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.left.equalTo(playerInsuranceButton)
            make.right.equalTo(playerSurrenderButton)
            make.centerX.equalTo(view)
        }
    }

    func addCardToHand(cardContainer: UIView, card: Card, player _: Player) {
        let newCardImage = UIImageView()

        let subviews = cardContainer.allSubViewsOf(type: UIImageView.self)
        let last = subviews.last

        cardContainer.addSubview(newCardImage)

        let leftAnchor = subviews.count > 1 ? last?.snp.right : last?.snp.left

        newCardImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(newCardImage.snp.height)
                .multipliedBy(CGFloat(Configuration.CARD_WIDTH) / CGFloat(Configuration.CARD_HEIGHT))
            make.bottom.equalTo(cardContainer.snp.bottom)
                .offset(Configuration.CARD_PADDING_Y * -1)
            make.top.equalTo(cardContainer.snp.top).offset(Configuration.CARD_PADDING_Y)
            make.left.equalTo(leftAnchor!).offset(Configuration.CARD_PADDING_X)
        }

        if Configuration.SHOW_VIEW_OUTLINE_BORDERS {
            newCardImage.layer.borderColor = UIColor.red.cgColor
            newCardImage.layer.borderWidth = 2
        }

        CardHelper.updateCardImage(card: card, image: newCardImage)
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // GAME FUNCTIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // determines if user busted or got blackjack and updates the UI accordingly
    func checkIfGameIsOver() {
        // check if user busted
        if (_player?.score().value)! > 21 {
            handlePlayerBust()
        } else if _player?.score().value == 21 {
            handlePlayerBlackJack()
        } else {
            // enable hit and stand buttons
            playerHitButton.isEnabled = true
            playerStandButton.isEnabled = true
        }
    }

    func initialDeal() {
        print("------------------------------------------------------------")
        // deal card to player and check for a terminal state
        var dealtCard = (_deck?.dealCard(player: _player!))!
        addCardToHand(cardContainer: playerHandCardsContainer!, card: dealtCard, player: _player!)
        updateStats()

        // deal to Dealer
        dealtCard = (_deck?.dealCard(player: _dealer!))!
        addCardToHand(cardContainer: dealerHandCardsContainer!, card: dealtCard, player: _dealer!)
        updateStats()

        // deal to player again
        dealtCard = (_deck?.dealCard(player: _player!))!
        addCardToHand(cardContainer: playerHandCardsContainer!, card: dealtCard, player: _player!)
        updateStats()

        // deal face down card to dealer
        dealtCard = (_deck?.dealCard(player: _dealer!, isFaceUp: false))!
        addCardToHand(cardContainer: dealerHandCardsContainer!, card: dealtCard, player: _dealer!)
        updateStats()
        print("------------------------------------------------------------")
    }

    fileprivate func UpdatePlayerRecordLabels() {
        playerRecordLabel.text = _player?._record.toString
        dealerRecordLabel.text = _dealer?._record.toString
    }

    func handlePlayerInsurancePayout() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game win status text
        gameResultLabel.text = "Dealer got BlackJack!\nInsurance pays 2:1"
        gameResultLabel.textColor = .green
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // player won, update records
        _player?._record._wins += 1
        _dealer?._record._losses += 1
        UpdatePlayerRecordLabels()
    }

    func handlePlayerInsuranceLoss() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game over status text
        gameResultLabel.text = "Dealer did not get BlackJack.\nYou lose your wager."
        gameResultLabel.textColor = UIColor(named: "tomato")
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // player lost, update records
        _dealer?._record._wins += 1
        _player?._record._losses += 1
        UpdatePlayerRecordLabels()
    }

    func handlePlayerBust() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game over status text
        gameResultLabel.text = "Dang,\nyou busted.\n(\(_player?.score().value ?? 0))"
        gameResultLabel.textColor = UIColor(named: "tomato")
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // player lost, update records
        _dealer?._record._wins += 1
        _player?._record._losses += 1
        UpdatePlayerRecordLabels()
    }

    func handlePlayerBlackJack() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game win status text
        gameResultLabel.text = "Blackjack!  You Win!"
        gameResultLabel.textColor = .green
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // player won, update records
        _player?._record._wins += 1
        _dealer?._record._losses += 1
        UpdatePlayerRecordLabels()
    }

    func handleDealerWinByscore() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game over status text
        gameResultLabel.text = "Dealer wins by\nhigher score\n\(_dealer?.score().value ?? 0) vs \(_player?.score().value ?? 0)"
        gameResultLabel.textColor = UIColor(named: "tomato")
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // dealer won, update records
        _dealer?._record._wins += 1
        _player?._record._losses += 1
        UpdatePlayerRecordLabels()
    }

    func handlePlayerWinByscore() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game win status text
        gameResultLabel.text = "You win by\nhigher score\n\(_player?.score().value ?? 0) vs \(_dealer?.score().value ?? 0)"
        gameResultLabel.textColor = .green
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // player won, update records
        _player?._record._wins += 1
        _dealer?._record._losses += 1
        UpdatePlayerRecordLabels()
    }

    func handleTieByscore() {
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game win status text
        gameResultLabel.text = "It's a tie!\nBoth players have\nthe same score"
        gameResultLabel.textColor = .yellow
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.yellow.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // tied, update records
        _dealer?._record._ties += 1
        _player?._record._ties += 1
        UpdatePlayerRecordLabels()
    }

    func handleDealerBust() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game win status text
        gameResultLabel.text = "Dealer Busted!\n(\(_dealer?.score().value ?? 0))\nYou Win!"
        gameResultLabel.textColor = .green
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // dealer lost, update records
        _dealer?._record._losses += 1
        _player?._record._wins += 1
        UpdatePlayerRecordLabels()
    }

    func handleDealerBlackJack() {
        TapticHelper.playTapticCancelled()
        TapticHelper.playTapticCancelled()
        // hide restart game button from other view
        restartGameButton.isHidden = true
        restartGameLoadingCircle.isHidden = true

        // set game over status text
        gameResultLabel.text = "Dang, Dealer got BlackJack."
        gameResultLabel.textColor = UIColor(named: "tomato")
        gameResultLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        gameResultLabel.center.x = gameResultContainer.center.x
        gameResultLabel.sizeToFit()

        // set label's padding
        let labelPadding = CGFloat(10)
        setGameResultLabelPadding(labelPadding: labelPadding)

        // show the game result overlay
        gameResultContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        gameResultContainer.isUserInteractionEnabled = true
        gameResultContainer.isHidden = false

        // dealer won, update records
        _dealer?._record._wins += 1
        _player?._record._losses += 1
        UpdatePlayerRecordLabels()
    }

    func initGame(firstGame: Bool = false) {
        if firstGame {
            // init players
            let userName = _user?.name == nil || _user?.name == "" ? "PLAYER" : (_user?.name)!
            let userNumberOfDecks = _user?.numberOfDecks == nil ? 1 : _user?.numberOfDecks
            _player = Player(name: userName, chips: 0, cards: [], settings: PlayerSettings(suggestionsEnabled: true, numberOfDecks: userNumberOfDecks!, name: userName))
            _dealer = Dealer(name: "DEALER", chips: 0, cards: [], settings: PlayerSettings(suggestionsEnabled: true, numberOfDecks: userNumberOfDecks!, name: userName))

            playerNameLabel.text = _player?._name.uppercased()
            dealerNameLabel.text = _dealer?._name.uppercased()
        }

        UpdatePlayerRecordLabels()

        _player?._cards = []
        _dealer?._cards = []

        clearCardImages()
        resetPlayerControlButtonStates()

        // hide gameResultContainer
        gameResultContainer.isHidden = true
        gameResultContainer.isUserInteractionEnabled = false

        // unhide the deal again button from this view
        restartGameButton.isHidden = false
        restartGameLoadingCircle.isHidden = false

        bringGameResultViewToFront()

        // init deck
        if _deck == nil {
            _deck = Deck(numberOfDecks: _user?.numberOfDecks == nil ? 1 : (_user?.numberOfDecks)!)
        }
        _deck?.shuffleDeck()

        initialDeal()

        checkIfGameIsOver()

        // if player has 2 cards of the same rank, they can split
        // enable the split button
        playerSplitButton.isEnabled = (_player?.canSplit())!

        // the player can choose to double down only after the first draw,
        // so enable the double down button
        playerDoubleDownButton.isEnabled = true

        // insurance is available to the player when the dealer's upcard is an ace
        // enable insurance button
        playerInsuranceButton.isEnabled = _dealer?.upCard._rank == .ACE

        let suggestedPlay = SuggestedPlayHelper.determineSuggestedPlay(_player: _player!, _dealer: _dealer!)

        toggleSuggestedPlayAnimation(action: suggestedPlay)

        print("Suggested play is \(suggestedPlay)")
        _currentGameNumber += 1
    }

    func toggleSuggestedPlayAnimation(action: USER_ACTION) {
        clearAllButtonAnimations()

        switch action {
        case .HIT:
            startButtonAnimation(button: playerHitButton)
        case .STAND:
            startButtonAnimation(button: playerStandButton)
        case .SPLIT:
            startButtonAnimation(button: playerSplitButton)
        case .DOUBLE_DOWN:
            startButtonAnimation(button: playerDoubleDownButton)
        case .INSURANCE:
            startButtonAnimation(button: playerInsuranceButton)
        case .SURRENDER:
            startButtonAnimation(button: playerSurrenderButton)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // init players
        _player = Player(name: _user?.name == nil || _user?.name == "" ? "PLAYER" : (_user?.name)!, chips: 0, cards: [])
        _dealer = Dealer(name: "DEALER", chips: 0, cards: [], settings: PlayerSettings())

        LayoutHelper.initBaseBlackJackUI(_view: view, _viewController: self)

        initGame(firstGame: true)

        // check to see if user got blackjack or busted
        checkIfGameIsOver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
