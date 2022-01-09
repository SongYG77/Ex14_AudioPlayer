//
//  ViewController.swift
//  Ex14_AudioPlayer
//
//  Created by 송윤근 on 2022/01/09.
//


import UIKit
import AVFoundation // 애플의 기본 SDK에서 제공.


class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var ProgressView: UIProgressView!
    @IBOutlet weak var playSliderView: UISlider!
    @IBOutlet weak var curruntLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var volumeSliderView: UISlider!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    
    var audioplayer : AVAudioPlayer!
    var audiofile : URL!
    var time: Timer?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //이건 번들 파일이다 즉 번들에 있는 파일을 실행할 때 사용하는것.
        //selectAudioFile()
        //initPlayer()
        
        //HTTP 서버 상에 있는 오디오 실행 시
        let urlstring = "http://nissisoft21.dothome.co.kr/music.mp3"
        let url = URL(string: urlstring)
        //AVAudioPlayer은 스트리밍을 지원하지 않는다 그래서 다운로드 완료 후 실행한다.
        
        downloadFileFromURL(url : url!)
        
        
        
    }
    
    func downloadFileFromURL( url : URL){
        var downloadtask : URLSessionDownloadTask
        downloadtask = URLSession.shared.downloadTask(with: url,
                                                      completionHandler: { [weak self](URL, responds, error) -> Void in
                                                        self?.audiofile = URL! as URL
                                                        self?.initPlayerForHTTP()
                                                            
                                                        })
        downloadtask.resume()
    }
    
    
    func selectAudioFile() {
       
        audiofile = Bundle.main.url(forResource: "music", withExtension: "mp3")
        
    }
    
    
    
    func initPlayer() {
        
        do {
            audioplayer = try AVAudioPlayer(contentsOf: audiofile)
        } catch let error as NSError {
            print("error init player", error)
        }
        
        audioplayer.delegate = self
        audioplayer.prepareToPlay()//메모리에 음원을 넣어줌, 버퍼링
        audioplayer.volume = 1.0
        
        curruntLabel.text = "00:00"
        let min = Int(audioplayer.duration / 60)
        let sec = Int(audioplayer.duration) % 60
        endLabel.text = "\(min):\(sec)" // 총 재생시간
        
        //ui초기화
        volumeSliderView.maximumValue = 1.0
        volumeSliderView.value = 1.0
        ProgressView.progress = 0.0
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
        btnStop.isEnabled = false
        //버튼 활성화 비활성화
        
        playSliderView.maximumValue = Float(audioplayer.duration)
        
        playSliderView.value = 0
        
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callbackTimer), userInfo: nil, repeats: true)
        //timeinterval : 몇초마다 인지
        //target : 처리자가 누구인지
        //selector : 타이머에 실행될 함수
        //userinfo : ?
        //repeats : 반복
        
    }
    func initPlayerForHTTP() {
        
        do {
            audioplayer = try AVAudioPlayer(contentsOf: audiofile)
        } catch let error as NSError {
            print("error init player", error)
        }
        
        audioplayer.delegate = self
        audioplayer.prepareToPlay()//메모리에 음원을 넣어줌, 버퍼링
        audioplayer.volume = 1.0
        
        //쓰레드로 접근할 시
        DispatchQueue.main.sync {
            curruntLabel.text = "00:00"
            let min = Int(audioplayer.duration / 60)
            let sec = Int(audioplayer.duration) % 60
            endLabel.text = "\(min):\(sec)" // 총 재생시간
            
            //ui초기화
            volumeSliderView.maximumValue = 1.0
            volumeSliderView.value = 1.0
            ProgressView.progress = 0.0
            btnPlay.isEnabled = true
            btnPause.isEnabled = false
            btnStop.isEnabled = false
            //버튼 활성화 비활성화
            
            playSliderView.maximumValue = Float(audioplayer.duration)
            
            playSliderView.value = 0
            
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callbackTimer), userInfo: nil, repeats: true)
            //timeinterval : 몇초마다 인지
            //target : 처리자가 누구인지
            //selector : 타이머에 실행될 함수
            //userinfo : ?
            //repeats : 반복
        }
        
        
    }

    
    //타이머 콜백 함수
    // @objc는 object-c 코드
    @objc func callbackTimer() {
        let min = Int(audioplayer.currentTime / 60)
        let sec = Int(audioplayer.currentTime) % 60
        curruntLabel.text = "\(min):\(sec)"
        
        ProgressView.progress = Float(audioplayer.currentTime / audioplayer.duration)
    }
    
    @IBAction func onbtnPlay(_ sender: UIButton) {
        
        audioplayer.play()
        btnPlay.isEnabled = false
        btnPause.isEnabled = true
        btnStop.isEnabled = true
        
    }
    
    @IBAction func onbtnPause(_ sender: UIButton) {
        
        audioplayer.pause()
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
        btnStop.isEnabled = true
    }
    
    @IBAction func onbtnStop(_ sender: UIButton) {
        
        audioplayer.stop()
        
        audioplayer = nil
        
        //initPlayer()
        let urlstring = "http://nissisoft21.dothome.co.kr/music.mp3"
        let url = URL(string: urlstring)
        downloadFileFromURL(url: url! )
        
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
        btnStop.isEnabled = false
    }
    
    
    @IBAction func onSliderVolume(_ sender: UISlider) {
        
        audioplayer.volume = volumeSliderView.value
        
    }
    
    @IBAction func onSliderPlay(_ sender: UISlider) {
        
        audioplayer.pause()
        audioplayer.currentTime = Double(sender.value)
        audioplayer.play()
        
        ProgressView.progress = Float(audioplayer.currentTime / audioplayer.duration)
    }
    //touch up inside로 지정해 터치를 떼면 싫행되도록
    
    
}

