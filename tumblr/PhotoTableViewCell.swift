//
//  PhotoTableViewCell.swift
//  tumblr
//
//  Created by Nick McDonald on 1/23/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {


    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
