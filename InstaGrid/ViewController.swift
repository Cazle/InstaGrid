import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var handleButtons: [UIButton]!
    
    @IBOutlet var allPictures: [UIImageView]!
    
    @IBOutlet weak var bottomRectangle: UIView!
    @IBOutlet weak var topRectangle: UIView!
    
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultButton()
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
                resetPictureWhenChangingLayout()
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
    
    func resetPictureWhenChangingLayout(){
        for picture in allPictures{
            picture.image = nil
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            for picture in allPictures{
                if picture.tag == selectedButton?.tag{
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




