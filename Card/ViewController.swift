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
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstProfessionLabel: UILabel!
    @IBOutlet weak var firstHomeTownLabel: UILabel!
    
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var secondProfessionLabel: UILabel!
    @IBOutlet weak var secondHomeTownLabel: UILabel!
    
    // ベースカードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var cardList: [UIView] = []
    // 選択されたカードの数
    var selectedCardCount: Int = 0
    
    var currentNum: Int = 0
    
    // ユーザーリスト
    let nameList: [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    // 「いいね」をされた名前の配列
    var likedName: [String] = []

    let userList: [[String: Any]] = [
        ["name": "津田梅子", "profession": "教師", "hometown": "千葉", "backgroundColor": #colorLiteral(red: 0.2084727883, green: 1, blue: 0.8079068065, alpha: 1)],
        ["name": "ジョージワシントン", "profession": "大統領", "hometown": "アメリカ", "backgroundColor": #colorLiteral(red: 0.2084727883, green: 1, blue: 0.8079068065, alpha: 1)],
        ["name": "ガリレオガリレイ", "profession": "物理学者", "hometown": "イタリア", "backgroundColor": #colorLiteral(red: 0.2084727883, green: 1, blue: 0.8079068065, alpha: 1)],
        ["name": "板垣退助", "profession": "議員", "hometown": "高知", "backgroundColor": #colorLiteral(red: 0.2084727883, green: 1, blue: 0.8079068065, alpha: 1)],
        ["name": "ジョン万次郎", "profession": "冒険家", "hometown": "アメリカ", "backgroundColor": #colorLiteral(red: 0.2084727883, green: 1, blue: 0.8079068065, alpha: 1)]
    ]

    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }

    // ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        // personListに追加
        cardList.append(firstView)
        cardList.append(secondView)
    }

    // view表示前に呼ばれる（遷移すると戻ってくる度によばれる）
    override func viewWillAppear(_ animated: Bool) {
        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedName = []
    }

    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as! LikedListTableViewController

            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }

    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // ユーザーカードを元に戻す
        resetPersonList()
    }

    func resetPersonList() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for person in cardList {
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
    
    func setupNextView() {
        // 背面に持っていく
        self.view.sendSubviewToBack(cardList[selectedCardCount])
        
        // 中央に戻す
        cardList[selectedCardCount].center = centerOfCard
        cardList[selectedCardCount].transform = .identity
        
        setupCardData()
        
        // 次のカードへ
        selectedCardCount += 1
        
        currentNum += 1

        
        selectedCardCount = currentNum % 2
    }
    
    func setupCardData() {
        
        if currentNum > userList.count - 3 {
            // 遷移処理
            performSegue(withIdentifier: "ToLikedList", sender: self)
        } else {
            let userData: [String: Any] = userList[currentNum + 2]
            
            if selectedCardCount == 0 {
                firstImageView.image      = UIImage(named: userData["name"] as! String)
                firstNameLabel.text       = userData["name"] as? String
                firstProfessionLabel.text = userData["profession"] as? String
                firstHomeTownLabel.text   = userData["hometown"] as? String
                firstView.backgroundColor = userData["backgroundColor"] as? UIColor
                
            } else {
                secondImageView.image      = UIImage(named: userData["name"] as! String)
                secondNameLabel.text       = userData["name"] as? String
                secondProfessionLabel.text = userData["profession"] as? String
                secondHomeTownLabel.text   = userData["hometown"] as? String
            }
        }
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
        cardList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        cardList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

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
                    self.cardList[self.selectedCardCount].center = CGPoint(x: self.cardList[self.selectedCardCount].center.x - 500, y :self.cardList[self.selectedCardCount].center.y)

                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                
                // ユーザーカードを元に戻す
                setupNextView()

                if currentNum >= userList.count {
                    // 遷移処理
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }

            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 右へ飛ばす場合
                    // X座標を右に500とばす(+500)
                self.cardList[self.selectedCardCount].center = CGPoint(x: self.cardList[self.selectedCardCount].center.x + 500, y :self.cardList[self.selectedCardCount].center.y)

                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // ユーザーカードを元に戻す
                setupNextView()
                // いいねリストに追加
                likedName.append(nameList[selectedCardCount])
                
                if currentNum >= userList.count {
                    // 遷移処理
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }

            } else {
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.cardList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.cardList[self.selectedCardCount].transform = .identity
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
            self.cardList[self.selectedCardCount].center = CGPoint(x:self.cardList[self.selectedCardCount].center.x - 500, y:self.cardList[self.selectedCardCount].center.y)
        })
        
        // ユーザーカードを元に戻す
        setupNextView()

        // 画面遷移
        if currentNum >= userList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.cardList[self.selectedCardCount].center = CGPoint(x:self.cardList[self.selectedCardCount].center.x + 500, y:self.cardList[self.selectedCardCount].center.y)
        })
        // いいねリストに追加
        likedName.append(nameList[selectedCardCount])
        
        // ユーザーカードを元に戻す
        setupNextView()
        
        
        
        // 画面遷移
        if currentNum >= userList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
}

