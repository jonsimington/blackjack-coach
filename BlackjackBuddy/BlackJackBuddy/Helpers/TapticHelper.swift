//
//  TapticHelper.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/29/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import AudioToolbox.AudioServices
import Foundation
import UIKit

class TapticHelper {
    // init taptic engine
    static let feedbackGenerator: (notification: UINotificationFeedbackGenerator, impact: (light: UIImpactFeedbackGenerator, medium: UIImpactFeedbackGenerator, heavy: UIImpactFeedbackGenerator), selection: UISelectionFeedbackGenerator) = {
        (notification: UINotificationFeedbackGenerator(), impact: (light: UIImpactFeedbackGenerator(style: .light), medium: UIImpactFeedbackGenerator(style: .medium), heavy: UIImpactFeedbackGenerator(style: .heavy)), selection: UISelectionFeedbackGenerator())
    }()

    static func playStandardVibration() {
        // Standard vibration
        let standard = SystemSoundID(kSystemSoundID_Vibrate) // 4095
        AudioServicesPlaySystemSoundWithCompletion(standard, {
            print("did standard vibrate")
        })
    }

    static func playAlertVibration() {
        let alert = SystemSoundID(1011)
        AudioServicesPlaySystemSoundWithCompletion(alert, {
            print("did alert vibrate")
        })
    }

    static func playTapticPeek() {
        // Peek
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSoundWithCompletion(peek, {
            print("did peek")
        })
    }

    static func playTapticPop() {
        // Pop
        let pop = SystemSoundID(1520)
        AudioServicesPlaySystemSoundWithCompletion(pop, {
            print("did pop")
        })
    }

    static func playTapticCancelled() {
        // Cancelled
        let cancelled = SystemSoundID(1521)
        AudioServicesPlaySystemSoundWithCompletion(cancelled, {
        })
    }

    static func playTapticTryAgain() {
        // Try Again
        let tryAgain = SystemSoundID(1102)
        AudioServicesPlaySystemSoundWithCompletion(tryAgain, {
            print("did try again")
        })
    }

    static func playTapticFailed() {
        // Failed
        let failed = SystemSoundID(1107)
        AudioServicesPlaySystemSoundWithCompletion(failed, {
            print("did failed")
        })
    }

    static func playNotificationSuccess() {
        // Success
        feedbackGenerator.notification.notificationOccurred(.success)
    }

    static func playNotificationWarning() {
        // Warning
        feedbackGenerator.notification.notificationOccurred(.warning)
    }

    static func playNotificationError() {
        // Error
        feedbackGenerator.notification.notificationOccurred(.error)
    }

    static func playImpactLight() {
        // Light
        feedbackGenerator.impact.light.impactOccurred()
    }

    static func playImpactMedium() {
        // Medium
        feedbackGenerator.impact.medium.impactOccurred()
    }

    static func playImpactHeavy() {
        // Heavy
        feedbackGenerator.impact.heavy.impactOccurred()
    }

    static func playSelectionChanged() {
        // Selection
        feedbackGenerator.selection.selectionChanged()
    }
}
