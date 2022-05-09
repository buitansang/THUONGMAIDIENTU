//
//  EditAddressViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 19/03/2022.
//

import UIKit

class EditAddressViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addressTextFiled: UITextField!
    @IBOutlet weak var cityTextFiled: UITextField!
    @IBOutlet weak var countryTextFiled: UITextField!
    @IBOutlet weak var phoneNoTextFiled: UITextField!
    @IBOutlet weak var postalCodeTextFiled: UITextField!
    
    //MARK: - Properties
    
    weak var  delegate: DetailDelegate?
    
    var address = ""
    var city = ""
    var country = ""
    var phoneNo = ""
    var postalCode = ""
    

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        tapOnView()
        setupKeyboard()
        setupBarItem()
        setupUI()
        addressTextFiled.text = "TD"
        cityTextFiled.text = "TD"
        countryTextFiled.text = "TD"
        phoneNoTextFiled.text = "0371112222"
        postalCodeTextFiled.text = "12345"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    //MARK: - Setups
    
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "[0]{1}+[0-9]{9}"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }
    func isValidPostalCode(postalCode: String) -> Bool {
        let postalCodeRegex = "[0-9]{5}"
        let postalCodeTest = NSPredicate(format: "SELF MATCHES %@", postalCodeRegex)
        return postalCodeTest.evaluate(with: postalCode)
    }
    
    private func setupUI() {
        doneButton.layer.cornerRadius = 12
    }
    
    private func setupBarItem() {
        self.navigationItem.title = "Address"
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDone))
        navigationController?.navigationBar.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = done
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        self.view.addGestureRecognizer(gesture)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc func didTapDone() {
        view.endEditing(true)
    }

    @objc func didTapOnView() {
        view.endEditing(true)
    }
    
    //MARK: - Actions
    
    @IBAction func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapDoneButton(_ sender: UIButton) {
        address = addressTextFiled.text ?? ""
        city = cityTextFiled.text ?? ""
        country = countryTextFiled.text ?? ""
        phoneNo = phoneNoTextFiled.text ?? ""
        postalCode = postalCodeTextFiled.text ?? ""
        if address.count <= 0 {
            let alert = UIAlertController(title: "Address is empty !!", message: "input your address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.addressTextFiled.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        }
        else if city.count <= 0 {
            let alert = UIAlertController(title: "City is empty !!", message: "input your city", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.cityTextFiled.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        }
        else if !isValidPhone(phone: phoneNo) {
            let alert = UIAlertController(title: "Phone is not valid !!", message: "input your phone again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.phoneNoTextFiled.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        }
        else if !isValidPostalCode(postalCode: postalCode) {
            let alert = UIAlertController(title: "Postal Code is not valid !!", message: "input your postal code again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.postalCodeTextFiled.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        }
        else if country.count <= 0 {
            let alert = UIAlertController(title: "Country is empty !!", message: "input your country", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.countryTextFiled.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shippingInfo"), object: nil, userInfo: ["address":addressTextFiled.text, "city":cityTextFiled.text, "country":countryTextFiled.text, "phoneNo":phoneNoTextFiled.text, "postalCode":postalCodeTextFiled.text])
            
            delegate?.infoAddress(address, city, phoneNo, postalCode, country)
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        
        
    }
}
