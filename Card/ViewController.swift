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
    
    // 一枚目のユーザーカード
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstJobLabel: UILabel!
    @IBOutlet weak var firstHomeTownLabel: UILabel!
    
    // 2枚目のユーザーカード
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var secondJobLabel: UILabel!
    @IBOutlet weak var secondHomeTownLabel: UILabel!
    
    // ベースカードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var cardList: [UIView] = []
    
    /// firstviewかsecondViewかを表す数字
    var selectedCardNum: Int = 0
    
    /// 何番目のカードかを表す数字
    var currentNum: Int = 0
    
    // 「いいね」をされた名前の配列
    var likedName: [String] = []

    // ユーザーリスト
    let userList: [[String: Any]] = [
        ["name": "津田梅子", "job": "教師", "hometown": "千葉", "backgroundColor": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)],
        ["name": "ジョージワシントン", "job": "大統領", "hometown": "アメリカ", "backgroundColor": #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)],
        ["name": "ガリレオガリレイ", "job": "物理学者", "hometown": "イタリア", "backgroundColor": #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)],
        ["name": "板垣退助", "job": "議員", "hometown": "高知", "backgroundColor": #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)],
        ["name": "ジョン万次郎", "job": "冒険家", "hometown": "アメリカ", "backgroundColor": #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
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
        // カウント初期化
        selectedCardNum = 0
        currentNum = 0
        // リスト初期化
        likedName = []
        
        setupCardData(indicateNum: currentNum, reset: true)
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
        self.view.sendSubviewToBack(cardList[selectedCardNum])
    
        // 中央に戻す
        cardList[selectedCardNum].center = centerOfCard
        cardList[selectedCardNum].transform = .identity
        
        if currentNum + 2 < userList.count {
            
            setupCardData(indicateNum: currentNum + 2, reset: false)
        } else {
            // secondViewの４番目の板垣
            // 背面のビューを見えなくする
            secondView.alpha = 0
        }
        
        // 更新する処理
        selectedCardNum += 1
        currentNum += 1
        
        if currentNum >= userList.count {
            // 遷移処理
            return performSegue(withIdentifier: "ToLikedList", sender: self)
        }
        selectedCardNum = currentNum % 2
    }
    
    func setupCardData(indicateNum: Int, reset: Bool) {
        
        
        let userData: [String: Any] = userList[indicateNum]
        
        if reset {
            secondView.alpha = 1
            
            firstImageView.image      = UIImage(named: userList[indicateNum]["name"] as! String)
            firstNameLabel.text       = userList[indicateNum]["name"] as? String
            firstJobLabel.text        = userList[indicateNum]["job"] as? String
            firstHomeTownLabel.text   = userList[indicateNum]["hometown"] as? String
            firstView.backgroundColor = userList[indicateNum]["backgroundColor"] as? UIColor
            
            secondImageView.image     = UIImage(named: userList[indicateNum + 1]["name"] as!                                String)
            secondNameLabel.text      = userList[indicateNum + 1]["name"] as? String
            secondJobLabel.text       = userList[indicateNum + 1]["job"] as? String
            secondHomeTownLabel.text  = userList[indicateNum + 1]["hometown"] as? String
        } else {
            
            if selectedCardNum == 0 {
                firstImageView.image      = UIImage(named: userData["name"] as! String)
                firstNameLabel.text       = userData["name"] as? String
                firstJobLabel.text        = userData["job"] as? String
                firstHomeTownLabel.text   = userData["hometown"] as? String
                firstView.backgroundColor = userData["backgroundColor"] as? UIColor
                
            } else {
                secondImageView.image    = UIImage(named: userData["name"] as! String)
                secondNameLabel.text     = userData["name"] as? String
                secondJobLabel.text      = userData["job"] as? String
                secondHomeTownLabel.text = userData["hometown"] as? String
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
        cardList[selectedCardNum].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        cardList[selectedCardNum].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

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
                    self.cardList[self.selectedCardNum].center = CGPoint(x: self.cardList[self.selectedCardNum].center.x - 500, y :self.cardList[self.selectedCardNum].center.y)
                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                
                // ユーザーカードを元に戻す
                setupNextView()

            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 右へ飛ばす場合
                    // X座標を右に500とばす(+500)
                self.cardList[self.selectedCardNum].center = CGPoint(x: self.cardList[self.selectedCardNum].center.x + 500, y :self.cardList[self.selectedCardNum].center.y)
                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                
                // いいねリストに追加
                likedName.append(userList[currentNum]["name"] as! String)
                
                // ユーザーカードを表示させる
                setupNextView()
              
            } else {
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.cardList[self.selectedCardNum].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.cardList[self.selectedCardNum].transform = .identity
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
            self.cardList[self.selectedCardNum].center = CGPoint(x:self.cardList[self.selectedCardNum].center.x - 500, y:self.cardList[self.selectedCardNum].center.y)
        })
        
        // ユーザーカードを元に戻す
        setupNextView()
    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.cardList[self.selectedCardNum].center = CGPoint(x:self.cardList[self.selectedCardNum].center.x + 500, y:self.cardList[self.selectedCardNum].center.y)
        })
        // いいねリストに追加
        likedName.append(userList[currentNum]["name"] as! String)
        
        // ユーザーカードを元に戻す
        setupNextView()
    }
}

