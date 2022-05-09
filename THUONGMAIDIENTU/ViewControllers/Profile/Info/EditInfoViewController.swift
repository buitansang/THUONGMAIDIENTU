//
//  EditInfoViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 14/03/2022.
//

import UIKit
import NVActivityIndicatorView

class EditInfoViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewOfAvatar: UIView!
    @IBOutlet weak var viewOfCamera: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var placeOfBirth: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    //MARK: - Properties
    
    let imagePickerController = UIImagePickerController()
    let datePicker = UIDatePicker()
    var selectImage = UIImage()
    var imgString: String = ""
    var checkUpdate: Bool?
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    var nameText =  ""
    var birthDayText =  ""
    var addressText =  ""
    var phoneText = ""
    var emailText =  ""
    
    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        view.addSubview(viewAnimate)
        imagePickerController.delegate = self
        setupBarItem()
        setupUI()
        tapOnView()
        setupKeyboard()
        didTapCamera()
        setupTextField()
        setupViewAnimate()
        setupAnimation()
        getInfoUser()
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    //MARK: - Setups
    
    private func createToolbar() -> UIToolbar {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateOfBirth.inputView = datePicker
        dateOfBirth.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateOfBirth.text =  dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    private func setupViewAnimate() {
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
    
    private func setupTextField() {
        name.addTarget(self, action: #selector(nameDidEditBegin), for: .editingDidBegin)
        dateOfBirth.addTarget(self, action: #selector(birthdayDidEditBegin), for: .editingDidBegin)
        placeOfBirth.addTarget(self, action: #selector(addressDidEditBegin), for: .editingDidBegin)
        phoneNumber.addTarget(self, action: #selector(phoneDidEditBegin), for: .editingDidBegin)
        email.addTarget(self, action: #selector(emailDidEditBegin), for: .editingDidBegin)
    }
    
    private func setupKeyboard() {
        phoneNumber.keyboardType = .numberPad
        email.keyboardType = .emailAddress
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        background.alpha = 1
        viewOfAvatar.layer.cornerRadius = 50
        viewOfAvatar.layer.shadowRadius = 8
        viewOfAvatar.layer.shadowOpacity = 0.5
        viewOfAvatar.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfAvatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = 50
        
        viewOfCamera.layer.cornerRadius = 5
        viewOfCamera.alpha = 0.8
        viewOfCamera.layer.masksToBounds = false
        camera.layer.cornerRadius = 5
        updateButton.layer.cornerRadius = 12
    }
    
    private func setupBarItem() {
        self.navigationItem.title = "Edit Profile"
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDone))
        navigationController?.navigationBar.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = done
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        self.view.addGestureRecognizer(gesture)
    }
    
    private func didTapCamera() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImgView))
        viewOfCamera.addGestureRecognizer(gesture)
        
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "[0]{1}+[0-9]{9}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailPatterm = "\\w+@\\w+(\\.\\w+){1,2}"
        let emailFormat = NSPredicate(format:"SELF MATCHES %@", emailPatterm)
        return emailFormat.evaluate(with: email)
    }
    
    @objc func nameDidEditBegin() {
        name.text = ""
    }
    
    @objc func birthdayDidEditBegin() {
        dateOfBirth.text = ""
    }
    
    @objc func addressDidEditBegin() {
        placeOfBirth.text = ""
    }
    
    @objc func phoneDidEditBegin() {
        phoneNumber.text = ""
    }
    
    @objc func emailDidEditBegin() {
        email.text = ""
    }
    
    @objc func didTapDone() {
        view.endEditing(true)
    }
    @objc func didTapOnScreen() {
        view.endEditing(true)
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
    
    @objc func didTapImgView() {
//        imagePickerController.modalPresentationStyle = .fullScreen
        let alert = UIAlertController(title: "Update Avatar", message: "Choose the way", preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let actionCencal = UIAlertAction(title: "Cencal", style: .cancel) { (action) in
            
        }
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCencal)
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - Actions
    
    @IBAction func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapUpdate() {
         nameText = name.text ?? ""
         birthDayText = dateOfBirth.text ?? ""
         addressText = placeOfBirth.text ?? ""
         phoneText = phoneNumber.text ?? ""
         emailText = email.text ?? ""

        if nameText.count <= 0  {
            let alert = UIAlertController(title: "Name is empty !!", message: "input your name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.name.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        } else if birthDayText.count <= 0 {
            let alert = UIAlertController(title: "Birthday is empty !!", message: "input your birthday", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dateOfBirth.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        } else if (Int(birthDayText.prefix(4)) ?? 0) >= 2022 {
            let alert = UIAlertController(title: "Birthday is not valid !!", message: "input your birthday", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dateOfBirth.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        } else if addressText.count <= 0 {
            let alert = UIAlertController(title: "Address is empty !!", message: "input your address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.placeOfBirth.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        } else if !isValidPhone(phone: phoneText) {
            let alert = UIAlertController(title: "Phone is not valid !!", message: "input your phone again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.phoneNumber.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        } else if !isValidEmail(email: emailText) {
            let alert = UIAlertController(title: "Phone is not valid !!", message: "input your phone again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.email.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
        } else {
            updateButton.isEnabled = false
            putUpdateProfile()
        }
    }
}

//Call API
extension EditInfoViewController {
    
  //Call API get Info User
    private func getInfoUser() {
        viewAnimate.isHidden = false
        scrollView.isHidden = true
        APIService.getInfoUser() { infoUser, error in
            self.viewAnimate.isHidden = true
            self.scrollView.isHidden = false
            guard let infoUser = infoUser, let info = infoUser.user else { return }
            DispatchQueue.main.async {
                self.avatar.sd_setImage(with: URL(string: info.avatar?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
                self.avatar.contentMode = .scaleToFill
                self.name.text = info.name
                self.email.text = info.emailUser
                self.placeOfBirth.text = info.placeOfBirth
                self.dateOfBirth.text = info.dateOfBirth
                self.phoneNumber.text = info.phoneNumber
            }
            print("Info User: \(infoUser)")
        }
    }
    
    //Call API put update profile
    private func putUpdateProfile() {
        viewAnimate.isHidden = false
        guard let imageAvatar = avatar.image else { return }
        imgString = convertImageToBase64String(img: imageAvatar)
        APIService.putUpdateProfile(imgString, name.text ?? "", dateOfBirth.text ?? "", placeOfBirth.text ?? "", phoneNumber.text ?? "", email.text ?? "") { updateProfile, error in
            self.viewAnimate.isHidden = true
            guard let updateProfile = updateProfile else { return }
            print("UPDATE PROFILE: \(updateProfile)")
            guard let checkUpdate = updateProfile.success else { return }
            if checkUpdate == true {
                let alert = UIAlertController(title: "Update profile completely !", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cencal", style: .cancel, handler: { _ in
                    self.updateButton.isEnabled = true
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension EditInfoViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[.originalImage] as? UIImage {
            selectImage = image
            avatar.image = image
            self.imgString = convertImageToBase64String(img: selectImage)
            imagePickerController.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
