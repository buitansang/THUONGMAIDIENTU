//
//  LoginDetailViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 18/03/2022.
//

import UIKit

class LoginDetailViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailImgView: UIImageView!
    @IBOutlet weak var passwordImgView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //MARK: - Properties
    
    var checkLogin: Bool?
    var productID: String?
    
    //MARK: - LifyCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        if UserService.shared.getToken() != "" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailProductVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailProductVC.productID = self.productID ?? ""
            self.navigationController?.pushViewController(detailProductVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = true
        setupKeyboard()
        editFormButton()
        setupTextField()
        tapOnView()
        setupFontLabel()
        emailTextField.text = "buitansang@yopmail.com"
        passwordTextField.text = "buitansang"

    }
    
    //MARK: - Setups
    
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
    
    
    //MARK: - Actions
    
    @IBAction func didTapCreateANewAcc(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let createAccount = sb.instantiateViewController(identifier: "RegisterDetailViewController") as! RegisterDetailViewController
        createAccount.productID = self.productID
        self.navigationController?.pushViewController(createAccount, animated: true)
//        self.navigationController?.present(createAccount, animated: true, completion: nil)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        view.endEditing(true)
        loginButton.isEnabled = false
        login()
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoginDetailViewController {
    
    private func login() {
        APIService.postLogin(with: emailTextField.text ?? "", and: passwordTextField.text ?? "") { accountUser, error in
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
                if self.checkLogin == true {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let detailProductVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                    detailProductVC.productID = self.productID ?? ""
                    self.navigationController?.pushViewController(detailProductVC, animated: true)
                }
            }
        }
    }
}
