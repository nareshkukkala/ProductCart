//
//  SideMenuCell.swift
//  ProductCart
//
//  Created by naresh kukkala on 21/08/21.
//
import UIKit

class ProductCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Background
        self.backgroundColor = .clear

        // Title
        self.titleLabel.textColor = .white
        
        self.cityLabel.textColor = .white
        
        self.stateLabel.textColor = .white
        
        self.countryLabel.textColor = .white
    }
}
