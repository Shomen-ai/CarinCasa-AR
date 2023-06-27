import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
//        tabBarItem.imageInsets = UIEdgeInsets(top: -6, left: 0, bottom: 6, right: 0)
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: HomeViewController(viewModel: HomeViewModel()),
                image: UIImage(systemName: "house")
            ),
            generateVC(
                viewController: InfoViewController(viewModel: InfoViewModel()),
                image: UIImage(systemName: "person.crop.circle")
            )
        ]
    }
    
    private func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.image = image
        viewController.tabBarItem.title = nil
        return UINavigationController(rootViewController: viewController)
    }
    
    private func setTabBarAppearance() {
        let height: CGFloat = 100
        let roundLayer = CAShapeLayer()
        roundLayer.path = UIBezierPath(
            rect: CGRect(x: 0, y: -10, width: tabBar.frame.width, height: height)
        ).cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)


        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: -10, width: tabBar.frame.width, height: 2)
        gradientLayer.colors = ColorPalette.goldGradientDark.map {$0.cgColor}
        gradientLayer.locations = [0, 0.4, 0.86, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        tabBar.layer.addSublayer(gradientLayer)

        tabBar.itemWidth = tabBar.frame.width / 5
        tabBar.itemPositioning = .centered

        roundLayer.fillColor = UIColor.white.cgColor

        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.7242564444, green: 0.7242564444, blue: 0.7242564444, alpha: 1)
    }
}

