import UIKit
import RealityKit
import ARKit

final class ARViewController: UIViewController {

    private let arView: ARView = {
        let view = ARView()
        return view
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(arView)
        arView.session.delegate = self
        setupARView()

        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
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
}
