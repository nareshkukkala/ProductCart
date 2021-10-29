//
//  MusicViewController.swift
//  ProductCart
//
//  Created by naresh kukkala on 21/08/21.
//

import UIKit
import SQLite3

class AllMatchesViewController: UIViewController {
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var productTableView: UITableView!
    
    var venues: [Venues] = []
    
    var db:DBHelper = DBHelper()
    
    var venueData:[VenueData] = []
    
    var defaultHighlightedCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
    }
    
    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader : UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onTapImage(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        let venues: Venues = self.venues[sender.view!.tag]
        if venueData.compactMap({ $0.id }).contains(venues.id) {
            db.deleteByID(id: venues.id!)
            venueData = db.read()
            self.productTableView.reloadData()
        } else {
            do {
                let encoder = JSONEncoder()
                if let jsonData = try? encoder.encode(venues) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                        let data = try NSKeyedArchiver.archivedData(withRootObject: jsonString, requiringSecureCoding: true)
                        db.insert(id: venues.id!, venue: data as NSData)
                        venueData = db.read()
                        self.productTableView.reloadData()
                    }
                }
            } catch {
                print("Couldn't write file")
            }
        }
    }
    
    func apiCall() {
        
        let loader =   self.loader()
        let urlString = "https://api.foursquare.com/v2/venues/search?ll=40.7484,-73.9857&oauth_token=NPKYZ3WZ1VYMNAZ2FLX1WLECAWSMUVOQZOIDBN53F3LVZBPQ&v=20180616"
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            DispatchQueue.main.async {
                loader.dismiss(animated: true, completion: nil)
            }
            if error != nil {
                print(error?.localizedDescription)
            } else {
                do {
                    let results = try JSONDecoder().decode(Json4Swift_Base.self, from: data!)
                    self.venues = (results.response?.venues)!
                    DispatchQueue.main.async {
                        self.productTableView.reloadData()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
}

// MARK: - UITableViewDelegate

extension AllMatchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension AllMatchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { fatalError("xib doesn't exist") }
        
        if venueData.compactMap({ $0.id }).contains(self.venues[indexPath.row].id) {
            cell.iconImageView.image = UIImage(named: "starfull")
        } else {
            cell.iconImageView.image = UIImage(named: "star")
        }
        
        cell.titleLabel.text = self.venues[indexPath.row].id
        cell.cityLabel.text = String(format: "City: %@", self.venues[indexPath.row].location?.city as! CVarArg)
        cell.stateLabel.text = String(format: "State: %@", self.venues[indexPath.row].location?.state as! CVarArg)
        cell.countryLabel.text = String(format: "Country: %@", self.venues[indexPath.row].location?.country as! CVarArg)
        
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

