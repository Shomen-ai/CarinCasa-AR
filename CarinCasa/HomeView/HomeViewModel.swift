//import Foundation
//
//final class HomeViewModle {
//
//    var sectionItems:
//    func getData() {
//        DispatchQueue.main.async {
//            APIManager.shared.fetchData { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let product):
//                    self.sectionItems = product
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//    }
//}
//
