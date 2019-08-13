//
//  WishListViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/8/12.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController {
    
    
    @IBOutlet weak var wishListCollectionView: UICollectionView!
    @IBOutlet weak var showEmotyView: UIView!
    
    @IBOutlet weak var topView: UIView!

    
    var pickerViewController: ProductPickerController?
    
    var wishProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWishes()
        
        setUpFlatCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWishes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        WishListManager.shared.saveAll { _ in }
    }
    
    
    var wishes: [WishProduct] = [] {
        
        didSet {
        
            wishListCollectionView.reloadData()
            
            if wishes.count == 0 {
                
                showEmotyView.isHidden = false
                
                topView.isHidden = true
                
                wishListCollectionView.isHidden = true
            } else {
                
                showEmotyView.isHidden = true
                
                topView.isHidden = false
                
                wishListCollectionView.isHidden = false
                
            }
        }
    }
    
    func touchAddWishToCart(product: Product) {
        
        let vc = UIStoryboard.product.instantiateViewController(withIdentifier:
            String(describing: ProductPickerController.self)
        )
        
        guard let pickerVC = vc as? ProductPickerController else { return }
        
        pickerVC.product = product
        
        pickerVC.delegate = self
        
        present(pickerVC, animated: false, completion: nil)
        
//        func showProductPickerView() {
//
//            let maxY = wishListCollectionView.frame.maxY
//
//            productPickerView.frame = CGRect(
//                x: 0, y: maxY, width: UIScreen.width, height: 0.0
//            )
//
//            wishListCollectionView.addSubview(productPickerView)
//
//
//            UIView.animate(
//                withDuration: 0.3,
//                animations: { [weak self] in
//
//                    guard let strongSelf = self else { return }
//
//                    let height = 451.0 / 586.0 * strongSelf.wishListCollectionView.frame.height
//
//                    self?.productPickerView.frame = CGRect(
//                        x: 0, y: maxY - height, width: UIScreen.width, height: height
//                    )
//
//                    self?.isEnableAddToCarBtn(false)
//                }
//            )
//        }
        
    }
    
    
    func fetchWishes() {
        
        WishListManager.shared.fetchWishProducts { fetchResult in
            
            switch fetchResult {
            
            case .success(let wishes):
                
                self.wishes = wishes
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "讀取願望清單錯誤！")
                
            }
        }
    }
    
    @objc func deleteWishes(at index: Int) {
        
        WishListManager.shared.deleteWishProduct(wishes[index]) {
            deleteResult in
            
            switch deleteResult {
                
              case .success:
                
                wishes.remove(at: index)
                
              case .failure:
                
                LKProgressHUD.showFailure(text: "刪除願望失敗！考慮留下？")
                
            }
        }
    }
    
    func deleteAllWishes() {
        
        WishListManager.shared.deleteAllWish(completion: { _ in })
    }
    
    lazy var cardLayout: FlatCardCollectioViewLayout = {
        
        let layout = FlatCardCollectioViewLayout()
        layout.itemSize = CGSize(width: 220, height: 350)
        layout.minimumLineSpacing = CGFloat(10)
        
        return layout
    }()
    
    private func setUpFlatCardView() {
        
        wishListCollectionView.dataSource = self
        wishListCollectionView.delegate = self
        wishListCollectionView.showsVerticalScrollIndicator = false
        wishListCollectionView.collectionViewLayout = cardLayout
        wishListCollectionView.lk_registerCellWithNib(identifier: String(describing: WishListCell.self), bundle: nil)
    }

}


extension WishListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("＝＝＝願望清單商品數：\(wishes.count)＝＝＝")
        
        return wishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = wishListCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WishListCell.self), for: indexPath)
        
        guard let wishCell = cell as? WishListCell else { return cell }
        
        wishCell.wishTitle.text = wishes[indexPath.item].title ?? "(品名)"
        
        wishCell.wishImage.loadImage(wishes[indexPath.item].mainImage)
        
        wishCell.wishPrice.text = String(wishes[indexPath.item].price)
        
        wishCell.touchHandler = { [weak self] in
            
            self?.deleteWishes(at: indexPath.item)
        }
        
        wishCell.layer.shadowColor = UIColor.gray.cgColor
        wishCell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        wishCell.layer.shadowRadius = 16.0
        wishCell.layer.shadowOpacity = 0.5
        wishCell.layer.masksToBounds = false
        
        return wishCell
    }
}

extension WishListViewController: UICollectionViewDelegate {

    private func showProductDetailViewController(product: Product, index: Int) {

        let vc = UIStoryboard.product.instantiateViewController(withIdentifier:
            String(describing: ProductDetailViewController.self)
        )

        guard let detailVC = vc as? ProductDetailViewController else { return }

        detailVC.product = product

        show(detailVC, sender: nil)
        
        
        detailVC.popBackBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)

    }
    
    @objc func popBack() {
        dismiss(animated: true, completion: nil)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        wishListCollectionView.deselectItem(at: indexPath, animated: true)
        
        guard let wishColors = wishes[indexPath.item].colors?.allObjects as? [WishColor] else {return}
        
        guard let wishVariants = wishes[indexPath.item].variants?.allObjects as? [WishVariant] else {return}
        
        let colors = wishColors.map { (wishcolor) -> Color in
            
            guard let name = wishcolor.name, let code = wishcolor.code else {return Color(name: "", code: "")}
            
            let colorArray = Color(name: name, code: code)
            
            return colorArray
        
        }
        
        let variants = wishVariants.map { (wishVariant) -> Variant in
            
            guard let colorCode = wishVariant.colorCode, let size = wishVariant.size else { return Variant(colorCode: "", size: "", stock: 0) }
            
            let stocks = Int(wishVariant.stocks)
            
            let variantsArray = Variant(colorCode: colorCode, size: size, stock: stocks)
            
            return variantsArray
            
        }


        let wishProduct = Product(
            id: Int(wishes[indexPath.item].id),
            title: wishes[indexPath.item].title ?? "",
            description: wishes[indexPath.item].detail ?? "",
            price: Int(wishes[indexPath.item].price),
            texture: wishes[indexPath.item].texture ?? "",
            wash: wishes[indexPath.item].wash ?? "",
            place: wishes[indexPath.item].place ?? "",
            note: wishes[indexPath.item].note ?? "",
            story: wishes[indexPath.item].story ?? "",
            colors: colors,
            sizes: wishes[indexPath.item].sizes ?? [],
            variants: variants,
            mainImage: wishes[indexPath.item].mainImage ?? "",
            images: wishes[indexPath.item].images ?? [])
        
        self.wishProduct = wishProduct

        showProductDetailViewController(product: wishProduct, index: indexPath.item)
//            touchAddWishToCart(product: wishProduct)
    }
}

extension WishListViewController: ProductPickerControllerDelegate {
    
    func dismissPicker(_ controller: ProductPickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func valueChange(_ controller: ProductPickerController) {
    }
    
    
}

