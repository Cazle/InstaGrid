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
        if checkFirstLayout() || checkSecondLayout() || checkThirdLayout() {
            print("Je suis en haut")
        }
    }
    func swipingLeft() {
        if checkFirstLayout() || checkSecondLayout() || checkThirdLayout() {
            print("Je suis à gauche")
        }
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




