//
//  ReviewTableViewCell.swift
//  TKG
//
//  Created by taka on 2018/07/29.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var reviewContentLabel: UILabel!
  @IBOutlet weak var reviewUserNameLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
