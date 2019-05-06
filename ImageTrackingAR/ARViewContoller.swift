//
//  ARViewContoller.swift
//  ImageTrackingAR
//
//  Created by Boppo on 17/04/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import UIKit
import ARKit
class ARViewContoller: UIViewController {

    private var sceneView : ARSCNView!
    
    private var virtualModelNode   = ModelManipulator.shared
    
    private var smokeyNode : SCNNode = {
        let particleNode = SCNNode()
        particleNode.addParticleSystem(SCNParticleSystem(named: "smkey", inDirectory: nil)!)
        particleNode.position = SCNVector3(x: -1, y: -0.5, z: 0)
        return particleNode
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
       
        sceneView = ARSCNView()
        
     //   sceneView.showsStatistics = true
        
       // sceneView.debugOptions = [.showWorldOrigin]
      
        sceneView.delegate = self
        
        
        
        view = sceneView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
   
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPhotos", bundle: nil) else {print("No images"); return}
        
        configuration.detectionImages = trackedImages
        
        configuration.maximumNumberOfTrackedImages = 0
        
        sceneView.session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
}


extension ARViewContoller : ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let imageAnchor = anchor as? ARImageAnchor{
          sceneView.scene.rootNode.addChildNode(smokeyNode)
        //    virtualModelNode = ModelManipulator.shared.getNodeFromDae(modelName: imageAnchor.referenceImage.name,scale: 0.05,introAnimation: true,withDuration: 2)
            ModelManipulator.shared.removeAllNodes(node: virtualModelNode)
          //  ModelManipulator.shared.removeAllNodes(node: sceneView.scene.rootNode)
            
            virtualModelNode.loadModel(modelName: imageAnchor.referenceImage.name!, modelSize: 0.05, appearanceAnimation: true, withDuration: 5,nodeToRemove: smokeyNode)
            
           // boxNode = createboxNode()
            virtualModelNode.position = SCNVector3(x: imageAnchor.transform.columns.3.x, y: imageAnchor.transform.columns.3.y, z: imageAnchor.transform.columns.3.z)
            

            sceneView.scene.rootNode.addChildNode(virtualModelNode)
            print("found model")
        }
        return nil
    }
    
    func distanceBetweenNodeAndCamera(){
        let virtualNodePosition = simd_distance(virtualModelNode.simdTransform.columns.3 , (sceneView.session.currentFrame?.camera.transform.columns.3)!)
        print("distance is \(virtualNodePosition)")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {

        
        guard let pointOfView = renderer.pointOfView else { return}
       
        
        let virtualNodePosition = simd_distance(virtualModelNode.simdTransform.columns.3 , (pointOfView.simdTransform.columns.3))
        print("distance is \(virtualNodePosition)")
        
        let transform = pointOfView.simdTransform
        let myPosInWorldSpace = simd_make_float4(0, 0, -2, 1)
        let myPosInCamSpace = simd_mul(transform,myPosInWorldSpace)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
       
        virtualModelNode.position = SCNVector3(x: myPosInCamSpace.x, y: myPosInCamSpace.y, z: myPosInCamSpace.z)
        SCNTransaction.commit()
    }
}
