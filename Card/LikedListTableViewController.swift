//
//  LikedListTableViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {

    // いいね」されたUserの一覧
    var likedUser: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // 誰もいいねしなかった時の処理
        if likedUser.isEmpty {
            // UIViewControllerの生成
            let VC = UIViewController()
            
            // ラベルの生成
            let label = UILabel()
            // ラベルの位置決め
            label.frame = CGRect(x: 80, y: 100, width: 200, height: 50)
            // ラベルのテキストを追加
            label.text = "まだいいねしていません"
            // ラベルの貼り付け
            VC.view.addSubview(label)
            // UIViewControllerのバックグランドカラーの設定
            VC.view.backgroundColor = .white
            // VCへ画面遷移
            navigationController?.pushViewController(VC, animated: true)
        }
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
                
        // いいねされた人の情報を表示
        cell.imageView?.image = UIImage(named: likedUser[indexPath.row]["imageName"] ?? "")
        cell.nameLabel?.text = likedUser[indexPath.row]["name"]
        cell.professionLabel?.text = likedUser[indexPath.row]["profession"]
        cell.hometownLabel?.text = likedUser[indexPath.row]["hometown"]
        
        return cell
    }

}
