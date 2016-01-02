//
//  ZSWInputAccessoryView.swift
//  ZSWSuffixTextView
//
//  Created by Zachary West on 1/1/16.
//  Copyright © 2016 Zachary West. All rights reserved.
//

import UIKit

class ZSWInputAccessoryView: UIView {
    let toolbar = UIToolbar()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        
        addSubview(toolbar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        toolbar.frame = self.bounds
    }
}