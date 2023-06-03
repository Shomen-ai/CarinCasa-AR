import UIKit

class DropDownMenuViewController: UIViewController {
    
    let button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return view
    }()
    
    lazy var loadingView: ZXLoadingView = {
        let rect:CGRect = CGRect.init(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100)
        let view:ZXLoadingView = ZXLoadingView.init(frame:rect)
        view.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y-80)
        view.color = .none
        view.tintColor = UIColor.black
        view.lineWidth = 2.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        
        view.backgroundColor = .white
        self.view.addSubview(self.loadingView)
        self.loadingView.startAnimating()
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showMenu() {
        self.loadingView.stopAnimating()
    }
}
