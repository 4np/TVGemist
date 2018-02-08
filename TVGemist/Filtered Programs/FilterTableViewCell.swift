//
//  FilterTableViewCell.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 14/12/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import NPOKit

class FilterTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FilterTableViewCellIdentifier"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = ""
    }
    
    func configure(with filterOption: FilterOption) {
        textLabel?.text = filterOption.title
        textLabel?.textColor = UIColor.white
    }
}
