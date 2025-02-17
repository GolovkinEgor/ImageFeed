
import UIKit
class AlertPresenter{
     weak var delegate : UIViewController?
    
    func showErrorAlert(title:String,message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
       
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        delegate?.present(alertController, animated: true)
    }
    
}
