import UIKit

class TestViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PageViewCell.self, forCellWithReuseIdentifier: PageViewCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var items: [Furniture] = [] {
        didSet {
                DispatchQueue.main.async {
//                    self.loadingView.stopAnimating()
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .white
        setupConstraints()
        APIManager.shared.findOne(id: "3a5f79c3205fca2305773af28d41e3d6da823b25", completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let furniture):
                self.items.append(furniture)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    
    private func setupDelegateAndDataSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension TestViewController: UICollectionViewDelegateFlowLayout {
    
}

extension TestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5 + items[0].configurations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageViewCell.identifier,
                                                                for: indexPath) as? PageViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(imagesURL: items[0].images, name: items[0].name)
            return cell
        } else {
            return UICollectionViewCell()
        }
//        else if indexPath.row == 2 {
//
//        } else if indexPath.row == 3 {
//
//        } else if indexPath.row > 3 && indexPath.row <= sections[3].count {
//
//        } else if indexPath.row == (sections[3].count + 1) {
//
//        } else if indexPath.row == (sections[3].count + 2) {
//
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 1 {
            return CGSize(width: view.frame.width - 10, height: 250)
        } else {
            return CGSize(width: view.frame.width - 10, height: 50)
        }
    }
}
