import UIKit

class ViewController: UIViewController {
    // Array of the 3 main button
    @IBOutlet var handleButtons: [UIButton]!
    
    //Array of all my pictures, empty or not.
    @IBOutlet var allPictures: [UIImageView]!
    
    //These two are only used for the isHidden syntax
    @IBOutlet weak var bottomRectangle: UIView!
    @IBOutlet weak var topRectangle: UIView!
    
    // Used for our pictures, to have a tag for both pictures and buttons pictures
    var selectedButton: UIButton?
    
    @IBOutlet weak var handleSwipe: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultButton()
        
        let swipeUp = UISwipeGestureRecognizer()
        let swipeLeft = UISwipeGestureRecognizer()
        
        swipeLeft.direction = .left
        swipeUp.direction = .up
        
        handleSwipe.addGestureRecognizer(swipeUp)
        handleSwipe.addGestureRecognizer(swipeLeft)
        
        swipeUp.addTarget(self, action: #selector(swipe(sender:)))
        swipeLeft.addTarget(self, action: #selector(swipe(sender:)))
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer){
        
        switch sender.direction{
        case .up:
                print("Je suis en haut")
        case .left:
                print("Je suis à gauche")
        default :
            print("Not valid")
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
    
    @IBAction func testTapImage(_ sender: UIButton) {
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




