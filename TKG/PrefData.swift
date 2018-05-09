//
//  PrefData.swift
//  TKG
//
//  Created by taka on 2018/05/09.
//  Copyright © 2018年 tkg. All rights reserved.
//

import Foundation


// 店舗のある都道府県と店舗数の一覧を受け取るための構造体
struct PrefData: Codable {
  // idに関しては不要なのでサーバー側で消去した後にこちらも削除
  var id: Int?
  var prefID: Int
  var prefName: String
  var shopCount: Int
  
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case prefID = "pref_id"
    case prefName = "pref_name"
    case shopCount = "shop_count"
  }
}
