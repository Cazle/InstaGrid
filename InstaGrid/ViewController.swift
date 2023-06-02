import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftSelected: UIImageView!
    @IBOutlet weak var middleSelected: UIImageView!
    @IBOutlet weak var rightSelected: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSelectedButton()
    }
    
    enum Selected {
        case left
        case middle
        case right
    }
    
    func toggleSelected(_ selected: Selected) {
        switch selected{
        case .left:
            leftSelected.isHidden = false
            middleSelected.isHidden = true
            rightSelected.isHidden = true
        case .middle:
            leftSelected.isHidden = true
            middleSelected.isHidden = false
            rightSelected.isHidden = true
        case .right:
            leftSelected.isHidden = true
            middleSelected.isHidden = true
            rightSelected.isHidden = false
        }
    }
    
    func defaultSelectedButton() {
        toggleSelected(.middle)
    }
    
    @IBAction func handleLeftButton(_ sender: Any) {
        toggleSelected(.left)
    }
    
    @IBAction func handleMiddleButton(_ sender: Any) {
        toggleSelected(.middle)
    }
    
    @IBAction func handleRightButton(_ sender: Any) {
        toggleSelected(.right)
    }
}





