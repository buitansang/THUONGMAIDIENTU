//
//  ReviewViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 13/03/2022.
//

import UIKit
import Cosmos
import SDWebImage
import NVActivityIndicatorView

class ReviewViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var image: UIImageView!
    
    //MARK: - Properties
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    var productID = ""
    var name = ""
    var imageURL = ""
    var ratingPoint = 5.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextView()
        tapOnView()
        configureData()
        sendButton.isEnabled = true
    }
    
    //MARK: - Setups
    
    private func setupViewAnimate() {
        viewAnimate.translatesAutoresizingMaskIntoConstraints = false
        viewAnimate.isHidden = false
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
    
    private func configureData() {
        nameProduct.text = name
        image.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "imageNull"))
        image.image?.imageResized(to: CGSize(width: 170, height: 277))
        image.contentMode = .scaleToFill
        rating.didFinishTouchingCosmos = { rating in
            self.ratingPoint = rating
            print("Rating: \(rating)")
        }
    }
    
    private func setupUI() {
        nameProduct.font = UIFont.boldSystemFont(ofSize: 20)
        sendButton.layer.cornerRadius = 8
        rating.settings.fillMode = .half
        rating.settings.starMargin = 5
        rating.settings.disablePanGestures = true
        rating.settings.updateOnTouch = true
        rating.settings.minTouchRating = 0.0
        comment.layer.borderColor = UIColor.black.cgColor
        comment.layer.borderWidth = 2
        
        
        image.layer.cornerRadius = 8
        viewOfImage.backgroundColor = UIColor.clear
        viewOfImage.layer.cornerRadius = 8
        viewOfImage.layer.shadowRadius = 10
        viewOfImage.layer.shadowOpacity = 0.3
        viewOfImage.layer.shadowOffset =  CGSize(width: 1, height: 3)
        viewOfImage.layer.masksToBounds = false
    }
    
    private func setupTextView() {
        comment.delegate = self
        comment.text = "Tell us  your experience"
        comment.textColor = UIColor.lightGray
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func didTapOnScreen() {
        view.endEditing(true)
    }

    //MARK: - Actions

    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        sendButton.isEnabled = true
        if (comment.text == "Tell us  your experience") || (comment.text.isEmpty == true) {
            let alert = UIAlertController(title: "Tell us your experience !!!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.comment.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            sendButton.isEnabled = false
            putReview()
        }
    }
}

extension ReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if comment.textColor == UIColor.lightGray {
            comment.text = nil
            comment.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if comment.text.isEmpty {
            comment.text = "Tell us your experience"
            comment.textColor = UIColor.lightGray
        }
    }
}

extension ReviewViewController {
    private func putReview() {
        viewAnimate.isHidden = false
        APIService.putReview(ratingPoint, comment.text, productID) { checkReview, error in
            self.viewAnimate.isHidden = true
            guard let check = checkReview?.success else { return }
            self.sendButton.isEnabled = true
            print(check)
            DispatchQueue.main.async {
                if check == true {
                    let alert = UIAlertController(title: "Complete !!!", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let detailVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                        detailVC.productID = self.productID
                        detailVC.check = false
                        self.present(detailVC, animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
