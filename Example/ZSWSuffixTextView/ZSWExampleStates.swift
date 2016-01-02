//
//  ZSWExampleStates.swift
//  ZSWSuffixTextView
//
//  Created by Zachary West on 1/1/16.
//  Copyright © 2016 Zachary West. All rights reserved.
//

import Foundation

protocol SuffixConvertible {
    var suffix: String? { get }
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
    
    var suffix: String? {
        switch self {
        case .None:
            return nil
        case .SanFrancisco:
            return NSLocalizedString("in San Francisco", comment: "")
        case .NewYork:
            return NSLocalizedString("in New York", comment: "")
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
    
    var suffix: String? {
        switch self {
        case .None:
            return nil
        case .Today:
            return NSLocalizedString("today", comment: "")
        case .Tomorrow:
            return NSLocalizedString("tomorrow", comment: "")
        case .Thursday:
            return NSLocalizedString("Thursday", comment: "")
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
    
    var suffix: String? {
        switch self {
        case .None:
            return nil
        case .Happy:
            return NSLocalizedString("feeling happy", comment: "")
        case .Sad:
            return NSLocalizedString("feeling sad", comment: "")
        case .Nauseous:
            return NSLocalizedString("feeling nauseous", comment: "")
        case .Perplexed:
            return NSLocalizedString("feeling perplexed", comment: "")
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
