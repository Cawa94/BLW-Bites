//
//  FoodMonthsSectionTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import UIKit
import AVKit
import AVFoundation

protocol FoodMonthsSectionDelegate: AnyObject {

    func updatedSegment()

}

class FoodMonthsSectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var monthsSegmentControl: UISegmentedControl!
    @IBOutlet private weak var sectionTextView: UITextView!
    @IBOutlet private weak var sectionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var imagesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playerViewPlaceholder: UIView!
    @IBOutlet private weak var playerIconPlaceholder: UIImageView!
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var playerViewButton: UIButton!
    @IBOutlet private weak var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playerViewTopConstraint: NSLayoutConstraint!

    private weak var delegate: FoodMonthsSectionDelegate?
    private var food: Food?
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    private var videoUrl: URL?

    override func awakeFromNib() {
        super.awakeFromNib()

        imagesCollectionView.register(UINib(nibName:"ImageCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier:"ImageCollectionViewCell")
        imagesCollectionView.roundCornersSimplified()
    }

    func configureWith(food: Food, delegate: FoodMonthsSectionDelegate) {
        self.delegate = delegate
        self.food = food
        monthsSegmentControl.replaceSegmentsWith(food.ageSegments.compactMap { $0.months } )
        monthsSegmentControl.selectedSegmentIndex = 0
        showInfosForSegment(0)
    }

    @IBAction func selectMonth(_ sender: Any) {
        showInfosForSegment(monthsSegmentControl.selectedSegmentIndex)
        delegate?.updatedSegment()
    }

    func showInfosForSegment(_ index: Int) {
        sectionTextView.text = food?.ageSegments[index].description
        sectionTextViewHeightConstraint.constant = sectionTextView.contentSize.height
        let picturesCount = food?.ageSegments[monthsSegmentControl.selectedSegmentIndex].pictures?.count ?? 0
        let numberOfItems = ((picturesCount % 2) == 0) ? picturesCount : picturesCount + 1
        let collectionHeight = CGFloat(165 * (Double((numberOfItems)/2).rounded(.up)))
        imagesCollectionViewHeightConstraint.constant = collectionHeight
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
        }

        if let video = food?.ageSegments[index].video, let videoUrl = URL(string: video) {
            playerViewTopConstraint.constant = 30
            playerViewHeightConstraint.constant = 420
            playerViewPlaceholder.isHidden = false
            playerIconPlaceholder.isHidden = false
            self.videoUrl = videoUrl
            playerViewButton.isHidden = false
        } else {
            playerViewTopConstraint.constant = 0
            playerViewHeightConstraint.constant = 0
            playerViewPlaceholder.isHidden = true
            playerIconPlaceholder.isHidden = true
            self.videoUrl = nil
            playerViewButton.isHidden = true
        }
    }

    @IBAction func playVideo() {
        guard let videoUrl = videoUrl
            else { return }
        player = AVPlayer(url: videoUrl)
        player?.isMuted = true
        player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        playerView.subviews.filter({ $0.tag == 10 }).forEach({ $0.removeFromSuperview() })
        playerViewController = AVPlayerViewController()
        playerViewController?.player = self.player
        playerViewController?.view.frame.size = self.playerView.frame.size
        playerViewController?.view.frame.origin = .zero
        playerViewController?.player?.play()
        playerViewController?.view.tag = 10
        playerView.addSubview(playerViewController?.view ?? UIView())
        playerViewButton.isHidden = true
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if player?.rate ?? 0 > 0 {
                print("video started")
                playerViewPlaceholder.isHidden = true
                playerIconPlaceholder.isHidden = true
            }
        }
    }

}

extension FoodMonthsSectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return food?.ageSegments[monthsSegmentControl.selectedSegmentIndex].pictures?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell",
                                                            for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
        let imageUrl = food?.ageSegments[monthsSegmentControl.selectedSegmentIndex].pictures?[indexPath.row] ?? ""
        cell.configureWith(imageUrl)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 0, bottom: 10, right: 0)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

}
