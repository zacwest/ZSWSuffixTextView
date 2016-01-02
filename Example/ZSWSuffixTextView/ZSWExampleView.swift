//
//  ZSWExampleView.swift
//  ZSWSuffixTextView
//
//  Created by Zachary West on 1/1/16.
//  Copyright © 2016 Zachary West. All rights reserved.
//

import UIKit
import ZSWSuffixTextView

class ZSWExampleView: UIView {
    let textView = ZSWSuffixTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFontOfSize(18.0)
        // This is the edges on the top, left, bottom & right of the text view
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        // This is another inset (lol UIKit) which is on the left & right
        textView.textContainer.lineFragmentPadding = 0
        addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = self.bounds
    }
}
