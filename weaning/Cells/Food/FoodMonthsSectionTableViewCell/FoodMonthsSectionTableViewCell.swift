//
//  FoodMonthsSectionTableViewCell.swift
//  weaning
//
//  Created by Yuri Cavallin on 25/2/23.
//

import UIKit
import HCVimeoVideoExtractor

protocol FoodMonthsSectionDelegate: AnyObject {

    func updatedSegment()

}

class FoodMonthsSectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var monthsSegmentControl: UISegmentedControl!
    @IBOutlet private weak var sectionTextView: UITextView!
    @IBOutlet private weak var sectionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var imagesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playerViewButton: UIButton!
    @IBOutlet private weak var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playerViewTopConstraint: NSLayoutConstraint!

    private weak var delegate: FoodMonthsSectionDelegate?
    private var food: Food?
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
        sectionTextView.attributedText = food?.ageSegments[index].description?.htmlToAttributedString(size: 18)
        sectionTextViewHeightConstraint.constant = sectionTextView.contentSize.height
        let picturesCount = food?.ageSegments[monthsSegmentControl.selectedSegmentIndex].pictures?.count ?? 0
        let numberOfItems = ((picturesCount % 2) == 0) ? picturesCount : picturesCount + 1
        let collectionHeight = CGFloat(165 * (Double((numberOfItems)/2).rounded(.up)))
        imagesCollectionViewHeightConstraint.constant = collectionHeight
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
        }

        if let video = food?.video, let videoUrl = URL(string: video) {
            playerViewButton.isHidden = false
            playerViewTopConstraint.constant = 50
            playerViewHeightConstraint.constant = 50
            self.videoUrl = videoUrl
        } else {
            playerViewButton.isHidden = true
            playerViewTopConstraint.constant = 0
            playerViewHeightConstraint.constant = 0
        }
    }

    @IBAction func playVideo(_ sender: Any) {
        guard let videoUrl = videoUrl
            else { return }
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: videoUrl, completion: { ( video:HCVimeoVideo?, error:Error?) -> Void in
            if let err = error {
               print("Error = \(err.localizedDescription)")
               return
            }

            guard let vid = video else {
                print("Invalid video object")
                return
            }

            DispatchQueue.main.async {
                if let vimeoQualityUrl = vid.videoURL[.quality1080p] {
                    NavigationService.present(viewController: NavigationService.videoViewController(videoUrl: vimeoQualityUrl))
                }
            }
        })
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
        return CGSize(width: 145, height: 145)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 5, bottom: 10, right: 5)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

}
