import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var handleButtons: [UIButton]!
    
    @IBOutlet weak var bottomRectangle: UIView!
    @IBOutlet weak var topRectangle: UIView!
    
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
}





