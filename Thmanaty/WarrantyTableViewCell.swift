//
//  ThmanTableViewCell.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 25/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import UIKit

class WarrantyTableViewCell: UITableViewCell {

    let dateController: DateController = DateController()
    
    @IBOutlet weak var warrantyImageView: UIImageView!
    @IBOutlet weak var devicNameLabel: UILabel!
    @IBOutlet weak var buyDateLabel: UILabel!
    @IBOutlet weak var warrantyPeriodLabel: UILabel!
    
    
    // MARK: -Dont forget To Handle
    // if ther is no image or somthing went wrong view a model image
    func dataToImage(data: Data)-> UIImage {
        if let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "ThmanPhoto.png")!
        }
    }
    
    func setWarrantyCell(warranty: Warranty) {
        warrantyImageView.image = dataToImage(data: warranty.warrantyImage!)
        devicNameLabel.text = warranty.devicName!
        buyDateLabel.text = dateController.stringFromDate(date: warranty.buyDate!)
        warrantyPeriodLabel.text = String(warranty.remainingPeriod)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
