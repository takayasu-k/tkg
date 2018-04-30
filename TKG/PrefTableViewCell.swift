//
//  PrefTableViewCell.swift
//  TKG
//
//  Created by taka on 2018/04/30.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class PrefTableViewCell: UITableViewCell {

  @IBOutlet weak var prefName: UILabel!
  @IBOutlet weak var shopCount: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
