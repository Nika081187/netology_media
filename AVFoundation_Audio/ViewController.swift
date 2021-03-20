//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation
import WebKit

struct Video {
    var name: String
    var path: String
}

class ViewController: UIViewController {
    
    private let videoTable = UITableView()
    
    private lazy var trackLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed), for:.touchUpInside)
        button.toAutoLayout()
        return button
    }()

    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.addTarget(self, action: #selector(stopButtonPressed), for:.touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.addTarget(self, action: #selector(pauseButtonPressed), for:.touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    private lazy var backwordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.addTarget(self, action: #selector(backwordButtonPressed), for:.touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.addTarget(self, action: #selector(forwardButtonPressed), for:.touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    var player = AVAudioPlayer()
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
        Video(name: "Как Высокая Дама продала RE Village — дизайн Димитреску и почему игры-хорроры не пугают", path: "https://youtu.be/VeFmB7-Zuzs"),
        Video(name: "The Witcher 3: Wild Hunt Прохождение ► ТРАВНИЦА", path: "https://youtu.be/d055dteIwXU"),
        Video(name: "Игры от Blizzard, Монхан и Черепашки Ниндзя для Switch – всё это в новостях NintenДа!", path: "https://youtu.be/-2zv1sBmNaw"),
        Video(name: "Самое быстрое прохождение Dead Space [Спидран в деталях]", path: "https://youtu.be/X7bvwHI1goI"),
        Video(name: "Phasmophobia ► КООП-СТРИМ", path: "https://youtu.be/tTkeIvF1Vec")
    ]

    private var reuseId: String {
        String(describing: VideoCell.self)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        videoTable.dataSource = self
        videoTable.delegate = self
        videoTable.isScrollEnabled = true
        videoTable.register(VideoCell.self, forCellReuseIdentifier: reuseId)
        videoTable.tableFooterView = UIView()
        
        prepareToPlay(trackIndex: nowPlayingIndex)

        videoTable.toAutoLayout()
        view.addSubview(videoTable)
        view.addSubview(trackLabel)
        view.addSubview(playButton)
        view.addSubview(stopButton)
        view.addSubview(pauseButton)
        view.addSubview(forwardButton)
        view.addSubview(backwordButton)
        
        setupLayout()
        
        trackLabel.text = soundsList[nowPlayingIndex]
    }
    
    func prepareToPlay(trackIndex: Int) {
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundsList[trackIndex], ofType: "mp3")!))
            player.prepareToPlay()
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
    
    @objc func pauseButtonPressed() {
        if player.isPlaying {
            player.stop()
        }
        else {
            print("Already paused!")
        }
    }
    
    @objc func playButtonPressed() {
        player.play()
    }
    
    @objc func stopButtonPressed() {
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        else {
            print("Already stopped!")
        }
    }
    @objc func forwardButtonPressed() {
        print("Перематываем трек вперед \(nowPlayingIndex)")
        if nowPlayingIndex == soundsList.count - 1 {
            nowPlayingIndex = 0
        } else {
            nowPlayingIndex += 1
        }
        print("Перемотали трек вперед \(nowPlayingIndex)")
        prepareToPlay(trackIndex: nowPlayingIndex)
        trackLabel.text = soundsList[nowPlayingIndex]
        player.play()
    }
    
    @objc func backwordButtonPressed() {
        print("Перематываем трек назад \(nowPlayingIndex)")
        if nowPlayingIndex == 0 {
            nowPlayingIndex = soundsList.count - 1
        } else {
            nowPlayingIndex -= 1
        }
        print("Перемотали трек назад \(nowPlayingIndex)")
        prepareToPlay(trackIndex: nowPlayingIndex)
        trackLabel.text = soundsList[nowPlayingIndex]
        player.play()
    }
    
    public lazy var videoWKVebview: WKWebView = {
        let preferences = WKPreferences()
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences = preferences
        let webview = WKWebView(frame: view.bounds, configuration: configuration)
        webview.scrollView.bounces = true
        return webview
    }()
    
    private lazy var closeVideoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(closeVideo), for:.touchUpInside)
        button.tintColor = .red
        button.toAutoLayout()
        return button
    }()
    
    @objc func closeVideo() {
        closeVideoButton.isHidden = true
        videoWKVebview.removeFromSuperview()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youTubeUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! VideoCell

        cell.configure(video: youTubeUrls[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: youTubeUrls[indexPath.row].path)
        let request = URLRequest(url: url!)
        
        view.addSubview(videoWKVebview)
        view.addSubview(closeVideoButton)
        
        closeVideoButton.isHidden = false
        videoWKVebview.load(request)
        
        NSLayoutConstraint.activate([
            closeVideoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeVideoButton.heightAnchor.constraint(equalToConstant: 40),
            closeVideoButton.widthAnchor.constraint(equalToConstant: 40),
            closeVideoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
