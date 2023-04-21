//
//  NavigationService+VideoViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/4/23.
//

import Foundation

extension NavigationService {

    static func videoViewController(videoUrl: URL) -> VideoViewController {
        let controller = VideoViewController(nibName: VideoViewController.xibName,
                                             bundle: nil)
        controller.viewModel = VideoViewModel(videoUrl: videoUrl)
        return controller
    }

}
