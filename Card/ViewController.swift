//
//  ViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    // スワイプ中にgood or bad の表示
    @IBOutlet weak var likeImage: UIImageView!
    // ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!

    // ベースカードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var personList: [UIView] = []
    // 選択されたカードの数
    var selectedCardCount: Int = 0
    
    // 「いいね」をされた名前の配列
    var likedName: [String] = []
    
    // ユーザーリスト
    var userList: [[String: String]] = [
        ["imageName": "津田梅子", "name": "津田梅子", "profession": "教師", "hometown": "千葉"],
        ["imageName": "ジョージワシントン", "name": "ジョージワシントン", "profession": "大統領", "hometown": "アメリカ"],
        ["imageName": "ガリレオガリレイ", "name": "ガリレオガリレイ", "profession": "物理学者", "hometown": "イタリア"],
        ["imageName": "板垣退助", "name": "板垣退助", "profession": "議員", "hometown": "高知"],
        ["imageName": "ジョン万次郎", "name": "ジョン万次郎", "profession": "冒険家", "hometown": "アメリカ"]
    ]
    
    var likedUser: [[String: String]] = []

    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }

    // ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }

    // view表示前に呼ばれる（遷移すると戻ってくる度によばれる）
    override func viewWillAppear(_ animated: Bool) {
        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedUser = []
    }

    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as! LikedListTableViewController

            // LikedListTableViewControllerのlikedUser(左)にViewCountrollewのlikedUser(右)を代入
            vc.likedUser = likedUser
        }
    }

    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // ユーザーカードを元に戻す
        resetPersonList()
    }

    func resetPersonList() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for person in personList {
            // 元に戻す処理
            person.center = self.centerOfCard
            person.transform = .identity
        }
    }

    // ベースカードを元に戻す
    func resetCard() {
        // 位置を戻す
        baseCard.center = centerOfCard
        // 角度を戻す
        baseCard.transform = .identity
    }
    
    // 誰もいいねしなかった時の処理
    func pushAction() {
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

    // スワイプ処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {

        // ベースカード
        let card = sender.view!
        // 動いた距離
        let point = sender.translation(in: view)
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードにも同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

        // likeImageの表示のコントロール
        if xfromCenter > 0 {
            // goodを表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }

        // 元の位置に戻す処理
        if sender.state == UIGestureRecognizer.State.ended {

            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 左へ飛ばす場合
                    // X座標を左に500とばす(-500)
                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)

                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // 次のカードへ
                selectedCardCount += 1

                if selectedCardCount >= personList.count {
                    // 画面遷移
                    if likedUser.isEmpty {
                        pushAction()
                    } else {
                        performSegue(withIdentifier: "ToLikedList", sender: self)
                    }
                }

            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 右へ飛ばす場合
                    // X座標を右に500とばす(+500)
                self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)

                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // いいねリストに追加
                likedUser.append(userList[selectedCardCount])
                // 次のカードへ
                selectedCardCount += 1
                
                if selectedCardCount >= personList.count {
                    // 画面遷移
                    if likedUser.isEmpty {
                        pushAction()
                    } else {
                        performSegue(withIdentifier: "ToLikedList", sender: self)
                    }
                }

            } else {
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                    // ベースカードの角度と位置を戻す
                    self.resetCard()
                    // likeImageを隠す
                    self.likeImage.isHidden = true
                })
            }
        }
    }

    // よくないねボタン
    @IBAction func dislikeButtonTapped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            // ベースカードをリセット
            self.resetCard()
            // ユーザーカードを左にとばす
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x - 500, y:self.personList[self.selectedCardCount].center.y)
        })

        selectedCardCount += 1
        // 画面遷移
        if selectedCardCount >= personList.count {
            
            if likedUser.isEmpty {
                pushAction()
            } else {
                performSegue(withIdentifier: "ToLikedList", sender: self)
            }
        }
    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x + 500, y:self.personList[self.selectedCardCount].center.y)
        })
        // いいねリストに追加
        likedUser.append(userList[selectedCardCount])
        selectedCardCount += 1
   
        
        if selectedCardCount >= personList.count {
            
            // 画面遷移
            if likedUser.isEmpty {
                pushAction()
            } else {
                performSegue(withIdentifier: "ToLikedList", sender: self)
            }
        }
    }
}

