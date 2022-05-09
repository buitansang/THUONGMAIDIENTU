//
//  ImageSlideCollectionViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit

class ImageSlideCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageSlideView: UIImageView!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    //MARK: - Setups
    
    func setupUI() {
        viewOfImage.layer.cornerRadius = 20
        imageSlideView.layer.cornerRadius = 20
    }
}
