//
//  DetailViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 08/03/2022.
//

import UIKit
import SDWebImage
import Cosmos
import NVActivityIndicatorView

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewOfPanel: UIView!
    @IBOutlet weak var imagePanel: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var categoryProduct: UILabel!
    @IBOutlet weak var classifyProduct: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var ratingTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var buyNow: UIButton!
    @IBOutlet weak var viewAddCart: UIView!
    @IBOutlet weak var imageAddCart: UIImageView!
    @IBOutlet weak var notHaveRating: UILabel!
    @IBOutlet weak var startRating: CosmosView!
    @IBOutlet weak var ratingPointLabel: UILabel!
    
    //MARK: - Properties
    
    var productID: String = ""
    var listComment: [Comment] = []
    var quantity: Int?
    var stockProduct: Int?
    var checkAddToCart: Bool?
    var check = true
    
    var address = ""
    var city = ""
    var phoneNo = ""
    var postalCode = ""
    var country = ""
    var nameItem = ""
    var image = ""
    var cartID = ""
    var price = 0.0
    var priceItem = 0.0
    
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .white
        return view
    }()
    let loadingCart = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimateCart: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - Life Cycel
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.hidesBackButton = true
        ratingTableView.isHidden = true
        notHaveRating.isHidden = true
        getDetailProduct()
        getReviewComment()
        if check == true {
            viewAddCart.isHidden = false
            buyNow.isHidden = false
        }
        else {
            viewAddCart.isHidden = true
            buyNow.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        view.addSubview(viewAnimate)
        setupUI()
        setupViewAnimateCart()
        setupAnimationCart()
        setupViewAnimate()
        setupAnimation()
        setupRatingTableView()
        setupRatingLabel()
        setupRatingView()
        didTapAddToCart()
    }
    
    //MARK: - Setups
    
    private func setupViewAnimateCart() {
        viewAnimateCart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAnimateCart)
        viewAnimateCart.isHidden = true
        NSLayoutConstraint.activate([
            viewAnimateCart.widthAnchor.constraint(equalToConstant: 70),
            viewAnimateCart.heightAnchor.constraint(equalToConstant: 70),
            viewAnimateCart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewAnimateCart.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupAnimationCart() {
        loadingCart.translatesAutoresizingMaskIntoConstraints = false
        viewAnimateCart.addSubview(loadingCart)
        NSLayoutConstraint.activate([
            loadingCart.widthAnchor.constraint(equalToConstant: 30),
            loadingCart.heightAnchor.constraint(equalToConstant: 30),
            loadingCart.centerXAnchor.constraint(equalTo: viewAnimateCart.centerXAnchor),
            loadingCart.centerYAnchor.constraint(equalTo: viewAnimateCart.centerYAnchor)
        ])
        loadingCart.startAnimating()
    }
    
    func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"
        
        let dateAfter: Date? = dateFormatterGet.date(from: date)
        
        return dateFormatterPrint.string(from: dateAfter!)
    }
    
    private func setupViewAnimate() {
        viewAnimate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAnimate)
        NSLayoutConstraint.activate([
            viewAnimate.widthAnchor.constraint(equalTo: view.widthAnchor),
            viewAnimate.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -120),
            viewAnimate.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  0),
            viewAnimate.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
        ])
    }
    
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
    
    func setupRatingView() {
        startRating.settings.totalStars = 5
        startRating.settings.starSize = 20
        startRating.settings.starMargin = 3
        startRating.settings.fillMode = .precise
        startRating.settings.updateOnTouch = false
    }
    
    // Label thông báo nếu không có đánh giá
    private func setupRatingLabel() {
        if listComment.isEmpty {
            // Show label
            notHaveRating.isHidden = false
            ratingTableView.isHidden = true
        }
        else {
            // Show table
            ratingTableView.reloadData()
            notHaveRating.isHidden = true
            ratingTableView.isHidden = false
        }
    }
    
    private func setupUI() {
        imagePanel.layer.cornerRadius = 10
        viewOfPanel.layer.cornerRadius = 10
        viewOfPanel.layer.masksToBounds = false
        buyNow.layer.cornerRadius = 8
        viewAddCart.layer.cornerRadius = 8
        imageAddCart.layer.cornerRadius = 8
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.ratingTableViewHeight.constant = CGFloat(Double(listComment.count) * 120)
        // chú ý height của table
    }
    
    private func setupRatingTableView() {
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        ratingTableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableViewCell")
        ratingTableView.isScrollEnabled = false
    }
    
    private func didTapAddToCart() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAddToCart))
        viewAddCart.addGestureRecognizer(gesture)
    }
    
    
    @objc func tapAddToCart() {
        if UserService.shared.getToken() == "" {
            let alert = UIAlertController(title: "You are not logged in yet", message: "Please login to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = sb.instantiateViewController(withIdentifier: "LoginDetailViewController") as! LoginDetailViewController
                loginVC.productID = self.productID
                self.navigationController?.pushViewController(loginVC, animated: true)
            }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "How much do you want to order?", message: "", preferredStyle: .alert)
            alert.addTextField { text in
                text.placeholder = "Input quantity"
                text.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "Cencal", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                guard let fields = alert.textFields, fields.count > 0 else { return }
                let quantityFields = fields[0]
                guard let quantityText = quantityFields.text, !quantityText.isEmpty else {
                    print("Chưa nhập số lượng")
                    let alert = UIAlertController(title: "Please input quantity !!!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cencal", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                self.quantity = Int(quantityText)
                if self.quantity == 0 {
                    let alert = UIAlertController(title: "Enter a larger quantity !!!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else if (self.quantity ?? 0) > (self.stockProduct ?? 0) {
                    let alert = UIAlertController(title: "Exceed the amount !!!", message: "Enter a smaller amount", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    print("Nhập vào số lượng sản phẩm: \(self.quantity)")
                    self.putAddToCart()
                }
            }))
            self.present(alert, animated: true)
        }
    }
    //MARK: - Actions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapBuyNowButton(_ sender: UIButton) {
        self.quantity = 0
        if UserService.shared.getToken() == "" {
            let alert = UIAlertController(title: "You are not logged in yet", message: "Please login to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = sb.instantiateViewController(withIdentifier: "LoginDetailViewController") as! LoginDetailViewController
                loginVC.productID = self.productID
                self.navigationController?.pushViewController(loginVC, animated: true)
            }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "How much do you want to order?", message: "", preferredStyle: .alert)
            alert.addTextField { text in
                text.placeholder = "Input quantity"
                text.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                guard let fields = alert.textFields, fields.count > 0 else { return }
                let quantityFields = fields[0]
                guard let quantityText = quantityFields.text, !quantityText.isEmpty else {
                    print("Chưa nhập số lượng")
                    let alert = UIAlertController(title: "Please input quantity !!!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                self.quantity = Int(quantityText)
                if self.quantity == 0 {
                    let alert = UIAlertController(title: "Enter a larger quantity !!!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else if (self.quantity ?? 0) > (self.stockProduct ?? 0) {
                    let alert = UIAlertController(title: "Exceed the amount !!!", message: "Enter a smaller amount", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    print("Nhập vào số lượng sản phẩm: \(self.quantity)")
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let orderNowVC = sb.instantiateViewController(withIdentifier: "OrderNowViewController") as! OrderNowViewController
                    orderNowVC.nameItem = self.nameItem
                    orderNowVC.priceItem = self.price
                    orderNowVC.quantity = self.quantity ?? 0
                    orderNowVC.image = self.image
                    orderNowVC.productID = self.productID
                    orderNowVC.categoryItem = self.categoryProduct.text ?? ""
                    self.navigationController?.pushViewController(orderNowVC, animated: true)
                }
            }))
            self.present(alert, animated: true)
            
        }
        
    }
}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = listComment[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        cell.viewRating.rating = comment.rating ?? 0.0
        cell.name.text = comment.userName
        cell.comment.text = comment.comment
        cell.date.text = "Created At: " + formatDate(date: comment.createAt ?? "")
        cell.avatar.image = UIImage(named: "sang")
        cell.avatar.sd_setImage(with: URL(string: comment.image ?? ""), placeholderImage: UIImage(named: "sang"))
        cell.avatar.image?.imageResized(to: CGSize(width: 50, height: 50))
        cell.avatar.contentMode = .scaleToFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//Call api
extension DetailViewController {
    //Call api get DetailProduct
    private func getDetailProduct() {
        // showloading
        viewAnimate.isHidden = false
        APIService.getDetailProduct(with: productID ?? "") { detailProduct, error in
            // hide loading truoc gruad let
            self.viewAnimate.isHidden = true
            guard let detailProduct = detailProduct, let product = detailProduct.product else {  return }
            print("Detail product: \(product)")
            DispatchQueue.main.async {
                self.image = product.images?.first?.url ?? ""
                self.imagePanel.sd_setImage(with: URL(string: product.images?.first?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
                self.imagePanel.image?.imageResized(to: CGSize(width: self.view.frame.width, height: 300))
                self.imagePanel.contentMode = .scaleToFill
                self.nameProduct.text = product.name?.uppercased()
                self.nameItem = product.name ?? ""
                self.categoryProduct.text = product.category
                self.classifyProduct.text = product.classify
                if let price = product.price {
                    self.priceProduct.text = "$ " + String(price)
                    self.price = price
                }
                self.descriptionProduct.text = "About: " + (product.description ?? "")
                self.stockProduct = product.stock
            }
        }
    }
    
    //Call api get Review Comment
    private func getReviewComment() {
        APIService.getReviewComment(with: productID) { reviewComment, error in
            guard let reviewComment = reviewComment else { return }
            guard let listComment = reviewComment.list else { return }
            print("List comment: \(listComment)")
            DispatchQueue.main.async {
                self.listComment = listComment
                if let averageReview = reviewComment.averageReview {
                    self.ratingPointLabel.text =  String(averageReview) + " / 5"
                    self.startRating.rating = averageReview
                }
                self.ratingTableView.reloadData()
                self.setupRatingLabel()
                self.viewDidLayoutSubviews()
            }
        }
    }
    
    private func putAddToCart() {
      //  viewAnimateCart.isHidden = false
        APIService.putAddToCart(with: productID, and: quantity ?? 0) { addToCart, error in
            guard let addToCart = addToCart else { return }
            print("ADD TO CART: \(addToCart)")
//            guard let carts = addToCart.user?.carts else { return}
//            for i in 0..<carts.count {
//                if carts[i].productId == self.productID {
//                    self.cartID = carts[i]._id ?? ""
//                }
//            }
            guard let checkAddToCart = addToCart.success else { return }
            if checkAddToCart == true {
                self.viewAnimateCart.isHidden = true
                let alert = UIAlertController(title: "Complete !", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }
        }
    }
}
