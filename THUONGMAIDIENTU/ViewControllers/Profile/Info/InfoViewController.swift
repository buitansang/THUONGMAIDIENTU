//
//  InfoViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 14/03/2022.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class InfoViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewOfAvatar: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var viewOfEdit: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var edit: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var placeOfBirth: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewAnimate: UIView!
    
    //MARK: - Properties
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        getInfoUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        didTapEditProfile()
        setupData()
        setupAnimation()
    }
    
    //MARK: - Setups
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        viewAnimate.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 30),
            loading.heightAnchor.constraint(equalToConstant: 30),
            loading.centerXAnchor.constraint(equalTo: viewAnimate.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: viewAnimate.centerYAnchor, constant: 25)
        ])
        loading.startAnimating()
    }
    
    private func setupUI() {
        background.alpha = 1
        viewOfAvatar.layer.cornerRadius = 50
        viewOfAvatar.layer.shadowRadius = 8
        viewOfAvatar.layer.shadowOpacity = 0.5
        viewOfAvatar.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfAvatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = 50
        viewOfEdit.layer.cornerRadius = 15
        logoutButton.layer.cornerRadius = 12
    }
    
    private func setupData() {
        name.text = ""
        dateOfBirth.text = ""
        placeOfBirth.text = ""
        phoneNumber.text = ""
        email.text = ""
        role.text = ""
        createAt.text = ""
    }
    
    private func didTapEditProfile() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapEdit))
        viewOfEdit.addGestureRecognizer(gesture)
        
    }
    
    @objc func didTapEdit() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editInfoVC = sb.instantiateViewController(withIdentifier: "EditInfoViewController") as! EditInfoViewController
        self.navigationController?.pushViewController(editInfoVC, animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func didTapLogout() {
        UserService.shared.removeData()
        print("Logout token: \(UserService.shared.getToken())")
        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

//Call API
extension InfoViewController {
    
    //Call API lấy thông tin user
    private func getInfoUser() {
        viewAnimate.isHidden = false
        scrollView.isHidden = true
        APIService.getInfoUser() { infoUser, error in
            self.viewAnimate.isHidden = true
            self.scrollView.isHidden = false
            guard let infoUser = infoUser else { return }
            guard let info = infoUser.user else { return }
            DispatchQueue.main.async {
                self.avatar.sd_setImage(with: URL(string: info.avatar?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
                self.avatar.contentMode = .scaleToFill
                self.name.text = info.name
                self.email.text = info.emailUser
                self.placeOfBirth.text = info.placeOfBirth
                self.dateOfBirth.text = info.dateOfBirth
                self.phoneNumber.text = info.phoneNumber
                self.role.text = info.role
                guard let createAt = info.createAt else { return }
                let index = createAt.index(createAt.startIndex, offsetBy: 10)
                self.createAt.text = String(createAt.prefix(upTo: index))
            }
            print("Info User: \(infoUser)")
        }
    }
}
