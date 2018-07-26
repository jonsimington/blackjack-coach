//
//  UIDeviceInfo.swift
//  BlackjackBuddy
//
//  Created by Jon Simington on 6/29/18.
//  Copyright © 2018 Jon Simington. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    enum DevicePlatform: String {
        case other = "Old Device"
        case iPhone
        case iPhone3G = "iPhone 3G"
        case iPhone3GS = "iPhone 3GS"
        case iPhone4 = "iPhone 4"
        case iPhone4_GSM_RevA = "iPhone 4 GSM Rev A"
        case iPhone4_CDMA = "iPhone 4 CDMA"
        case iPhone4S = "iPhone 4S"
        case iPhone5_GSM = "iPhone 5 (GSM)"
        case iPhone5_GSM_CDMA = "iPhone 5 (GSM+CDMA)"
        case iPhone5C_GSM = "iPhone 5C (GSM)"
        case iPhone5C_Global = "iPhone 5C (Global)"
        case iPhone5S_GSM = "iPhone 5S (GSM)"
        case iPhone5S_Global = "iPhone 5S (Global)"
        case iPhone6Plus = "iPhone 6 Plus"
        case iPhone6 = "iPhone 6"
        case iPhoneSE_GSM_CDMA = "iPhone SE (GSM+CDMA)"
        case iPhoneSE_GSM = "iPhone SE (GSM)"
        case iPhone6S = "iPhone 6S"
        case iPhone6SPlus = "iPhone 6S Plus"
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
        case iPhone8 = "iPhone 8"
        case iPhone8Plus = "iPhone 8 Plus"
        case iPhoneX = "iPhone X"
    }

    var platform: DevicePlatform {
        var sysinfo = utsname()
        uname(&sysinfo)
        let platform = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        switch platform {
        case "iPhone10,6", "iPhone10,3":
            return .iPhoneX
        case "iPhone10,5", "iPhone10,2":
            return .iPhone8Plus
        case "iPhone10,4", "iPhone10,1":
            return .iPhone8
        case "iPhone9,2", "iPhone9,4":
            return .iPhone7Plus
        case "iPhone9,1", "iPhone9,3":
            return .iPhone7
        case "iPhone8,2":
            return .iPhone6SPlus
        case "iPhone8,1":
            return .iPhone6S
        case "iPhone1,1":
            return .iPhone
        case "iPhone1,2":
            return .iPhone3G
        case "iPhone2,1":
            return .iPhone3GS
        case "iPhone3,1":
            return .iPhone4
        case "iPhone3,2":
            return .iPhone4_GSM_RevA
        case "iPhone3,3":
            return .iPhone4_CDMA
        case "iPhone4,1":
            return .iPhone4S
        case "iPhone5,1":
            return .iPhone5_GSM
        case "iPhone5,2":
            return .iPhone5_GSM_CDMA
        case "iPhone5,3":
            return .iPhone5C_GSM
        case "iPhone5,4":
            return .iPhone5C_Global
        case "iPhone6,1":
            return .iPhone5S_GSM
        case "iPhone6,2":
            return .iPhone5S_Global
        case "iPhone7,1":
            return .iPhone6Plus
        case "iPhone7,2":
            return .iPhone6
        case "iPhone8,3":
            return .iPhoneSE_GSM_CDMA
        case "iPhone8,4":
            return .iPhoneSE_GSM
        default:
            return .other
        }
    }

    var hasTapticEngine: Bool {
        return platform == .iPhone6S || platform == .iPhone6SPlus ||
            platform == .iPhone7 || platform == .iPhone7Plus ||
            platform == .iPhone8Plus || platform == .iPhone8 ||
            platform == .iPhoneX
    }

    var hasHapticFeedback: Bool {
        return platform == .iPhone7 || platform == .iPhone7Plus ||
            platform == .iPhone8Plus || platform == .iPhone8 ||
            platform == .iPhoneX
    }
}
