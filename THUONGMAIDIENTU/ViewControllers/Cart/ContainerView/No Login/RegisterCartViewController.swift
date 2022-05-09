//
//  RegisterCartViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 19/03/2022.
//

import UIKit

class RegisterCartViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var thongBaoLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailImgView: UIImageView!
    @IBOutlet weak var passwordImgView: UIImageView!
    
    //MARK: - Properties
    
    var checkRegister: Bool?
    
    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.navigationController?.isNavigationBarHidden = true
        createButton.isEnabled = true
        loginButton.isEnabled = true
        thongBaoLabel.text = ""
        editFormButton()
        setupTextField()
        tapOnView()
        setupKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    //MARK: - Setups
    
    private func editFormButton() {
        createButton.layer.cornerRadius = 12
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTextField() {
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidBegin(_:)), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidEndEditing(_:)), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidBegin(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidEndEditing(_:)), for: .editingDidEnd)
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        self.view.addGestureRecognizer(gesture)
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailPatterm = "\\w+@\\w+(\\.\\w+){1,2}"
        let emailFormat = NSPredicate(format:"SELF MATCHES %@", emailPatterm)
        return emailFormat.evaluate(with: email)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 70
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

    @IBAction func didTapLogin(_ sender: UIButton) {
        loginButton.isEnabled = false
        self.navigationController?.popViewController(animated: true)
      //  dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapCreatButton(_ sender: UIButton) {
        view.endEditing(true)
        createButton.isEnabled = true
        guard let email = emailTextField.text else {
            let alert = UIAlertController(title: "Email's not in format", message: "Please check and try again", preferredStyle: .alert)
            
            let actionCencal = UIAlertAction (title: "Cencal", style: .cancel) { (action) in
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.emailTextField.becomeFirstResponder()
                self.createButton.isEnabled = true
                
            }
            alert.addAction(actionCencal)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (isValidEmail(email: email) == false) {
            let alert = UIAlertController(title: "Email's not in format", message: "Please check and try again", preferredStyle: .alert)
            
            let actionCencal = UIAlertAction (title: "Cencal", style: .cancel) { (action) in
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.emailTextField.becomeFirstResponder()
                self.createButton.isEnabled = true
            }
            alert.addAction(actionCencal)
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            register()
        }
    }
}

extension RegisterCartViewController {
    
    //Call API Đăng kí
    private func register() {
        APIService.postRegister(with: emailTextField.text ?? "", and: passwordTextField.text ?? "") { accountUser, error in
            guard let accountUser = accountUser else { return }
            guard let token = accountUser.token else { return }
            UserService.shared.setToken(with: token)
            DispatchQueue.main.async {
                print(accountUser.user)
                self.checkRegister = accountUser.success
                
                if self.checkRegister == true {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let profileVC = sb.instantiateViewController(withIdentifier: "DoneLoginCartViewController") as! DoneLoginCartViewController
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
    }
}
