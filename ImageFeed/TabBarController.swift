import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active2"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
        
    }
}
