//
//  ShopMenusTableViewCell.swift
//  TKG
//
//  Created by taka on 2018/05/12.
//  Copyright © 2018年 tkg. All rights reserved.
//

// メニュー一覧テーブルのカスタムセルクラス

import UIKit

class ShopMenusTableViewCell: UITableViewCell {

  @IBOutlet weak var menuImageView: UIImageView!
  @IBOutlet weak var menuNameLabel: UILabel!
  @IBOutlet weak var menuPriceLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
