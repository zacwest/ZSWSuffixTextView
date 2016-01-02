//
//  ZSWExampleStates.swift
//  ZSWSuffixTextView
//
//  Created by Zachary West on 1/1/16.
//  Copyright © 2016 Zachary West. All rights reserved.
//

import Foundation

protocol OptionsPresentable: CustomStringConvertible, RawRepresentable {
    static var values: [Self] { get }
    static var title: String { get }
}

enum Location: Int, OptionsPresentable {
    case None
    case SanFrancisco
    case NewYork
    
    static var title: String {
        return NSLocalizedString("Location", comment: "")
    }
    static var values: [Location] = [ .None, .SanFrancisco, .NewYork ]
    
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

enum Time: Int, OptionsPresentable {
    case None
    case Today
    case Tomorrow
    case Thursday
    
    static var title: String {
        return NSLocalizedString("Time", comment: "")
    }
    static var values: [Time] = [ .None, .Today, .Tomorrow, .Thursday ]
    
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

enum Mood: Int, OptionsPresentable {
    case None
    case Happy
    case Sad
    case Nauseous
    case Perplexed
    
    static var title: String {
        return NSLocalizedString("Mood", comment: "")
    }
    static var values: [Mood] = [ .None, .Happy, .Sad, .Nauseous, .Perplexed ]
    
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
