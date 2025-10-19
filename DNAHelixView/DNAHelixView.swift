//
//  DNAHelixView.swift
//  DNAHelixView
//
//  Created by Emilie on 19/10/2025.
//
import SwiftUI
import CoreMotion
import SceneKit

struct DNAHelixView: View {
    @StateObject private var motionManager = MotionManager()
    @State private var heartbeat: CGFloat = 0
    @State private var pulsePhase: CGFloat = 0
    @State private var bpm: Int = 72
    @State private var oxygenLevel: CGFloat = 98.5
    @State private var cellActivity: CGFloat = 0
    @State private var rotationAngle: Float = 0
    @State private var showMetrics: Bool = true
    
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ScientificBackground(
                heartbeat: heartbeat,
                cellActivity: cellActivity
            )
            DNA3DSceneView(
                rotationAngle: $rotationAngle,
                heartbeat: heartbeat,
                tiltX: motionManager.tiltX,
                tiltY: motionManager.tiltY
            )
            .ignoresSafeArea()
            VStack {
                HStack {
                    if showMetrics {
                        BiologicalMetricPanel(
                            icon: "waveform.path.ecg.rectangle.fill",
                            title: "Heart Rate",
                            value: "\(bpm) BPM",
                            color: .red,
                            isActive: true
                        )
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    if showMetrics {
                        BiologicalMetricPanel(
                            icon: "lungs.fill",
                            title: "Oxygen",
                            value: String(format: "%.1f%%", oxygenLevel),
                            color: .cyan,
                            isActive: oxygenLevel > 95
                        )
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showMetrics.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: showMetrics ? "eye.slash.fill" : "chart.bar.fill")
                                .font(.system(size: 12, weight: .semibold))
                            Text(showMetrics ? "Hide Metrics" : "Show Metrics")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.cyan.opacity(0.4), lineWidth: 1)
                                )
                        )
                        .shadow(color: .cyan.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 24)
                }
                .padding(.bottom, 12)
                if showMetrics {
                    VStack(spacing: 12) {
                        HStack(spacing: 20) {
                            InfoChip(
                                label: "Base Pairs",
                                value: "40",
                                icon: "link",
                                color: .blue
                            )
                            
                            InfoChip(
                                label: "Helical Turns",
                                value: "3.5",
                                icon: "rotate.3d",
                                color: .mint
                            )
                            
                            InfoChip(
                                label: "Cell Activity",
                                value: String(format: "%.0f%%", cellActivity * 100),
                                icon: "circle.hexagongrid.fill",
                                color: .purple
                            )
                        }
                        
                        Text("3D DNA Visualization • Real-time Biological Data")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.4))
                            .textCase(.uppercase)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.red.opacity(Double(heartbeat * 0.6)),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .blur(radius: 40)
                .allowsHitTesting(false)
        }
        .onReceive(timer) { _ in
            updateAnimation()
        }
        .onAppear {
            startBiologicalSimulation()
        }
    }
    func updateAnimation() {
        rotationAngle += 0.01
        pulsePhase += 0.1
        let heartbeatValue = (sin(pulsePhase) + 1) / 2
        heartbeat = heartbeatValue * 0.6 + 0.4
        cellActivity = (sin(Double(rotationAngle) * 5) + 1) / 2 * 0.4 + 0.6
    }
    
    func startBiologicalSimulation() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.5)) {
                bpm = Int.random(in: 68...78)
                oxygenLevel = CGFloat.random(in: 97.0...99.5)
            }
        }
    }
}
struct DNA3DSceneView: UIViewRepresentable {
    @Binding var rotationAngle: Float
    let heartbeat: CGFloat
    let tiltX: CGFloat
    let tiltY: CGFloat
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = false
        sceneView.antialiasingMode = .multisampling4X
        let scene = SCNScene()
        sceneView.scene = scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        cameraNode.camera?.fieldOfView = 60
        scene.rootNode.addChildNode(cameraNode)
        setupLighting(scene: scene)
        let dnaNode = createDNAHelix()
        dnaNode.name = "dna"
        scene.rootNode.addChildNode(dnaNode)
        context.coordinator.sceneView = sceneView
        context.coordinator.dnaNode = dnaNode
        
        return sceneView
    }
    
    func updateUIView(_ sceneView: SCNView, context: Context) {
        guard let dnaNode = context.coordinator.dnaNode else { return }
        dnaNode.eulerAngles.y = rotationAngle
        dnaNode.eulerAngles.x = Float(tiltY) * 0.02
        dnaNode.eulerAngles.z = Float(tiltX) * 0.02

        updateMaterialsWithHeartbeat(node: dnaNode, heartbeat: heartbeat)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var sceneView: SCNView?
        var dnaNode: SCNNode?
    }
    func createDNAHelix() -> SCNNode {
        let helixNode = SCNNode()
        
        let height: Float = 12.0
        let radius: Float = 2.0
        let turns: Float = 3.5
        let basePairs = 40
        for i in 0..<basePairs * 3 {
            let progress = Float(i) / Float(basePairs * 3)
            let y = -height / 2 + progress * height
            let angle = progress * Float.pi * 2 * turns
            let leftSphere = createStrandSphere(color: .cyan, glowing: true)
            leftSphere.position = SCNVector3(
                cos(angle) * radius,
                y,
                sin(angle) * radius
            )
            helixNode.addChildNode(leftSphere)
            let rightSphere = createStrandSphere(color: .systemTeal, glowing: true)
            rightSphere.position = SCNVector3(
                cos(angle + Float.pi) * radius,
                y,
                sin(angle + Float.pi) * radius
            )
            helixNode.addChildNode(rightSphere)
        }
        for i in 0..<basePairs {
            let progress = Float(i) / Float(basePairs)
            let y = -height / 2 + progress * height
            let angle = progress * Float.pi * 2 * turns
            
            let leftPos = SCNVector3(cos(angle) * radius, y, sin(angle) * radius)
            let rightPos = SCNVector3(cos(angle + Float.pi) * radius, y, sin(angle + Float.pi) * radius)
            let connection = createBasePairConnection(from: leftPos, to: rightPos)
            helixNode.addChildNode(connection)
            let leftNucleotide = createNucleotide(color: .cyan, size: 0.15)
            leftNucleotide.position = leftPos
            helixNode.addChildNode(leftNucleotide)
            
            let rightNucleotide = createNucleotide(color: .systemMint, size: 0.15)
            rightNucleotide.position = rightPos
            helixNode.addChildNode(rightNucleotide)
        }
        
        return helixNode
    }
    
    func createStrandSphere(color: UIColor, glowing: Bool) -> SCNNode {
        let sphere = SCNSphere(radius: 0.08)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.emission.contents = glowing ? color.withAlphaComponent(0.6) : UIColor.clear
        material.specular.contents = UIColor.white
        material.shininess = 1.0
        material.metalness.contents = 0.8
        material.roughness.contents = 0.2
        sphere.materials = [material]
        
        let node = SCNNode(geometry: sphere)
        if glowing {
            let glowSphere = SCNSphere(radius: 0.12)
            let glowMaterial = SCNMaterial()
            glowMaterial.emission.contents = color.withAlphaComponent(0.3)
            glowMaterial.transparency = 0.3
            glowSphere.materials = [glowMaterial]
            let glowNode = SCNNode(geometry: glowSphere)
            node.addChildNode(glowNode)
        }
        
        return node
    }
    
    func createNucleotide(color: UIColor, size: CGFloat) -> SCNNode {
        let sphere = SCNSphere(radius: size)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.emission.contents = color.withAlphaComponent(0.8)
        material.specular.contents = UIColor.white
        material.shininess = 1.0
        material.metalness.contents = 0.9
        material.roughness.contents = 0.1
        sphere.materials = [material]
        
        let node = SCNNode(geometry: sphere)
        let glowSphere = SCNSphere(radius: size * 1.5)
        let glowMaterial = SCNMaterial()
        glowMaterial.emission.contents = color.withAlphaComponent(0.4)
        glowMaterial.transparency = 0.5
        glowSphere.materials = [glowMaterial]
        let glowNode = SCNNode(geometry: glowSphere)
        node.addChildNode(glowNode)
        
        return node
    }
    
    func createBasePairConnection(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let vector = SCNVector3(end.x - start.x, end.y - start.y, end.z - start.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        
        let cylinder = SCNCylinder(radius: 0.04, height: CGFloat(distance))
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemBlue.withAlphaComponent(0.8)
        material.emission.contents = UIColor.systemBlue.withAlphaComponent(0.3)
        material.specular.contents = UIColor.white
        material.transparency = 0.9
        material.metalness.contents = 0.7
        material.roughness.contents = 0.3
        cylinder.materials = [material]
        
        let node = SCNNode(geometry: cylinder)
        node.position = SCNVector3(
            (start.x + end.x) / 2,
            (start.y + end.y) / 2,
            (start.z + end.z) / 2
        )
        node.look(at: end, up: SCNVector3(0, 1, 0), localFront: SCNVector3(0, 1, 0))
        
        return node
    }
    
    func setupLighting(scene: SCNScene) {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.1, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        let keyLight = SCNNode()
        keyLight.light = SCNLight()
        keyLight.light?.type = .directional
        keyLight.light?.color = UIColor.cyan.withAlphaComponent(0.8)
        keyLight.light?.intensity = 1500
        keyLight.position = SCNVector3(x: 5, y: 10, z: 10)
        keyLight.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(keyLight)
        let fillLight = SCNNode()
        fillLight.light = SCNLight()
        fillLight.light?.type = .directional
        fillLight.light?.color = UIColor.systemMint.withAlphaComponent(0.6)
        fillLight.light?.intensity = 1000
        fillLight.position = SCNVector3(x: -5, y: 5, z: 10)
        fillLight.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(fillLight)
        let rimLight = SCNNode()
        rimLight.light = SCNLight()
        rimLight.light?.type = .directional
        rimLight.light?.color = UIColor.systemBlue.withAlphaComponent(0.7)
        rimLight.light?.intensity = 800
        rimLight.position = SCNVector3(x: 0, y: 0, z: -10)
        rimLight.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(rimLight)
        let spotlight = SCNNode()
        spotlight.light = SCNLight()
        spotlight.light?.type = .spot
        spotlight.light?.color = UIColor.white
        spotlight.light?.intensity = 2000
        spotlight.light?.spotInnerAngle = 30
        spotlight.light?.spotOuterAngle = 80
        spotlight.position = SCNVector3(x: 0, y: 15, z: 5)
        spotlight.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(spotlight)
    }
    func updateMaterialsWithHeartbeat(node: SCNNode, heartbeat: CGFloat) {
        let intensity = 0.3 + Double(heartbeat) * 0.7
        
        node.enumerateChildNodes { child, _ in
            guard let geometry = child.geometry else { return }
            
            for material in geometry.materials {
                if let emissionColor = material.emission.contents as? UIColor {
                    let baseColor = emissionColor.withAlphaComponent(1.0)
                    material.emission.contents = baseColor.withAlphaComponent(intensity * 0.8)
                }
            }
        }
    }
}
class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var tiltX: CGFloat = 0
    @Published var tiltY: CGFloat = 0
    
    init() {
        startMotionUpdates()
    }
    
    func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            withAnimation(.easeOut(duration: 0.2)) {
                self?.tiltX = CGFloat(motion.gravity.x) * 50
                self?.tiltY = CGFloat(motion.gravity.y) * -50
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
struct ScientificBackground: View {
    let heartbeat: CGFloat
    let cellActivity: CGFloat
    @State private var particleOffset: CGFloat = 0
    @State private var gridOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.01, green: 0.02, blue: 0.05),
                    Color(red: 0.02, green: 0.04, blue: 0.08),
                    Color(red: 0.03, green: 0.06, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Canvas { context, size in
                let spacing: CGFloat = 40
                
                for x in stride(from: 0, through: size.width, by: spacing) {
                    for y in stride(from: 0, through: size.height, by: spacing) {
                        let adjustedX = x + sin(gridOffset + y * 0.01) * 5
                        let adjustedY = y + cos(gridOffset + x * 0.01) * 5
                        
                        context.fill(
                            Circle().path(in: CGRect(
                                x: adjustedX,
                                y: adjustedY,
                                width: 2,
                                height: 2
                            )),
                            with: .color(.cyan.opacity(0.1))
                        )
                    }
                }
            }
            Canvas { context, size in
                for i in 0..<40 {
                    let x = (CGFloat(i) * size.width / 40 + particleOffset * 0.3).truncatingRemainder(dividingBy: size.width)
                    let y = (CGFloat(i * 17) + particleOffset + sin(CGFloat(i) * 0.5) * 30).truncatingRemainder(dividingBy: size.height)
                    let size = 3.0 + cellActivity * 2.0
                    let opacity = cellActivity * 0.4 + 0.2
                    
                    context.fill(
                        Circle().path(in: CGRect(x: x, y: y, width: size, height: size)),
                        with: .color(.mint.opacity(Double(opacity)))
                    )
                }
            }
            RadialGradient(
                colors: [
                    Color.red.opacity(Double(heartbeat * 0.05)),
                    Color.clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 400
            )
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                particleOffset = UIScreen.main.bounds.height
            }
            withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                gridOffset = .pi * 2
            }
        }
    }
}
struct BiologicalMetricPanel: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .symbolEffect(.pulse, isActive: isActive)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(color)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct InfoChip: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    DNAHelixView()
}
