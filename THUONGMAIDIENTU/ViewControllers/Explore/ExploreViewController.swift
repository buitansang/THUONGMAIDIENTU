//
//  ExploreViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit
import Alamofire
import SDWebImage
import NVActivityIndicatorView

class ExploreViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var slideCollectionView: UICollectionView!
    @IBOutlet weak var listProductCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: -Properties
    
    var nameImageOfSlide: [String] = ["imgSlide2","imgSlide1","imgSlide3"]
    var footerView: CustomFooterView?
    var isLoading: Bool = false
    var randomProducts: [Product] = []
    var exploreProducts: [Product] = []
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    let footerViewReuseIndentifier = "RefreshFooterView"
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupUI()
        setupPagingSlide()
        setupImageSlide()
        setupListProduct()
        setupAnimation()
        getRandomProduct()
        
    }
    
    //MARK: - Setups
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 25),
            loading.heightAnchor.constraint(equalToConstant: 25),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ])
    }
    
    private func setupUI() {
        slideCollectionView.layer.cornerRadius = 20
        searchBar.layer.cornerRadius = 45
    }
    
    private func  setupImageSlide() {
        slideCollectionView.dataSource = self
        slideCollectionView.delegate = self
        slideCollectionView.register(UINib(nibName: "ImageSlideCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageSlideCollectionViewCell")
    }
    private func setupListProduct() {
        listProductCollectionView.dataSource = self
        listProductCollectionView.delegate = self
        listProductCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listProductCollectionView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        listProductCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIndentifier)
    }
    
    // Loại bỏ bất kỳ tài nguyên nào có thể được tạo lại.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPagingSlide() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = nameImageOfSlide.count
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offSet = scrollView.contentOffset.x
//        let width = scrollView.frame.width
//        let horizontalCenter = width / 2
//
//        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
//    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == slideCollectionView {
            return nameImageOfSlide.count
        } else {
            return exploreProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // && exploreProducts.count  > 0
        if collectionView == listProductCollectionView  {
            
            let exploreProduct = exploreProducts[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
            cell.imageProduct.sd_setImage(with: URL(string: exploreProduct.images?.first?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
            cell.imageProduct.image?.imageResized(to: CGSize(width: 170, height: 277))
            cell.imageProduct.contentMode = .scaleToFill
            cell.nameProduct.text = exploreProduct.name
            if let price = exploreProduct.price {
                cell.priceProduct.text = "$ " + String(price)
            }
            return cell
        }
        else {
            pageControl.currentPage = indexPath.item
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSlideCollectionViewCell", for: indexPath) as! ImageSlideCollectionViewCell
            cell.imageSlideView.image = UIImage(named: nameImageOfSlide[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == listProductCollectionView {
            let exploreProduct = exploreProducts[indexPath.item]
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let detailScreenVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                detailScreenVC.productID = exploreProduct._id ?? ""
                self.navigationController?.pushViewController(detailScreenVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == listProductCollectionView {
            let width = (collectionView.frame.size.width - 12) / 2
            
            return CGSize(width: width, height: 350)
        }
        if collectionView == slideCollectionView  {
            return CGSize(width: slideCollectionView.frame.size.width, height: 160)

        }
        return CGSize(width: 0, height: 0)
    }
    
    
    // kích thước tham chiếu cho tiêu đề trong phần
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    //tham chiếu kích thước cho chân trang trong phần
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if collectionView == listProductCollectionView {
            if isLoading {
                return CGSize.zero
            }
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
        return CGSize.zero
    }
    
    //Yêu cầu đối tượng nguồn dữ liệu của bạn cung cấp chế độ xem bổ sung để hiển thị trong chế độ xem bộ sưu tập.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == listProductCollectionView {
            if kind == UICollectionView.elementKindSectionFooter {
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIndentifier, for: indexPath) as! CustomFooterView
                self.footerView = aFooterView
                self.footerView?.backgroundColor = UIColor.clear
                return aFooterView
            } else {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIndentifier, for: indexPath)
                return headerView
            }
        }
        return UICollectionReusableView()
        
    }
    //Cho đại biểu biết rằng dạng xem bổ sung được chỉ định sắp được hiển thị trong dạng xem bộ sưu tập.
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if collectionView == listProductCollectionView {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.footerView?.prepareInitialAnimation()
            }
        }
    }
    
    //Cho đại biểu biết rằng dạng xem bổ sung được chỉ định đã được hiển thị trong dạng xem bộ sưu tập.
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        if collectionView == listProductCollectionView {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.footerView?.stopAnimate()
            }
        }
    }
    
    //tính toán giá trị cuộn và chơi với ngưỡng để có được hiệu ứng mong muốn
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == slideCollectionView {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
        }
        if scrollView == listProductCollectionView {
            let threshold   = 100.0 ;
            let contentOffset = scrollView.contentOffset.y;
            let contentHeight = scrollView.contentSize.height;
            let diffHeight = contentHeight - contentOffset;
            let frameHeight = scrollView.bounds.size.height;
            var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
            triggerThreshold   =  min(triggerThreshold, 0.0)
            let pullRatio  = min(abs(triggerThreshold),1.0);
            self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
            if pullRatio >= 1 {
                self.footerView?.animateFinal()
            }
        }
//        print("pullRation:\(pullRatio)")
    }
    
    //tính toán độ lệch và gọi phương thức tải
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
//        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0
        {
            guard let footerView = self.footerView, footerView.isAnimatingFinal else { return }
//            print("load more trigger")
            self.isLoading = true
            self.footerView?.startAnimate()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer: Timer) in
                self.getRandomProduct()
                print("exploreProducts: \(self.exploreProducts)")
                print("SOLUONG \(self.exploreProducts.count)")
                 self.listProductCollectionView.reloadData()
                self.isLoading = false
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == slideCollectionView {
           pageControl.currentPage = indexPath.item
        }
    }
}

// API
extension ExploreViewController {
    
    //Call api get
    private func getRandomProduct() {
        loading.startAnimating()
        APIService.getRandomProduct(with: .getRandomProduct) { exploreProducts, error in
            self.loading.stopAnimating()
            guard let exploreProducts = exploreProducts, let products = exploreProducts.products else { return }
            DispatchQueue.main.async {
                self.randomProducts = products
                self.exploreProducts += self.randomProducts
                self.listProductCollectionView.reloadData()
                print("Random Product: \(self.randomProducts)")
            }
        }
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let searchScreenVC = sb.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            self.navigationController?.pushViewController(searchScreenVC, animated: true)
        }
    }
}
