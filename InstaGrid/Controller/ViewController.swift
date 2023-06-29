import UIKit

class ViewController: UIViewController {
    // Array of the 3 main button
    @IBOutlet var handleButtons: [UIButton]!
    
    //Array of all my pictures, empty or not.
    @IBOutlet var allPictures: [UIImageView]!
    
    //These two are only used for the isHidden syntax
    @IBOutlet weak var bottomRectangle: UIView!
    @IBOutlet weak var topRectangle: UIView!
    
    //They are used to change the image and the text depending on if the phone is on landscape or portrait
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    //Used to make a security and check if all the images are there before swiping
    @IBOutlet var firstLayout: [UIImageView]!
    @IBOutlet var secondLayout: [UIImageView]!
    @IBOutlet var thirdLayout: [UIImageView]!
    
    // Used for our pictures, to have a tag for both pictures and buttons pictures
    var selectedButton: UIButton?
    
    // The main view with all the pictures, it is used to make the swipe
    @IBOutlet weak var handleSwipe: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultButton()
        addingGesture()
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
        }
    }
    
    func swipingUp() {
        let height = UIScreen.main.bounds.height
        if checkLayout(layout: firstLayout) || checkLayout(layout: secondLayout) || checkLayout(layout: thirdLayout) {
            UIView.animate(withDuration: 1, animations: {
                self.handleSwipe.transform = CGAffineTransform(translationX: 0, y: -height)
            }) { (success) in
                if success{
                        self.sharingView()
                        self.resetPicturesWhenChangingLayout()
                    UIView.animate(withDuration: 0.9, animations: {
                        self.handleSwipe.transform = CGAffineTransform(translationX: 0, y: height)
                    })
                        self.handleSwipe.transform = .identity
                }
            }
        }
    }
    func swipingLeft() {
        let width = UIScreen.main.bounds.width
        if checkLayout(layout: firstLayout) || checkLayout(layout: secondLayout) || checkLayout(layout: thirdLayout) {
            UIView.animate(withDuration: 1, animations: {
                self.handleSwipe.transform = CGAffineTransform(translationX: -width, y: 0)
            }) { (succes) in
                if succes {
                    self.sharingView()
                    self.resetPicturesWhenChangingLayout()
                    UIView.animate(withDuration: 0.9, animations: {
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
        self.present(activityController, animated: true, completion: nil)
    }
    
    func checkLayout(layout: [UIImageView]) -> Bool {
        for picturesOfFirst in layout {
            if picturesOfFirst.image == nil {
                return false
            }
        }
        return true
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            arrowImage.image = UIImage(named: "Arrow Up")
            swipeLabel.text = "Swipe up to share"
        } else {
            arrowImage.image = UIImage(named: "Arrow Left")
            swipeLabel.text = "Swipe left to share"
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

        




