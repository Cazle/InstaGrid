import UIKit

class ViewController: UIViewController {
    // Array of the 3 main button
    @IBOutlet var handleButtons: [UIButton]!
    
    //Array of all my pictures, empty or not.
    @IBOutlet var allPictures: [UIImageView]!
    
    //These two are only used for the isHidden syntax
    @IBOutlet weak var bottomRectangle: UIView!
    @IBOutlet weak var topRectangle: UIView!
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    @IBOutlet var firstLayout: [UIImageView]!
    @IBOutlet var secondLayout: [UIImageView]!
    @IBOutlet var thirdLayout: [UIImageView]!
    
    // Used for our pictures, to have a tag for both pictures and buttons pictures
    var selectedButton: UIButton?
    
    @IBOutlet weak var handleSwipe: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultButton()
        addingGesture()
        addingFonts()
    }
    
    func addingGesture() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeUp.direction = .up
        handleSwipe.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeft.direction = .left
        handleSwipe.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        if width < height, sender.direction == .up {
            swipingUp()
        } else if width > height, sender.direction == .left {
            swipingLeft()
        } else {
            print("Not valid")
        }
    }
    
    func swipingUp() {
        let height = UIScreen.main.bounds.height
        if checkFirstLayout() || checkSecondLayout() || checkThirdLayout() {
            print("Je suis en haut")
            UIView.animate(withDuration: 1, animations: {
                self.handleSwipe.transform = CGAffineTransform(translationX: 0, y: -height)
            }) { (success) in
                if success{
                    print("Le swipe haut est réussi")
                        self.sharingView()
                        self.resetPicturesWhenChangingLayout()
                    UIView.animate(withDuration: 0.9, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, animations: {
                        self.handleSwipe.transform = CGAffineTransform(translationX: 0, y: height)
                    })
                        self.handleSwipe.transform = .identity
                }
            }
        }
    }
    func swipingLeft() {
        let width = UIScreen.main.bounds.width
        if checkFirstLayout() || checkSecondLayout() || checkThirdLayout() {
            print("Je suis à gauche")
            UIView.animate(withDuration: 1, animations: {
                self.handleSwipe.transform = CGAffineTransform(translationX: -width, y: 0)
            }) { (succes) in
                if succes {
                    print("Le swipe gauche est réussi")
                    self.sharingView()
                    self.resetPicturesWhenChangingLayout()
                    UIView.animate(withDuration: 0.9, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, animations: {
                        self.handleSwipe.transform = CGAffineTransform(translationX: width, y: 0)
                    })
                    self.handleSwipe.transform = .identity
                }
                
            }
        }
    }
    func sharingView(){
        let image = handleSwipe.asImage()
        let imageToShare = [ image ]
        let activityController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        self.present(activityController, animated: true)
    }
    
    func checkFirstLayout() -> Bool {
        for picturesOfFirst in firstLayout {
            if picturesOfFirst.image == nil {
                print("First layout is not full")
                return false
            }
        }
        print("First layout is full")
        return true
    }
    
    func checkSecondLayout() -> Bool {
        for picturesOfSecond in secondLayout {
            if picturesOfSecond.image == nil {
                print("Second layout is not full")
                return false
            }
        }
        print("Second layout is full")
        return true
    }
    
    func checkThirdLayout() -> Bool {
        for picturesOfThird in thirdLayout {
            if picturesOfThird.image == nil {
                print("Third layout is not full")
                return false
            }
        }
        print("Third layout is full")
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            arrowImage.image = UIImage(named: "Arrow Up")
            swipeLabel.text = "Swipe up to share"
            addingFonts()
        } else {
            arrowImage.image = UIImage(named: "Arrow Left")
            swipeLabel.text = "Swipe left to share"
            addingFonts()
        }
    }
    
    func defaultButton(){
        let middleButton = handleButtons[1]
        middleButton.setImage(UIImage(named: "Selected"), for: .normal)
        bottomRectangle.isHidden = false
    }
    
    @IBAction func buttonIsSelected(_ sender: UIButton) {
        let selectedTag = sender.tag
        let imageSelected = UIImage(named: "Selected")
        
        for button in handleButtons {
            if button.tag == selectedTag {
                button.setImage(imageSelected, for: .normal)
                resetPicturesWhenChangingLayout()
            } else {
                button.setImage(nil, for: .normal)
            }
        }
        switch selectedTag {
        case 0:
            bottomRectangle.isHidden = true
            topRectangle.isHidden = false
        case 1:
            bottomRectangle.isHidden = false
            topRectangle.isHidden = true
        case 2:
            bottomRectangle.isHidden = true
            topRectangle.isHidden = true
        default:
            break
        }
    }
    
    @IBAction func TapImage(_ sender: UIButton) {
        selectedButton = sender
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
        
    func resetPicturesWhenChangingLayout() {
        for picture in allPictures{
            picture.image = nil
        }
    }
    func addingFonts(){
        if let font = UIFont(name: "Delm-Medium", size: 22){
            swipeLabel.font = font
        } else {
            swipeLabel.font = UIFont.systemFont(ofSize: 22)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            for picture in allPictures {
                if picture.tag == selectedButton?.tag {
                    picture.image = image
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
    }
}

        




