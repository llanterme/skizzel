//
//  MainViewTableViewCell.swift
//  skizzel
//
//  Created by Luke Lanterme on 2014/10/09.
//  Copyright (c) 2014 Luke Lanterme. All rights reserved.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {


    
    @IBOutlet weak var receiptDateCreated: UILabel!

    @IBOutlet weak var receiptAlias: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
