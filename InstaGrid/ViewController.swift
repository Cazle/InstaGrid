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
    
    // Used for our pictures, to have a tag for both pictures and buttons pictures
    var selectedButton: UIButton?
    
    @IBOutlet weak var handleSwipe: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultButton()
        addingGesture()
    }
    
    func addingGesture(){
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeUp.direction = .up
        handleSwipe.addGestureRecognizer(swipeUp)
        print(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeft.direction = .left
        handleSwipe.addGestureRecognizer(swipeLeft)
        print(swipeLeft)
    }
    
    
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isPortrait && sender.direction == .up {
            print(sender.direction)
            swipingUp()
        } else if UIDevice.current.orientation.isLandscape && sender.direction == .left {
            print(sender.direction)
            swipingLeft()
        }
    }
    func swipingUp(){
        print("Je suis en haut")
    }
    func swipingLeft(){
        print("Je suis à gauche")
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
        
        for button in handleButtons{
            if button.tag == selectedTag{
                button.setImage(imageSelected, for: .normal)
                resetPicturesWhenChangingLayout()
            } else {
                button.setImage(nil, for: .normal)
            }
        }
        switch selectedTag{
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




