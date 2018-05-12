//
//  ShopsTableViewCell.swift
//  TKG
//
//  Created by taka on 2018/05/02.
//  Copyright © 2018年 tkg. All rights reserved.
//

// 店舗一覧テーブルビューのカスタムセルクラス

import UIKit

class ShopsTableViewCell: UITableViewCell {

  @IBOutlet weak var shopImageView: UIImageView!  // 店舗トップ画像
  @IBOutlet weak var shopNameLabel: UILabel!      // 店舗名ラベル
  @IBOutlet weak var shopAddressLabel: UILabel!   // 店舗の住所ラベル
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
