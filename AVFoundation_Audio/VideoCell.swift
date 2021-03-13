//
//  VideoCell.swift
//  AVFoundation_Audio
//
//  Created by v.milchakova on 13.03.2021.
//

import UIKit
import WebKit
import AVFoundation

class VideoCell: UITableViewCell {
    
    let baseOffset: CGFloat =  16
    
    public lazy var videoWKVebview: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), configuration: config)
        view.configuration.mediaTypesRequiringUserActionForPlayback = .video
        view.configuration.mediaTypesRequiringUserActionForPlayback = .audio
        view.toAutoLayout()
        view.backgroundColor = .black
        return view
    }()
    
    public func configure(url: URL){
        videoWKVebview.load(URLRequest(url: url))
    }

    private lazy var content: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.toAutoLayout()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func setupLayout() {
        contentView.addSubview(content)
        content.addSubview(videoWKVebview)
        
        let constraint =  [
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
            content.heightAnchor.constraint(equalToConstant: 200),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            videoWKVebview.topAnchor.constraint(equalTo: content.topAnchor),
            videoWKVebview.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            videoWKVebview.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            videoWKVebview.bottomAnchor.constraint(equalTo: content.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraint)
    }
}
