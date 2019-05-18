//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Chen Yi-Wei on 2019/5/7.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var playerObserve: NSKeyValueObservation?

    let placeHolderWidth: CGFloat = -170

    lazy var offset = UIOffset(horizontal: (searchBar.frame.width - placeHolderWidth) / 2, vertical: 0)

    let searchBar: UISearchBar = {

        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Enter URL of Video"
        searchBar.barTintColor = .black
        searchBar.isTranslucent = false
        searchBar.barStyle = .black
        searchBar.searchBarStyle = .prominent

        return searchBar
    }()

    lazy var playerView: PlayerView = {

        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let player = AVPlayer.init()

        view.player = player
        view.backgroundColor = UIColor.init(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)

        return view

    }()

    let buttonContainerView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        view.layer.shadowColor = UIColor.init(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 0.2

        return view
    }()

    lazy var playButton: UIButton = {

        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var muteButton: UIButton = {

        let button = UIButton()
        button.setTitle("Mute", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(muteButtonTapped), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self

        view.addSubview(searchBar)
        view.addSubview(buttonContainerView)
        view.addSubview(playerView)
        buttonContainerView.addSubview(playButton)
        buttonContainerView.addSubview(muteButton)

        setUpLayout()

        searchBar.setPositionAdjustment(offset, for: .search)

        self.playerObserve = self.playerView.player?.observe(\.rate, changeHandler: { (player, _) in

            if player.rate == 0.0 {
                print("Paused")
                self.playButton.setTitle("Play", for: .normal)
            } else {
                print("Playing")
                self.playButton.setTitle("Pause", for: .normal)
            }
        })
    }

    func setUpLayout() {

        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true

        buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonContainerView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        playerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor).isActive = true

        playButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20).isActive = true
        playButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 13).isActive = true
        playButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: -12).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 60).isActive = true

        muteButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -20).isActive = true
        muteButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 13).isActive = true
        muteButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: -12).isActive = true
        muteButton.widthAnchor.constraint(equalToConstant: 65).isActive = true

    }

    @objc func playButtonTapped() {

        if self.playerView.player?.rate == 0.0 {

            self.playerView.player?.play()

        } else {

            self.playerView.player?.pause()

        }

    }

    @objc func muteButtonTapped() {

        if self.muteButton.isSelected {
            self.muteButton.setTitle("Mute", for: .normal)
            self.muteButton.isSelected = false
            self.playerView.playerLayer.player?.isMuted = false

        } else {

            self.muteButton.isSelected = true
            self.muteButton.setTitle("Unmute", for: .normal)
            self.playerView.playerLayer.player?.isMuted = true

        }

    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        print("Tapped")
        searchBar.endEditing(true)
        let videoUrl = URL(string: searchBar.text!)
        self.playerView.player?.replaceCurrentItem(with: AVPlayerItem(url: videoUrl!))
        self.playerView.player?.play()

    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        let noOffset = UIOffset(horizontal: 0, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)

        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        searchBar.setPositionAdjustment(offset, for: .search)

        return true
    }
}
