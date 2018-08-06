//
//  ViewController.swift
//  UXARImageTracking
//
//  Created by Michael Nino Evensen on 05/08/2018.
//  Copyright © 2018 Michael Nino Evensen. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load reference images
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "ReferenceImages", bundle: Bundle.main) else {
            print("Error loading reference images.")
            return
        }
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        
        // Run the session from ARSCNView attached to the Storyboard (eg. sceneView).
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}


// MARK: ARSCNViewDelegate
/*
 The ARSCNView class provides the easiest way to create augmented reality experiences that blend virtual 3D content with a device camera view of the real world. When you run the view's provided ARSession object:
 The view automatically renders the live video feed from the device camera as the scene background.
 The world coordinate system of the view's SceneKit scene directly responds to the AR world coordinate system established by the session configuration.
 The view automatically moves its SceneKit camera to match the real-world movement of the device.
 */
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            // Create plane from ARImageAnchor
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height
            )
            
            // Set material
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
            
            // Create node
            let planeNode = SCNNode(geometry: plane)
            
            /*
                Planes in SceneKit are vertical by default so we need to rotate
                90 degrees to match planes in ARKit
             */
            planeNode.eulerAngles.x = -.pi / 2
//            planeNode.position.z = -Float(imageAnchor.referenceImage.physicalSize.height)
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
}
