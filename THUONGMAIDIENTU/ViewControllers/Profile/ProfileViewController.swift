//
//  ProfileViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var profile: UIView!
    
    //MARK: - Properties
    

    enum Segues {
        static let profileChild = "ChildProfile"
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        segmentedControl.selectedSegmentIndex = 2
        
    }
    //MARK: - Setups
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.profileChild {
            let infoVC = segue.destination as! InfoViewController
        }
    }

    //MARK: - Actions
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            ordersView.isHidden = false
            discountView.isHidden = true
            profile.isHidden = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            ordersView.isHidden = true
            discountView.isHidden = false
            profile.isHidden = true
        } else {
            ordersView.isHidden = true
            discountView.isHidden = true
            profile.isHidden = false
        }
    }
}

