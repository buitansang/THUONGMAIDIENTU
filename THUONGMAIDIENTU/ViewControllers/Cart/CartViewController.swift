//
//  CartViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit

class CartViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var noLogin: UIView!
    @IBOutlet weak var doneLogin: UIView!
    
    //MARK: - Properties
    
    enum Segues {
        static let noLogin = "noLoginChild"
        static let doneLogin = "doneLoginChild"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("reloadData"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadData"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItems = []
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.noLogin {
            let noLoginVC = segue.destination as! NoLoginCartViewController
        }
        
        if segue.identifier == Segues.doneLogin {
            let doneLoginVC =  segue.destination as! DoneLoginCartViewController
        }
    }
    
    private func setupView() {
        if UserService.shared.getToken() == "" {
            noLogin.isHidden = false
            doneLogin.isHidden = true
        } else {
            noLogin.isHidden = true
            doneLogin.isHidden = false
        }
    }
    
    @objc func notificationReceived() {
        if UserService.shared.getToken() == "" {
            noLogin.isHidden = false
            doneLogin.isHidden = true
        } else {
            noLogin.isHidden = true
            doneLogin.isHidden = false
        }
    }
}

