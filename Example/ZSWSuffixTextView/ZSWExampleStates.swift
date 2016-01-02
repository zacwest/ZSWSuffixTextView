//
//  ZSWExampleStates.swift
//  ZSWSuffixTextView
//
//  Created by Zachary West on 1/1/16.
//  Copyright © 2016 Zachary West. All rights reserved.
//

import Foundation
import ZSWTaggedString

protocol SuffixConvertible {
    static var tagName: String { get }
    var suffix: ZSWTaggedString? { get }
}

protocol OptionsPresentable: CustomStringConvertible, RawRepresentable {
    static var values: [Self] { get }
    static var title: String { get }
}

enum Location: Int, OptionsPresentable, SuffixConvertible {
    case None
    case SanFrancisco
    case NewYork
    
    static var title: String {
        return NSLocalizedString("Location", comment: "")
    }
    static var values: [Location] = [ .None, .SanFrancisco, .NewYork ]
    
    static var tagName: String { return "loc" }
    var suffix: ZSWTaggedString? {
        switch self {
        case .None:
            return nil
        case .SanFrancisco:
            return ZSWTaggedString(string: NSLocalizedString("in <loc>San Francisco</loc>", comment: ""))
        case .NewYork:
            return ZSWTaggedString(string: NSLocalizedString("in <loc>New York</loc>", comment: ""))
        }
    }
    
    var description: String {
        switch self {
        case .None:
            return NSLocalizedString("None", comment: "")
        case .SanFrancisco:
            return NSLocalizedString("San Francisco", comment: "")
        case .NewYork:
            return NSLocalizedString("New York", comment: "")
        }
    }
}

enum Time: Int, OptionsPresentable, SuffixConvertible {
    case None
    case Today
    case Tomorrow
    case Thursday
    
    static var title: String {
        return NSLocalizedString("Time", comment: "")
    }
    static var values: [Time] = [ .None, .Today, .Tomorrow, .Thursday ]
    
    static var tagName: String { return "time" }
    var suffix: ZSWTaggedString? {
        switch self {
        case .None:
            return nil
        case .Today:
            return ZSWTaggedString(string: "<time>" + NSLocalizedString("today", comment: "") + "</time>")
        case .Tomorrow:
            return ZSWTaggedString(string: "<time>" + NSLocalizedString("tomorrow", comment: "") + "</time>")
        case .Thursday:
            return ZSWTaggedString(string: NSLocalizedString("on <time>Thursday</time>", comment: ""))
        }
    }
    
    var description: String {
        switch self {
        case .None:
            return NSLocalizedString("None", comment: "")
        case .Today:
            return NSLocalizedString("Today", comment: "")
        case .Tomorrow:
            return NSLocalizedString("Tomorrow", comment: "")
        case .Thursday:
            return NSLocalizedString("Thursday", comment: "")
        }
    }
}

enum Mood: Int, OptionsPresentable, SuffixConvertible {
    case None
    case Happy
    case Sad
    case Nauseous
    case Perplexed
    
    static var title: String {
        return NSLocalizedString("Mood", comment: "")
    }
    static var values: [Mood] = [ .None, .Happy, .Sad, .Nauseous, .Perplexed ]
    
    static var tagName: String { return "mood" }
    var suffix: ZSWTaggedString? {
        switch self {
        case .None:
            return nil
        case .Happy:
            return ZSWTaggedString(string: NSLocalizedString("feeling <mood>happy</mood>", comment: ""))
        case .Sad:
            return ZSWTaggedString(string: NSLocalizedString("feeling <mood>sad</mood>", comment: ""))
        case .Nauseous:
            return ZSWTaggedString(string: NSLocalizedString("feeling <mood>nauseous</mood>", comment: ""))
        case .Perplexed:
            return ZSWTaggedString(string: NSLocalizedString("feeling <mood>perplexed</mood>", comment: ""))
        }
    }
    
    var description: String {
        switch self {
        case .None:
            return NSLocalizedString("None", comment: "")
        case .Happy:
            return NSLocalizedString("Happy", comment: "")
        case .Sad:
            return NSLocalizedString("Sad", comment: "")
        case .Nauseous:
            return NSLocalizedString("Nauseous", comment: "")
        case .Perplexed:
            return NSLocalizedString("Perplexed", comment: "")
        }
    }
}
