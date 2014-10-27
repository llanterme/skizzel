//
//  ReceiptMonthsTableViewCell.swift
//  skizzel
//
//  Created by Luke Lanterme on 2014/10/23.
//  Copyright (c) 2014 Luke Lanterme. All rights reserved.
//

import UIKit

class ReceiptMonthsTableViewCell: UITableViewCell {

    @IBOutlet weak var receiptMonth: UILabel!

    @IBOutlet weak var receiptBlockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    override func layoutSubviews() {
        receiptBlockImage.layer.cornerRadius = 10.0
        receiptBlockImage.clipsToBounds = true
    }

}
