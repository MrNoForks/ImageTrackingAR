//
//  ModelLoader.swift
//  ImageTrackingAR
//
//  Created by Boppo on 17/04/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import ARKit

class ModelManipulator : SCNNode {
    
    static let shared = ModelManipulator()
    
    func getNodeFromDae(modelName : String?) -> SCNNode?{
        
        guard let virtualObjectScene = SCNScene(named : modelName ?? "") else {return nil}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes{
            wrapperNode.addChildNode(child)
        }
        wrapperNode.scale = SCNVector3(0.05, 0.05, 0.05)
        return wrapperNode
    }
    
    func loadModel(modelName : String,modelSize size : Float,appearanceAnimation : Bool = false,withDuration time : Double = 5,nodeToRemove : SCNNode){
        
        guard let virtualObjectScene = SCNScene(named: modelName) else {return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes{
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)

        self.scale = SCNVector3(x: size/2, y: size/2, z: size/2)
        
        if appearanceAnimation{
            let appearanceAction = SCNAction.scale(to: CGFloat(size), duration: time)
            
            appearanceAction.timingMode = .easeOut
            
            self.runAction(appearanceAction){
                nodeToRemove.removeFromParentNode()
            }
            
        }
        
    }
    
    

  
    func removeAllNodes(node : SCNNode){
        for child in node.childNodes{
            child.removeFromParentNode()
        }
    }
}
