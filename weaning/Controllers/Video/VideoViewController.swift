//
//  VideoViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/4/23.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {

    @IBOutlet private weak var playerView: UIView!

    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?

    var viewModel: VideoViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let videoUrl = viewModel?.videoUrl
            else { return }
        player = AVPlayer(url: videoUrl)
        player?.isMuted = true
        playerView.subviews.filter({ $0.tag == 10 }).forEach({ $0.removeFromSuperview() })
        playerViewController = AVPlayerViewController()
        playerViewController?.player = self.player
        playerViewController?.view.frame.size = self.playerView.frame.size
        playerViewController?.view.frame.origin = .zero
        playerViewController?.player?.play()
        playerViewController?.view.tag = 10
        playerView.addSubview(playerViewController?.view ?? UIView())
        player?.play()
    }

}
