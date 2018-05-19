//
//  AccountViewController.swift
//  Banana
//


import UIKit
import Alamofire
import SDWebImage

let IMAGE_COMPRESSION_QUALITY: CGFloat = 0.1
class AccountViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var pointsRankLb: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var passwrdTxtField: UITextField!
    @IBOutlet weak var newPassTxtField: UITextField!
    @IBOutlet weak var confirmPassTxtField: UITextField!
    @IBOutlet weak var saveButt: UIButton!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var saveButtConstraint: NSLayoutConstraint!
    
    var avatarImage: UIImage? {
        didSet {
            self.saveButt.isEnabled = true
        }
    }
    var userInfo: UsersObject?
    var passwordChanged = false
    var isChangingPassword = false
    var isUpdatedAvatar = false
    var updateUserResponse: UpdateUserResponse? {
        didSet{
            if (updateUserResponse?.success)! {
                UserDefaults.standard.set(updateUserResponse?.data?.address, forKey: "Address")
                UserDefaults.standard.set(updateUserResponse?.data?.email, forKey: "Email")
                UserDefaults.standard.set(updateUserResponse?.data?.phoneNo, forKey: "Phone")
                UserDefaults.standard.set(updateUserResponse?.data?.userName, forKey: "UserName")
                if self.passwordChanged && passwrdTxtField.text != "" {
                    let param = ["password": self.passwrdTxtField.text!,"newPassword": self.newPassTxtField.text!,"confirmPassword": self.confirmPassTxtField.text!]
                    let token = UserDefaults.standard.string(forKey: "Token")
                    let userID = UserDefaults.standard.string(forKey: "UserID")
                    self.showLoading()
                    ServiceHelpers.updatePassword(param: param, token: token!, userID: userID!, callback: {(response) in
                        self.updatePassResponse = response
                    })
                } else if self.avatarImage != nil {
                    let token = UserDefaults.standard.string(forKey: "Token")
                    let userID = UserDefaults.standard.string(forKey: "UserID")
                
                    self.postAvatar(data: UIImageJPEGRepresentation(self.avatarImage!, IMAGE_COMPRESSION_QUALITY)!, userID: userID!, token: token!)
                } else {
                    self.hideLoading()
                    self.showSuccess()
                }
            } else {
                let alert = UIAlertController(title: "Warning!", message: updateUserResponse?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var updatePassResponse: UpdatePasswordResponse? {
        didSet {
            if !(updatePassResponse?.success)! {
                let alert = UIAlertController(title: "Warning!", message: updatePassResponse?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if self.avatarImage != nil {
                let token = UserDefaults.standard.string(forKey: "Token")
                let userID = UserDefaults.standard.string(forKey: "UserID")
            
                self.postAvatar(data: UIImageJPEGRepresentation(self.avatarImage!, IMAGE_COMPRESSION_QUALITY)!, userID: userID!, token: token!)
            } else {
                self.hideLoading()
                self.showSuccess()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        // Do any additional setup after loading the view.
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarChange)))
        
        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
        
        //imageview rounded shape
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100.0/2
        
        //textfield rounded corner
        emailTxtField.borderStyle = .roundedRect
        userNameTxtField.borderStyle = .roundedRect
        phoneTxtField.borderStyle = .roundedRect
        addressTxtField.borderStyle = .roundedRect
        passwrdTxtField.borderStyle = .roundedRect
        newPassTxtField.borderStyle = .roundedRect
        confirmPassTxtField.borderStyle = .roundedRect
        
        //textfield delegate
        emailTxtField.delegate = self
        userNameTxtField.delegate = self
        phoneTxtField.delegate = self
        addressTxtField.delegate = self
        passwrdTxtField.delegate = self
        newPassTxtField.delegate = self
        confirmPassTxtField.delegate = self
        
        //button
        saveButt.isEnabled = false
        saveButt.layer.cornerRadius = 55.0/2
    }
    
    func loadData() {
        if userInfo?.point != nil {
            self.pointsRankLb.text = "\(String(describing: (userInfo?.point)!)) points | \(DataMgr.shared.levels[(userInfo?.level)!])"
        }
        if userInfo?.avatarImgPath != "" {
            self.imageView.sd_setImage(with: URL(string: (userInfo?.avatarImgPath)!), placeholderImage: #imageLiteral(resourceName: "user"), options: [.refreshCached])
       
        } else {
            imageView.image = #imageLiteral(resourceName: "user")
        }
        userNameLb.text = UserDefaults.standard.string(forKey: "UserName") != "" ? UserDefaults.standard.string(forKey: "UserName") : "User"
        
        emailTxtField.text = UserDefaults.standard.string(forKey: "Email")
        userNameTxtField.text = UserDefaults.standard.string(forKey: "UserName") != "" ? UserDefaults.standard.string(forKey: "UserName") : "User"
        if UserDefaults.standard.string(forKey: "Phone") != "" {
            phoneTxtField.text = UserDefaults.standard.string(forKey: "Phone")
        } else {
            phoneTxtField.placeholder = "Mobile Phone"
        }
        if UserDefaults.standard.string(forKey: "Address") != "" {
            addressTxtField.text = UserDefaults.standard.string(forKey: "Address")
        } else {
            addressTxtField.placeholder = "Address"
        }
    }
    
    func postAvatar(data: Data, userID: String, token: String) {
        let URL = "https://lutserver.herokuapp.com/user/avatar/" + userID
        let request = try! URLRequest(url: URL, method: .put, headers: ["Content-Type": "application/x-www-form-urlencoded","Authorization": token])
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            let filename = "photo.jpeg"
            MultipartFormData.append(data, withName: "image", fileName: filename, mimeType: "image/jpeg")
        },
                         with: request,
                         encodingCompletion: { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    let value = response.result.value as! [String: Any]
                                    print(value)
                                    self.hideLoading()
                                    self.showSuccess()
                                    self.isUpdatedAvatar = true
                                }
                                
                            case .failure( _):
                                self.hideLoading()
                                self.showAlert(message: "Could not connect to server")
                            }
        })
    }
    
    func addUpdateAvatarObserver() {
        NotificationCenter.default.post(name: NSNotification.Name("AfterUpdateAvatar"), object: nil)
    }
    func showSuccess() {
        let alert = UIAlertController(title: "Notice", message: "Successfully updated information!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK functions to handle elements press
    
    @IBAction func historyPressed(_ sender: Any) {
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Chú ý!!!", message: "Bạn có chắc chắn muốn thay đổi thông tin?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: UIAlertActionStyle.default, handler: {action in
            self.showLoading()
            let token = UserDefaults.standard.string(forKey: "Token")
            let userID = UserDefaults.standard.string(forKey: "UserID")
            
            let param = ["nickname": self.userNameTxtField.text!,"phone": self.phoneTxtField.text!,"address": self.addressTxtField.text!]
            ServiceHelpers.updateUser(param: param, token: token!, userID: userID!, callback:
                {
                    (response) in
                    self.updateUserResponse = response
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        if isUpdatedAvatar {
            addUpdateAvatarObserver()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func avatarChange() {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        // Change Message With Color and Font
        let alertMsg  = "Choose your avatar"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: alertMsg as String, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(white: 34.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: alertMsg.characters.count))
        alert.setValue(myMutableString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: {
            action in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {
            action in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AccountViewController: UINavigationControllerDelegate {
    
}

extension AccountViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImage = pickedImage
            imageView.contentMode = .scaleAspectFill
            imageView.image = pickedImage
            imageView.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButt.isEnabled = true
        if textField == passwrdTxtField {
            self.isChangingPassword = true
            self.passwordChanged = true
            self.confirmPassTxtField.isHidden = false
            self.newPassTxtField.isHidden = false
            if UIScreen.main.bounds.width == 375 {
                self.saveButtConstraint.constant = 10.0
            }
            UIView.animate(withDuration: 0.75, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}




