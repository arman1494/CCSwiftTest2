//
//  Object.swift
//  CCSwiftTest
//
//  Created by Satyar Mansouri on 9/19/20.
//  Copyright © 2020 oulu. All rights reserved.
//
// This class extract the 3D model from the source folder
import UIKit
import ARKit

class Object: SCNNode {
    
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "Source.scnassets/wateringcan.usdz") else{return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes
        {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
    }

}
