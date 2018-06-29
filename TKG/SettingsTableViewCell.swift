//
//  SettingsTableViewCell.swift
//  TKG
//
//  Created by taka on 2018/06/03.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

  @IBOutlet weak var settingsContentLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
