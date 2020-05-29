//
//  ViewController.swift
//  TimerApp
//
//  Created by NakagawaMegumi on 2020/05/03.
//  Copyright © 2020 中川恵. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    
    
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBOutlet weak var kaishi: UIButton!
    @IBOutlet weak var owari: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var hyouji: UILabel!
    
    
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    var myTimer = Timer()
    var countDown = 0//残り秒数を保持する変数
    var currentCountDown = 0
    var countUp = 0
    var player = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
        do {
            // 再生する audio ファイルのパスを取得
            let filePath = Bundle.main.path(forResource: "Clock", ofType: "mp3")
            let musicPath = URL(fileURLWithPath: filePath!)
            // auido を再生するプレイヤーを作成する
            player = try AVAudioPlayer(contentsOf: musicPath)
            
        } catch {
            print("エラー")
        }
        
    }
    
    @IBAction func start(_ sender: Any) {
        if countUp == 0 {
            countDown = hours[myPickerView.selectedRow(inComponent: 0)] * 60 * 60
                + minutes[myPickerView.selectedRow(inComponent: 1)] * 60
                + seconds[myPickerView.selectedRow(inComponent: 2)]
            hyouji.text = "残り時間は,"+"\(countDown)"+"秒です。"
        }
        
        
        //1秒周期でcountDownメソッドを呼び出すタイマーを開始する。
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.count), userInfo: nil, repeats: true)
        
    }
    
    @objc func count () {
        countUp += 1
        currentCountDown = countDown - countUp
        
        
        if currentCountDown > 0 {
            hyouji.text = "残り時間は,"+"\(currentCountDown)"+"秒です。"
        } else {
            hyouji.text = "終了"
            player.play()
        }
        
    }
    
    
    
    @IBAction func teishi(_ sender: Any) {
        myTimer.invalidate()
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        myTimer.invalidate()
        hyouji.text = ""
        currentCountDown = 0
        countUp = 0
        player.stop()
    }
    
}

//pickerviewのデータセット
extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    //おまじない①コンポーネントの個数を返す(列数)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    //おまじない②コンポーネントに含まれるデータの個数を返す（行数）
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return seconds.count
        default:
            return 0
        }
    }
    
    //表示する値
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return String(hours[row]) + "時"
        case 1:
            return String(minutes[row]) + "分"
        case 2:
            return String(seconds[row]) + "秒"
        default:
            return ""
        }
    }
}



//UIカスタム
extension ViewController {
    func setUpElement() {
        kaishi.layer.cornerRadius = kaishi.frame.size.height / 2
        kaishi.backgroundColor = .black
        owari.layer.cornerRadius = kaishi.frame.size.height / 2
        owari.backgroundColor = .black
        stop.layer.cornerRadius = kaishi.frame.size.height / 2
        stop.backgroundColor = .black
        myPickerView.delegate = self
        myPickerView.dataSource = self
        player.delegate = self
        
    }
}
