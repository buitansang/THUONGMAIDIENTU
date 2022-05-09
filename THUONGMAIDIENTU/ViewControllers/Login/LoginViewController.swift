//
//  LoginViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 10/03/2022.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailImgView: UIImageView!
    @IBOutlet weak var passwordImgView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //MARK: - Properties
    
    var checkLogin: Bool?
    var info: Info?
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        toProfileVC()
        loginButton.isEnabled = true
        registerButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAnimate()
        setupAnimation()
        setupKeyboard()
        editFormButton()
        setupTextField()
        tapOnView()
        setupFontLabel()
        emailTextField.text = "buitansang@yopmail.com"
        passwordTextField.text = "buitansang"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Actions
    
    @IBAction func didTapCreateANewAcc(_ sender: UIButton) {
        registerButton.isEnabled = false
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let createAccount = sb.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(createAccount, animated: true)
//        self.navigationController?.present(createAccount, animated: true, completion: nil)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        view.endEditing(true)
        loginButton.isEnabled = false
        login()
    }
    
    //MARK: - Setups
    
    private func setupViewAnimate() {
        viewAnimate.isHidden = true
        viewAnimate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAnimate)
        NSLayoutConstraint.activate([
            viewAnimate.widthAnchor.constraint(equalToConstant: 70),
            viewAnimate.heightAnchor.constraint(equalToConstant: 70),
            viewAnimate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewAnimate.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        viewAnimate.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 30),
            loading.heightAnchor.constraint(equalToConstant: 30),
            loading.centerXAnchor.constraint(equalTo: viewAnimate.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: viewAnimate.centerYAnchor)
        ])
        loading.startAnimating()
    }
    
    private func toProfileVC() {
        if UserService.shared.getToken() != "" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = sb.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    private func setupFontLabel() {
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 35)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func editFormButton() {
        loginButton.layer.cornerRadius = 12
    }
    
    private func setupTextField() {
        emailTextField.keyboardType = .emailAddress
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidBegin(_:)), for: .editingDidBegin)
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidBegin(_:)), for: .editingDidBegin)
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidEndEditing(_:)), for: .editingDidEnd)
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    @objc func didTapOnScreen() {
        view.endEditing(true)
    }
    
    @objc func emailTextFieldDidBegin(_ sender: UITextField) {
        emailTextField.textColor = .systemGreen
        emailTextField.tintColor = .systemGreen
        emailImgView.tintColor = UIColor.systemGreen
    }
    
    @objc func passwordTextFieldDidBegin(_ sender: UITextField) {
        passwordTextField.textColor = .systemGreen
        passwordTextField.tintColor = .systemGreen
        passwordImgView.tintColor = UIColor.systemGreen
    }
    
    @objc func emailTextFieldDidEndEditing(_ sender: UITextField) {
        emailTextField.textColor = .none
        emailTextField.tintColor = .none
        emailImgView.tintColor = .black
    }
    
    @objc func passwordTextFieldDidEndEditing(_ sender: UITextField) {
        passwordTextField.textColor = .none
        passwordTextField.tintColor = .none
        passwordImgView.tintColor = .black
    }
    
}

//Call API
extension LoginViewController {
    
    //Call api login
    private func login() {
        viewAnimate.isHidden = false
        APIService.postLogin(with: emailTextField.text ?? "", and: passwordTextField.text ?? "") { accountUser, error in
            self.viewAnimate.isHidden = true
            guard let accountUser = accountUser else {
                let alert = UIAlertController(title: "Wrong email or password", message: "Please check and try again", preferredStyle: .alert)
                
                let actionCencal = UIAlertAction (title: "Cencal", style: .cancel) { (action) in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.emailTextField.becomeFirstResponder()
                    self.loginButton.isEnabled = true
                }
                alert.addAction(actionCencal)
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            guard let token = accountUser.token else { return }
            guard let userID = accountUser.user?._id else { return }
            DispatchQueue.main.async {
                self.checkLogin = accountUser.success
                UserService.shared.setToken(with: token)
                UserService.shared.setUserID(with: userID)
                print(UserService.shared.getToken())
                print(UserService.shared.getUserID())
             //   self.getInfoUser()
                if self.checkLogin == true {
                    NotificationCenter.default.post(name: Notification.Name("Logged"), object: nil)
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let profileVC = sb.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    self.navigationController?.pushViewController(profileVC, animated: true)
                } 
            }
        }
    }
}
