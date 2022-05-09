//
//  noLoginCartViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 19/03/2022.
//

import UIKit

class NoLoginCartViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleAlert: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 5
        titleAlert.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    @IBAction func didTapLogin() {
        loginButton.isEnabled = false
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginCartViewController") as! LoginCartViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
//        loginVC.loginSuccessed = { status in
//            NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
//        }
//        loginVC.modalPresentationStyle = .fullScreen
//        self.present(loginVC, animated: true, completion: nil)
    }
    
}
