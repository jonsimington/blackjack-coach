//
//  LayoutHelper.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 7/26/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class LayoutHelper {
    static func initBaseUserSetupUI(_view: UIView, _viewController: UserSetupViewController) {
        let topPadding = _view.safeAreaInsets.top
        let bottomPadding = _view.safeAreaInsets.bottom

        _viewController.numberOfDecksSlider.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(_view).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(_view).inset(Configuration.CARD_CONTAINER_PADDING_X)
            make.center.equalTo(_view)
        }

        _viewController.numberOfDecksLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(_view)
            make.top.equalTo(_viewController.numberOfDecksSlider.snp.bottom).offset(Configuration.LABEL_PADDING_Y * 2)
        }

        _viewController.numberOfDecksSliderDescription.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(_view).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(_view).inset(Configuration.CARD_CONTAINER_PADDING_X)
            make.centerX.equalTo(_view)
            make.bottom.equalTo(_viewController.numberOfDecksSlider.snp.top).offset(Configuration.LABEL_PADDING_Y * -2)
        }

        _viewController.playButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(_view).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(_view).inset(Configuration.CARD_CONTAINER_PADDING_X)
            make.centerX.equalTo(_view)
            make.height.equalTo(_viewController.playButton.snp.width).multipliedBy(0.25)

            let safeAreaBottomY = _view.frame.maxY + (CGFloat(bottomPadding) * 3)
            let numberOfDecksLabelBottomY = _viewController.numberOfDecksLabel.frame.maxY
            make.centerY.equalTo(((safeAreaBottomY - numberOfDecksLabelBottomY) / 2) + numberOfDecksLabelBottomY)
        }

        _viewController.userNameTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(_view).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(_view).inset(Configuration.CARD_CONTAINER_PADDING_X)
            make.centerX.equalTo(_view)
            make.height.equalTo(_viewController.userNameTextField.snp.width).multipliedBy(0.15)

            let safeAreaTopY = _view.frame.minY + CGFloat(topPadding)
            let numberOfDecksLabelTopY = _viewController.numberOfDecksSliderDescription.frame.minY
            make.centerY.equalTo(((numberOfDecksLabelTopY - safeAreaTopY) / 2) + safeAreaTopY)
        }

        _viewController.userNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(_view).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(_view).inset(Configuration.CARD_CONTAINER_PADDING_X)
            make.centerX.equalTo(_view)
            make.width.equalTo(_viewController.userNameTextField)
            make.bottom.equalTo(_viewController.userNameTextField.snp.top).offset(Configuration.LABEL_PADDING_Y * -1)
        }
    }

    static func initBaseLaunchScreenUI(_view _: UIView, _viewController _: BlackJackViewController) {
    }

    static func initBaseBlackJackUI(_view: UIView, _viewController: BlackJackViewController) {
        // bind playerHandContainer to bottom of superView's safearea
        _view.addSubview(_viewController.playerHandContainer)
        _viewController.playerHandContainer.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(_view.safeAreaLayoutGuide)
            make.left.equalTo(_view.safeAreaLayoutGuide)
            make.right.equalTo(_view.safeAreaLayoutGuide)
        }

        // bind playerHandContainer to bottom of superView's safearea
        _viewController.playerHandContainer.addSubview(_viewController.playerHandCardsContainer)
        _viewController.playerHandCardsContainer.snp.makeConstraints { (make) -> Void in

            make.bottom.equalTo(_viewController.playerHandContainer.snp.bottom)
            make.left.equalTo(_viewController.playerHandContainer.snp.left).offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(_viewController.playerHandContainer.snp.right).offset(Configuration.CARD_CONTAINER_PADDING_X * -1)
            make.height.equalTo(_view.snp.height).multipliedBy(0.12)
            make.bottom.equalTo(_viewController.playerHandContainer.snp.bottom)
        }

        // init player name label
        _viewController.playerNameLabel.text = _viewController._player?._name.uppercased()
        _viewController.playerNameLabel.sizeToFit()
        _viewController.playerHandContainer.addSubview(_viewController.playerNameLabel)
        _viewController.playerNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerHandContainer.snp.top)
                .offset(Configuration.PLAYER_NAME_PADDING_Y)
            make.bottom.equalTo(_viewController.playerHandCardsContainer.snp.top)
                .offset(Configuration.PLAYER_NAME_PADDING_Y * -1)
            make.edges.lessThanOrEqualTo(_viewController.playerHandContainer)
                .inset(Configuration.LABEL_PADDING_X)
            make.width.equalTo(_viewController.playerNameLabel.frame.width * 2.5)

            make.height.equalTo(_viewController.dealerNameLabel)
        }

        // init player score label
        _viewController.playerHandContainer.addSubview(_viewController.playerScoreLabel)
        _viewController.playerScoreLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(_viewController.playerNameLabel.snp.centerY)
            make.left.equalTo(_viewController.playerNameLabel.snp.right)
            make.height.equalTo(_viewController.playerNameLabel)
            make.right.equalTo(_viewController.playerHandContainer).inset(Configuration.LABEL_PADDING_X)
        }

        // bind _viewController.dealerHandContainer to top of superView's safeArea
        _view.addSubview(_viewController.dealerHandContainer)
        _viewController.dealerHandContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_view.safeAreaLayoutGuide)
            make.left.equalTo(_view.safeAreaLayoutGuide)
            make.right.equalTo(_view.safeAreaLayoutGuide)
        }
        // bind _viewController.dealerHandContainer to bottom of superView's safearea
        _viewController.dealerHandContainer.addSubview(_viewController.dealerHandCardsContainer)
        _viewController.dealerHandCardsContainer.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(_viewController.dealerHandContainer.snp.left)
                .offset(Configuration.CARD_CONTAINER_PADDING_X)
            make.right.equalTo(_viewController.dealerHandContainer.snp.right)
                .offset(Configuration.CARD_CONTAINER_PADDING_X * -1)
            make.top.equalTo(_viewController.dealerHandContainer.snp.top)
            make.height.equalTo(_view.snp.height).multipliedBy(0.12)
        }

        // init dealer name label
        _viewController.dealerNameLabel.text = _viewController._dealer?._name.uppercased()
        _viewController.dealerNameLabel.sizeToFit()

        _viewController.dealerHandContainer.addSubview(_viewController.dealerNameLabel)
        _viewController.dealerNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.dealerHandCardsContainer.snp.bottom)
                .offset(Configuration.PLAYER_NAME_PADDING_Y)
            make.bottom.equalTo(_viewController.dealerHandContainer.snp.bottom)
                .offset(Configuration.PLAYER_NAME_PADDING_Y * -1)
            make.width.equalTo(_viewController.dealerNameLabel.frame.width * 1.3)
            make.left.equalTo(_viewController.dealerHandContainer).offset(Configuration.LABEL_PADDING_X)
        }

        // init dealer score label
        _viewController.dealerHandContainer.addSubview(_viewController.dealerScoreLabel)

        _viewController.dealerScoreLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(_viewController.dealerNameLabel.snp.centerY)
            make.left.equalTo(_viewController.dealerNameLabel.snp.right)
            make.height.equalTo(_viewController.dealerNameLabel)
            make.right.equalTo(_viewController.dealerHandContainer).inset(Configuration.LABEL_PADDING_X)
        }

        // bind middle _view between card hands containers
        _view.addSubview(_viewController.middleView)
        _viewController.middleView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(_viewController.playerHandContainer.snp.top)
            make.top.equalTo(_viewController.dealerHandContainer.snp.bottom)
            make.left.equalTo(_view)
            make.right.equalTo(_view)
        }

        // init player controls _view
        _viewController.middleView.addSubview(_viewController.playerControlsContainer)
        _viewController.middleView.addSubview(_viewController.statsContainer)

        _viewController.statsContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.middleView)
            make.centerX.equalTo(_viewController.middleView)
            print("stats \(_viewController.statsContainer.center.x) middle \(_viewController.middleView.center.x)")
        }

        _viewController.statsContainer.addSubview(_viewController.deckCountLabel)

        _viewController.deckCountLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(_viewController.middleView).inset(Configuration.LABEL_PADDING_X)
            make.left.equalTo(_viewController.middleView).inset(Configuration.LABEL_PADDING_X)
            make.top.equalTo(_viewController.dealerRecordLabel.snp.bottom).offset(Configuration.LABEL_PADDING_Y * 2)
            make.bottom.equalTo(_viewController.playerControlsContainer.snp.top)
        }

        _viewController.playerControlsContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.middleView).offset(_viewController.statsContainer.frame.size.height)
            make.bottom.equalTo(_viewController.middleView.snp.bottom)
            make.width.equalTo(_viewController.middleView)
        }

        _viewController.playerControlsContainer.isUserInteractionEnabled = true
        _viewController.playerControlsContainer.addSubview(_viewController.playerInsuranceButton)
        _viewController.playerControlsContainer.addSubview(_viewController.playerSurrenderButton)
        _viewController.playerControlsContainer.addSubview(_viewController.playerSplitButton)
        _viewController.playerControlsContainer.addSubview(_viewController.playerDoubleDownButton)
        _viewController.playerControlsContainer.addSubview(_viewController.playerHitButton)
        _viewController.playerControlsContainer.addSubview(_viewController.playerStandButton)
        _viewController.playerControlsContainer.addSubview(_viewController.restartGameButton)
        _viewController.playerControlsContainer.addSubview(_viewController.playerRecordLabel)
        _viewController.playerControlsContainer.addSubview(_viewController.dealerRecordLabel)
        _viewController.playerControlsContainer.addSubview(_viewController.restartGameLoadingCircle)
        _viewController.playerControlsContainer.addSubview(_viewController.playerRecordDescriptionLabel)
        _viewController.playerControlsContainer.addSubview(_viewController.dealerRecordDescriptionLabel)


        _viewController.playerInsuranceButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y*3)
            make.left.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
            make.width.lessThanOrEqualTo((_viewController.middleView.frame.width - (3.0 * CGFloat(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X))) / 2.0)
        }

        _viewController.playerSurrenderButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y*3)
            make.right.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X * -3)
            make.width.equalTo(_viewController.playerInsuranceButton)
        }

        _viewController.playerSplitButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerInsuranceButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(_viewController.playerInsuranceButton)
            make.left.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
        }

        _viewController.playerDoubleDownButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerSurrenderButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(_viewController.playerInsuranceButton)
            make.right.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X * -3)
        }

        _viewController.playerHitButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerSplitButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(_viewController.playerInsuranceButton)
            make.left.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X)
        }

        _viewController.playerStandButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerDoubleDownButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.width.equalTo(_viewController.playerInsuranceButton)
            make.right.equalTo(_viewController.playerControlsContainer)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_X * -3)
        }

        _viewController.restartGameButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(_viewController.playerHitButton.snp.bottom)
                .offset(Configuration.PLAYER_CONTROL_BUTTON_PADDING_Y)
            make.left.equalTo(_viewController.playerHitButton)
            make.right.equalTo(_viewController.playerStandButton)
        }

        _viewController.restartGameLoadingCircle.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(_viewController.restartGameButton)
                .offset(Configuration.DEAL_AGAIN_LOADING_CIRCLE_PADDING_X)
            make.centerY.equalTo(_viewController.restartGameButton)
            make.height.equalTo(_viewController.restartGameLoadingCircle.frame.size.height * 0.95)
            make.width.equalTo(_viewController.restartGameLoadingCircle.frame.size.width * 0.95)
        }

        _viewController.playerRecordDescriptionLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(_viewController.playerHandCardsContainer)
            make.bottom.equalTo(_viewController.playerNameLabel.snp.top).offset(Configuration.LABEL_PADDING_Y * -1)
        }

        _viewController.playerRecordLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(_viewController.playerRecordDescriptionLabel.snp.right).offset(Configuration.LABEL_PADDING_X)
            make.centerY.equalTo(_viewController.playerRecordDescriptionLabel)
            make.right.equalTo(_viewController.playerHandCardsContainer)
        }

        _viewController.dealerRecordDescriptionLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(_viewController.dealerHandCardsContainer)
            make.top.equalTo(_viewController.dealerNameLabel.snp.bottom).offset(Configuration.LABEL_PADDING_Y)
        }

        _viewController.dealerRecordLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(_viewController.dealerRecordDescriptionLabel.snp.right).offset(Configuration.LABEL_PADDING_X)
            make.centerY.equalTo(_viewController.dealerRecordDescriptionLabel)
            make.right.equalTo(_viewController.dealerHandCardsContainer)
        }

        // show borders on _view edges for debugging
        if Configuration.SHOW_VIEW_OUTLINE_BORDERS {
            // dealer hand
            _viewController.dealerHandContainer.layer.borderColor = UIColor.purple.cgColor
            _viewController.dealerHandContainer.layer.borderWidth = 2
            _viewController.dealerNameLabel.layer.borderColor = UIColor.green.cgColor
            _viewController.dealerNameLabel.layer.borderWidth = 2
            _viewController.dealerScoreLabel.layer.borderColor = UIColor.red.cgColor
            _viewController.dealerScoreLabel.layer.borderWidth = 2
            _viewController.dealerHandCardsContainer.layer.borderColor = UIColor.red.cgColor
            _viewController.dealerHandCardsContainer.layer.borderWidth = 2

            // _viewController.middleView
            _viewController.middleView.layer.borderColor = UIColor.orange.cgColor
            _viewController.middleView.layer.borderWidth = 2
            _viewController.statsContainer.layer.borderColor = UIColor.magenta.cgColor
            _viewController.statsContainer.layer.borderWidth = 4
            _viewController.deckCountLabel.layer.borderColor = UIColor.magenta.cgColor
            _viewController.deckCountLabel.layer.borderWidth = 2
            _viewController.playerControlsContainer.layer.borderColor = UIColor.cyan.cgColor
            _viewController.playerControlsContainer.layer.borderWidth = 4

            // player buttons
            _viewController.playerInsuranceButton.layer.borderColor = UIColor.purple.cgColor
            _viewController.playerInsuranceButton.layer.borderWidth = 3
            _viewController.playerSurrenderButton.layer.borderColor = UIColor.purple.cgColor
            _viewController.playerSurrenderButton.layer.borderWidth = 3
            _viewController.playerSplitButton.layer.borderColor = UIColor.purple.cgColor
            _viewController.playerSplitButton.layer.borderWidth = 3
            _viewController.playerDoubleDownButton.layer.borderColor = UIColor.purple.cgColor
            _viewController.playerDoubleDownButton.layer.borderWidth = 3
            _viewController.playerHitButton.layer.borderColor = UIColor.purple.cgColor
            _viewController.playerHitButton.layer.borderWidth = 3
            _viewController.playerStandButton.layer.borderColor = UIColor.purple.cgColor
            _viewController.playerStandButton.layer.borderWidth = 3
            _viewController.restartGameButton.layer.borderColor = UIColor.purple.cgColor
            _viewController.restartGameButton.layer.borderWidth = 3
            _viewController.restartGameLoadingCircle.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
            _viewController.restartGameLoadingCircle.layer.borderWidth = 2

            // player hand
            _viewController.playerHandContainer.layer.borderColor = UIColor.purple.cgColor
            _viewController.playerHandContainer.layer.borderWidth = 2
            _viewController.playerNameLabel.layer.borderColor = UIColor.green.cgColor
            _viewController.playerNameLabel.layer.borderWidth = 2
            _viewController.playerScoreLabel.layer.borderColor = UIColor.red.cgColor
            _viewController.playerScoreLabel.layer.borderWidth = 2
            _viewController.playerHandCardsContainer.layer.borderColor = UIColor.red.cgColor
            _viewController.playerHandCardsContainer.layer.borderWidth = 2
        }
    }
}
