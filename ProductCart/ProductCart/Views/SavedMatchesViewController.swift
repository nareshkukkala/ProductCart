//
//  MoviesViewController.swift
//  ProductCart
//
//  Created by naresh kukkala on 21/08/21.
//

import UIKit

class SavedMatchesViewController: UIViewController {
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var productTableView: UITableView!
    
    var venues: [Venues] = []
    
    var db:DBHelper = DBHelper()
    
    var venueData:[VenueData] = []
    
    var click = 0
    
    var defaultHighlightedCell: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
        venueData = db.read()
        
        productTableView.estimatedRowHeight = 155
        
        // TableView
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.productTableView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        
        // Register TableView Cell
        self.productTableView.register(ProductCell.nib, forCellReuseIdentifier: ProductCell.identifier)

        // Update TableView with the data
        self.productTableView.reloadData()
    }
    
    @objc func onTapImage(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        let venues: Venues = self.venueData[sender.view!.tag].venue!
        if venueData.compactMap({ $0.id }).contains(venues.id) {
            db.deleteByID(id: venues.id!)
            venueData = db.read()
            self.productTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension SavedMatchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}

// MARK: - UITableViewDataSource

extension SavedMatchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venueData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { fatalError("xib doesn't exist") }
        
        cell.iconImageView.image = UIImage(named: "starfull")
        cell.titleLabel.text = self.venueData[indexPath.row].id
        cell.cityLabel.text = String(format: "City: %@",self.venueData[indexPath.row].venue?.location?.city as! CVarArg)
        cell.stateLabel.text = String(format: "State: %@", self.venueData[indexPath.row].venue?.location?.state as! CVarArg)
        cell.countryLabel.text = String(format: "Country: %@", self.venueData[indexPath.row].venue?.location?.country as! CVarArg)

        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        
        cell.iconImageView.isUserInteractionEnabled = true
        cell.iconImageView.tag = indexPath.row
        let onTap = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        onTap.numberOfTouchesRequired = 1
        onTap.numberOfTapsRequired = 1
        cell.iconImageView.addGestureRecognizer(onTap)
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
}

