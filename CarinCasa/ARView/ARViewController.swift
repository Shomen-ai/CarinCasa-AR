import UIKit
import RealityKit
import ARKit

final class ARViewController: UIViewController {
    
    // MARK: - Properties
    
    private let arView: ARView = {
        let view = ARView()
        return view
    }()
    
    private var floorFound: Bool = false {
            didSet {
                if floorFound {
                    showFloorFoundAlert()
                }
            }
        }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(arView)
        arView.session.delegate = self
        setupARView()

        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    // MARK: - Methods
    private func showFloorFoundAlert() {
        let alertController = UIAlertController(title: "Пол найден", message: "Пол был успешно обнаружен.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupARView() {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arView)

        let results = arView.raycast(from: location,
                                     allowing: .estimatedPlane,
                                     alignment: .horizontal)

        if let firstResult = results.first {
            let anchor = ARAnchor(name: "Henry", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
        } else {
            print("Object placement faild - couldn't find a surface.")
        }
    }

    func placeObject(named entityName: String, for anchor: ARAnchor) {
//        do {
//            let entity = try ModelEntity.loadModel(named: entityName)
//
//            entity.generateCollisionShapes(recursive: true)
//            arView.installGestures([.rotation, .translation], for: entity)
//
//            let anchorEntity = AnchorEntity(anchor: anchor)
//            anchorEntity.addChild(entity)
//            arView.scene.addAnchor(anchorEntity)
//        } catch {
//            print("Model doesn't exsists")
//        }
    }
}

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchor.name == "Henry" {
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let raycast = arView.raycast(from: arView.center,
                                                    allowing: .estimatedPlane,
                                                    alignment: .horizontal)
        if let firstItemOfRaycast = raycast.first, !floorFound {
            floorFound = true
        }
    }
}
