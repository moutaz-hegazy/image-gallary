//
//  tableViewCustomHeader.swift
//  image gallary
//
//  Created by Moutaz_Hegazy on 6/7/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class tableViewCustomHeader: UIView {
    
    var headerLabel = UILabel(){
        didSet{
            setNeedsDisplay()
        }
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        headerLabel.frame.size = bounds.size
        adjustFont()
        headerLabel.sizeToFit()
        headerLabel.frame.origin = CGPoint(x: bounds.minX + 100, y: bounds.minY)
        addSubview(headerLabel)
    }
    
    private func adjustFont(){
        var font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(30.0)
        font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: font)
        headerLabel.font = font
    }
    

}
