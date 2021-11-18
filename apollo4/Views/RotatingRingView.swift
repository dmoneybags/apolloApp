//
//  RotatingRingView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import SwiftUI
import SceneKit

struct ScenekitView : UIViewRepresentable {
    @Binding var yRotation : Float
    let scene = SCNScene(named: "Apollo 1 Ring.obj")!

    func makeUIView(context: Context) -> SCNView {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        // animate the 3d object
        ship.eulerAngles = SCNVector3(x: 0, y: self.yRotation * Float((Double.pi)/180.0) , z: 0)
        // retrieve the SCNView
        let scnView = SCNView()
        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        // show statistics such as fps and timing information
        scnView.showsStatistics = false
        // configure the view
        scnView.backgroundColor = UIColor.black
    }
}
struct RotatingRingView: View {
    @State private var yRotation: Float = 20
    var body: some View {
        ScenekitView(yRotation: $yRotation)
    }
}

struct RotatingRingView_Previews: PreviewProvider {
    static var previews: some View {
        RotatingRingView()
    }
}
