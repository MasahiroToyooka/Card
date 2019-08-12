//
//  LikedListTableViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {

    // いいね」された名前の一覧
//    var likedName: [String] = []
    
    var likedUser: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    // 必須:セルの数を返すメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // いいねされたユーザーの数
        return likedUser.count
    }

    // 必須:セルの設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        print(likedUser.count)
        
        // いいねされた人の情報を表示
        cell.nameLabel?.text = likedUser[indexPath.row]["name"]
        cell.professionLabel?.text = likedUser[indexPath.row]["profession"]
        cell.hometownLabel?.text = likedUser[indexPath.row]["hometown"]
        
        return cell
    }

}
