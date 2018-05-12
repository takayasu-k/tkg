//
//  ShopInfoTableViewCell.swift
//  TKG
//
//  Created by taka on 2018/05/06.
//  Copyright © 2018年 tkg. All rights reserved.
//

// 店舗詳細画面の店舗情報表示用カスタムテーブルセルクラス

import UIKit

class ShopInfoTableViewCell: UITableViewCell {

  // 店舗基本情報のタイトルラベル(例：住所)
  @IBOutlet weak var shopInfoTitleLabel: UILabel!
  
  // 店舗基本情報の内容ラベル(例：東京都…)
  @IBOutlet weak var shopInfoValueLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
