//
//  ProductDetailViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/2.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import FacebookShare
import FBSDKShareKit

class ProductDetailViewController: STBaseViewController, UITableViewDataSource, UITableViewDelegate {
   
//    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
//        return product?.mainImage
//    }
//
//    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
//        return product?.mainImage
//    }
    
    @IBOutlet weak var popBackBtn: UIButton!
    
    private struct Segue {

        static let picker = "SeguePicker"
    }

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {

            tableView.dataSource = self

            tableView.delegate = self
        }
    }

    @IBOutlet weak var galleryView: LKGalleryView! {

        didSet {

            galleryView.frame.size.height = CGFloat(Int(UIScreen.width / 375.0 * 500.0))

            galleryView.delegate = self
        }
    }

    @IBOutlet weak var productPickerView: UIView!

    @IBOutlet weak var addToCarBtn: UIButton!
    
    @IBOutlet weak var baseView: UIView!

    lazy var blurView: UIView = {

        let blurView = UIView(frame: tableView.frame)

        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        return blurView
    }()

    private let datas: [ProductContentCategory] = [
        .description, .color, .size, .stock, .texture, .washing, .placeOfProduction, .remarks
    ]

    var product: Product? {

        didSet {

            guard let product = product,
                  let galleryView = galleryView
            else { return }

            galleryView.datas = product.images
        }
    }

    var pickerViewController: ProductPickerController?

    override var isHideNavigationBar: Bool { return true }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        guard let product = product else { return }

        galleryView.datas = product.images
    }

    private func setupTableView() {

        tableView.lk_registerCellWithNib(identifier:
            String(describing: ProductDescriptionTableViewCell.self),
                                         bundle: nil
        )
        

        tableView.lk_registerCellWithNib(identifier:
            ProductDetailCell.color,
                                         bundle: nil
        )

        tableView.lk_registerCellWithNib(identifier:
            ProductDetailCell.label,
                                         bundle: nil
        )
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Segue.picker,
           let pickerVC = segue.destination as? ProductPickerController {

            pickerVC.delegate = self

            pickerVC.product = product

            pickerViewController = pickerVC
        }
    }

    // MARK: - Action
    @IBAction func didTouchAddToCarBtn(_ sender: UIButton) {
        

        if productPickerView.superview == nil {

            showProductPickerView()

        } else {

            guard let color = pickerViewController?.selectedColor,
                  let size = pickerViewController?.selectedSize,
                  let amount = pickerViewController?.selectedAmount,
                  let product = product
            else { return }

            StorageManager.shared.saveOrder(
                color: color, size: size, amount: amount, product: product,
                completion: { result in

                    switch result {

                    case .success:

                        LKProgressHUD.showSuccess()

                        dismissPicker(pickerViewController!)

                    case .failure:

                        LKProgressHUD.showFailure(text: "儲存失敗！")
                    }
                })
        }
    }

    func showProductPickerView() {

        let maxY = tableView.frame.maxY
        
        productPickerView.frame = CGRect(
            x: 0, y: maxY, width: UIScreen.width, height: 0.0
        )
        
        baseView.insertSubview(productPickerView, belowSubview: addToCarBtn.superview!)

        baseView.insertSubview(blurView, belowSubview: productPickerView)

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in

                guard let strongSelf = self else { return }

                let height = 451.0 / 586.0 * strongSelf.tableView.frame.height
                
                self?.productPickerView.frame = CGRect(
                    x: 0, y: maxY - height, width: UIScreen.width, height: height
                )

                self?.isEnableAddToCarBtn(false)
            }
        )
    }

    func isEnableAddToCarBtn(_ flag: Bool) {

        if flag {

            addToCarBtn.isEnabled = true

            addToCarBtn.backgroundColor = UIColor.B1

        } else {

            addToCarBtn.isEnabled = false

            addToCarBtn.backgroundColor = UIColor.B4
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard product != nil else { return 0 }

        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let product = product else { return UITableViewCell() }
        
        guard let descriptCell = datas[0].cellForIndexPath(indexPath, tableView: tableView, data: product) as? ProductDescriptionTableViewCell else {return UITableViewCell()}
        
        descriptCell.delegate = self
        
        if indexPath.row == 0 {
            
            return descriptCell
            
        } else {
        
            return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: product)
        }
    }

    // MARK: - UITableViewDelegate

}

extension ProductDetailViewController: LKGalleryViewDelegate {

    func sizeForItem(_ galleryView: LKGalleryView) -> CGSize {

        return CGSize(width: Int(UIScreen.width), height: Int(UIScreen.width / 375.0 * 500.0))
    }
}

extension ProductDetailViewController: ProductPickerControllerDelegate {

    func dismissPicker(_ controller: ProductPickerController) {

        let origin = productPickerView.frame

        let nextFrame = CGRect(x: origin.minX, y: origin.maxY, width: origin.width, height: origin.height)

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in

                self?.productPickerView.frame = nextFrame

                self?.blurView.removeFromSuperview()

                self?.isEnableAddToCarBtn(true)

            }, completion: { [weak self] _ in

                self?.productPickerView.removeFromSuperview()
            }
        )
    }

    func valueChange(_ controller: ProductPickerController) {

        guard controller.selectedColor != nil,
              controller.selectedSize != nil,
              controller.selectedAmount != nil
        else {

            isEnableAddToCarBtn(false)

            return
        }

        isEnableAddToCarBtn(true)
    }
}

extension ProductDetailViewController: ProductDescriptionTableViewCellDelegate {

    // 以 iOS 內建 UIActivityVC 分享
    func showSharingPage() {
        
//        let storyBoard = UIStoryboard(name: "ProductShare", bundle: nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: "ProductShareViewController")
//        controller.modalPresentationStyle = .overCurrentContext
//        self.present(controller, animated: false, completion: nil)
        
        guard let product = product else {
            print("獲取資料失敗，請重新進入畫面")
            return
        }
        
        let items = [product.title, URL(string: product.mainImage) ?? "圖片網址", "NT$ \(product.price)"] as [Any]
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
        
        print("delegate 分享")
    }
    
    
    // 以 FBSDK 方式分享
    func showShareDialog<C: SharingContent>(_ content: C, mode: ShareDialog.Mode = .automatic) {
        let dialog = ShareDialog(fromViewController: self, content: content, delegate: self as? SharingDelegate)
        dialog.mode = mode
        dialog.show()
    }
    
    func shareToFB() {
        
        guard let product = product else {return}
        
        guard let url = URL(string: "https://300zombies.com/product.html?id=\(product.id)") else {return}
        
        print(url)
        
        let content = ShareLinkContent()
        content.contentURL = url
        content.quote = "\(product.title)  #STYLiSH"
        content.placeID = "296758097659999"
        
        showShareDialog(content, mode: .automatic)
        print("delegate FBSDK 分享")
        
    }
    
    // Add By Kevin
    func addToCompareList() {
        
        guard let product = product else { return }
        
        CompareListManager.shared.saveCPProduct(
            product: product,
            completion: { result in
                
                switch result {
                    
                case .success:
                    
                    LKProgressHUD.showSuccess(text: "成功加入比較清單")
                    
                case .failure:
                    
                    LKProgressHUD.showFailure(text: "儲存失敗！")
                }
        })
    }
    
    // 加入 wish list
    func addToWishList() {
        
        guard let product = product else { return }
        
        WishListManager.shared.saveWishProduct(product: product) { saveResult in
            
            switch saveResult {
                
            case .success:
                
                LKProgressHUD.showSuccess(text: "許願成功！")
    
            
            case .failure:
                
                LKProgressHUD.showFailure(text: "許願失敗(T_T)")
                
            }
        }
        
        
    }
    

}
