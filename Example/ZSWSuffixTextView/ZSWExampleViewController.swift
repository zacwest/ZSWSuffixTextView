//
//  ZSWViewController.swift
//  ZSWSuffixTextView
//
//  Created by Zachary West on 1/1/16.
//  Copyright © 2016 Zachary West. All rights reserved.
//

import ZSWSuffixTextView

class ZSWExampleViewController: UIViewController {
    var exampleView: ZSWExampleView { return self.view as! ZSWExampleView }
    
    var location: Location = .None {
        didSet {
            updateSuffix()
        }
    }
    
    var time: Time = .None {
        didSet {
            updateSuffix()
        }
    }
    
    var mood: Mood = .None {
        didSet {
            updateSuffix()
        }
    }
    
    let _inputAccessoryView = ZSWInputAccessoryView()
    override var inputAccessoryView: UIView? {
        return _inputAccessoryView
    }
    
    override func loadView() {
        view = ZSWExampleView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = NSLocalizedString("Update Status", comment: "")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        exampleView.textView.becomeFirstResponder()
        
        _inputAccessoryView.toolbar.items = [
            UIBarButtonItem(title: "Location", style: .Plain, target: self, action: "location:"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Time", style: .Plain, target: self, action: "time:"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Mood", style: .Plain, target: self, action: "mood:")
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exampleView.textView.placeholder = NSLocalizedString("What's up?", comment: "")
    }
    
    func updateSuffix() {
        let suffixes = ([mood, time, location] as [SuffixConvertible]).flatMap { $0.suffix }
        
        if suffixes.isEmpty {
            exampleView.textView.suffix = nil
        } else {
            exampleView.textView.suffix = (["—"] + suffixes).joinWithSeparator(" ")
        }
    }
    
    func presentOptions<T: OptionsPresentable where T.RawValue: Equatable>(currentValue: T, completion: (T) -> Void) {
        let controller = UIAlertController(title: T.title, message: nil, preferredStyle: .ActionSheet)
        
        let actions = T.values.map { (value) -> UIAlertAction in
            var valueString: String = value.description
            
            if value.rawValue == currentValue.rawValue {
                valueString += " √ "
            }
            
            return UIAlertAction(title: valueString, style: .Default) { _ in
                completion(value)
            }
        }
        
        for action in actions {
            controller.addAction(action)
        }
        
        controller.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func location(sender: UIControl) {
        presentOptions(location) { [weak self] updatedLocation in
            self?.location = updatedLocation
        }
    }
    
    func time(sender: UIControl) {
        presentOptions(time) { [weak self] updatedTime in
            self?.time = updatedTime
        }
    }
    
    func mood(sender: UIControl) {
        presentOptions(mood) { [weak self] updatedMood in
            self?.mood = updatedMood
        }
    }
}

extension ZSWExampleViewController: ZSWTappableLabelTapDelegate {
    func tappableLabel(tappableLabel: ZSWTappableLabel, tappedAtIndex idx: Int, withAttributes attributes: [String : AnyObject]) {
        
    }
}
