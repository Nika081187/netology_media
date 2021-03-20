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
    
    private var videoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.toAutoLayout()
        return label
    }()
    
    private var videoIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "video.fill")
        image.tintColor = .systemBlue
        image.toAutoLayout()
        return image
    }()
    
    public func configure(video: Video){
        videoLabel.text = video.name
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(videoIcon)
        contentView.addSubview(videoLabel)
        
        let constraint =  [
            videoIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            videoIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            videoIcon.heightAnchor.constraint(equalToConstant: 20),
            videoIcon.widthAnchor.constraint(equalToConstant: 20),
            
            videoLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoLabel.leadingAnchor.constraint(equalTo: videoIcon.trailingAnchor, constant: baseOffset),
            videoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
            videoLabel.heightAnchor.constraint(equalToConstant: 20),
            videoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraint)
    }
}
