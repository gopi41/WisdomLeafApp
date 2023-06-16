//
//  WLTableViewCell.swift
//  WisdomLeafApp
//
//  Created by Gopi on 15/06/23.
//

import Foundation
import UIKit
import SDWebImage

class WLTableViewCell : UITableViewCell {
    
    @IBOutlet private weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var profileImageView: WLLazyImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private let select = UIImage(named: "circleSelected")
    private let unSelect = UIImage(named: "circleUnselected")
    
    func setUpCell(data: WLData) {
    
        nameLabel.text = data.id
        descriptionLabel.text = data.author
        cellSelectStatus(isSelected: data.isSelected)
        if let url = URL(string: data.downloadUrl) {
        profileImageView.loadImage(fromURl: url, placeHolderImage: "placeHolderImg")
        }
    }
    
    func cellSelectStatus(isSelected: Bool) {
        if isSelected {
            checkBoxImageView.image = select
        } else {
            checkBoxImageView.image = unSelect
        }
    }
    
}
