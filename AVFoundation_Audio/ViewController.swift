//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var backwordButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var videoTable: UITableView!
    
    var Player = AVAudioPlayer()
    var baseOffset: CGFloat = 40
    var nowPlayingIndex: Int = 0

    lazy var soundsList = [
        "Abba - Money, Money, Money",
        "Queen - Don't Stop Me Now",
        "ACDC - Play Ball",
        "Britney Spears - Baby One More Time",
        "Michael Jackson-Thriller"
    ]
    
    lazy var youTubeUrls = [
        "https://youtu.be/VeFmB7-Zuzs",
        "https://youtu.be/d055dteIwXU",
        "https://youtu.be/-2zv1sBmNaw",
        "https://youtu.be/X7bvwHI1goI",
        "https://youtu.be/tTkeIvF1Vec"
    ]

    private var reuseId: String {
        String(describing: VideoCell.self)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        videoTable.dataSource = self
        videoTable.isScrollEnabled = true
        videoTable.register(VideoCell.self, forCellReuseIdentifier: reuseId)
        videoTable.separatorStyle = .singleLine
        
        prepareToPlay(trackIndex: nowPlayingIndex)

        playButton.toAutoLayout()
        stopButton.toAutoLayout()
        pauseButton.toAutoLayout()
        videoTable.toAutoLayout()
        trackLabel.toAutoLayout()
        forwardButton.toAutoLayout()
        backwordButton.toAutoLayout()
        setupLayout()
        
        trackName.text = soundsList[nowPlayingIndex]
    }
    
    func prepareToPlay(trackIndex: Int) {
        do {
            Player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundsList[trackIndex], ofType: "mp3")!))
            Player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            videoTable.topAnchor.constraint(equalTo: view.topAnchor, constant: baseOffset),
            videoTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            videoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            trackLabel.topAnchor.constraint(equalTo: videoTable.bottomAnchor, constant: baseOffset),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackLabel.widthAnchor.constraint(equalToConstant: 250),
            
            backwordButton.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: baseOffset),
            backwordButton.leadingAnchor.constraint(equalTo: trackLabel.leadingAnchor),
            backwordButton.widthAnchor.constraint(equalToConstant: 20),

            playButton.topAnchor.constraint(equalTo: backwordButton.topAnchor),
            playButton.leadingAnchor.constraint(equalTo: backwordButton.trailingAnchor, constant: baseOffset),
            playButton.bottomAnchor.constraint(equalTo: backwordButton.bottomAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 20),
            
            pauseButton.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),
            pauseButton.topAnchor.constraint(equalTo: backwordButton.topAnchor),
            pauseButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: baseOffset),
            pauseButton.widthAnchor.constraint(equalToConstant: 20),
            
            stopButton.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),
            stopButton.topAnchor.constraint(equalTo: backwordButton.topAnchor),
            stopButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor, constant: baseOffset),
            stopButton.widthAnchor.constraint(equalToConstant: 20),

            forwardButton.topAnchor.constraint(equalTo: backwordButton.topAnchor),
            forwardButton.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),
            forwardButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor, constant: baseOffset),
            forwardButton.widthAnchor.constraint(equalToConstant: 20),
            
        ])
    }

    @IBOutlet weak var trackName: UILabel!
    
    @IBAction func PauseButton(_ sender: Any) {
        if Player.isPlaying {
            Player.stop()
        }
        else {
            print("Already paused!")
        }
    }
    
    @IBAction func PlayButton(_ sender: Any) {
        Player.play()
    }
    
    @IBAction func StopButton(_ sender: Any) {
        if Player.isPlaying {
            Player.stop()
            Player.currentTime = 0
        }
        else {
            print("Already stopped!")
        }
    }
    @IBAction func forwordTrack(_ sender: Any) {
        print("Перематываем трек вперед \(nowPlayingIndex)")
        if nowPlayingIndex == soundsList.count - 1 {
            nowPlayingIndex = 0
        } else {
            nowPlayingIndex += 1
        }
        print("Перемотали трек вперед \(nowPlayingIndex)")
        prepareToPlay(trackIndex: nowPlayingIndex)
        trackLabel.text = soundsList[nowPlayingIndex]
        Player.play()
    }
    
    @IBAction func backwordTrack(_ sender: Any) {
        print("Перематываем трек назад \(nowPlayingIndex)")
        if nowPlayingIndex == 0 {
            nowPlayingIndex = soundsList.count - 1
        } else {
            nowPlayingIndex -= 1
        }
        print("Перемотали трек назад \(nowPlayingIndex)")
        prepareToPlay(trackIndex: nowPlayingIndex)
        trackLabel.text = soundsList[nowPlayingIndex]
        Player.play()
    }
}

@available(iOS 13.0, *)
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youTubeUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! VideoCell
        
        let url = youTubeUrls[indexPath.row]
        cell.configure(url: URL(string: url)!)
        return cell
    }
}

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
