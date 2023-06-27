import UIKit
import RealityKit
import ARKit

final class ARViewController: UIViewController {
    
    // MARK: - Properties
    
    private let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
    
    private let coachingOverlay: ARCoachingOverlayView = {
        let view = ARCoachingOverlayView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.goal = .horizontalPlane
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isModelPlaced = false
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupARView()
        view.addSubview(arView)
        coachingOverlay.session = arView.session
        view.addSubview(coachingOverlay)
        setupConstraints()
        arView.session.delegate = self
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    private func setupConstraints() {
        arView.translatesAutoresizingMaskIntoConstraints = false
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            coachingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: SetupLayout
    
    private func setupARView() {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
    }
    
    // MARK: Object placement
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arView)

        let results = arView.raycast(from: location,
                                     allowing: .existingPlaneInfinite,
                                     alignment: .horizontal)
        if !isModelPlaced {
            if let firstResult = results.first {
                let anchor = ARAnchor(name: "HENRY", transform: firstResult.worldTransform)
                arView.session.add(anchor: anchor)
                isModelPlaced = true
            } else {
                let alertController = UIAlertController(title: "Поверхность не найдена",
                                                        message: "Попробуйте проскниарвоать область побольше и/или включите свет", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor) {
        do {
            let entity = try ModelEntity.loadModel(named: entityName)
            entity.setScale(SIMD3<Float>(repeating: 0.005), relativeTo: nil)
            entity.generateCollisionShapes(recursive: true)
            arView.installGestures([.rotation, .translation, .scale], for: entity)

            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(entity)
            arView.scene.addAnchor(anchorEntity)
        } catch {
            let alertController = UIAlertController(title: "Ошибка",
                                                    message: "Модель не найдена", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchor.name == "HENRY" {
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}
