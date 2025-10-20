# 🧬 DNA Helix 3D Visualization

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-17.0-brightgreen.svg)](https://developer.apple.com/ios/)
[![Framework](https://img.shields.io/badge/SwiftUI-Framework-blueviolet.svg)](https://developer.apple.com/xcode/swiftui/)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)


**DNAHelixView** is an interactive, real-time 3D visualization of a DNA helix built in **SwiftUI** with **SceneKit** and **CoreMotion**. The project combines scientific visualization, UI/UX design, and real-time biological data simulation to create a dynamic and immersive experience.

---

## 🔹 Features

- **3D DNA Helix** with base pairs and helical turns
- **Real-time biological metrics** simulation:
  - Heart Rate (BPM)
  - Oxygen Level (%)
  - Cell Activity (%)
- **Interactive Scene**: Responds to device tilt via CoreMotion
- **Dynamic Lighting & Materials**: Pulsing glow effect synchronized with heartbeat
- **Custom Scientific Background**: Animated particles and gradient grid for a laboratory-inspired environment
- **Expandable UI Panels**: Toggle visibility for metrics and info chips
- Smooth and responsive **SwiftUI animations**

---

## 🎯 Key Components

- `DNAHelixView`: Main SwiftUI view combining 3D scene, background, and metrics panel
- `DNA3DSceneView`: `UIViewRepresentable` handling SceneKit 3D rendering
- `MotionManager`: Observes device motion for tilt-based interaction
- `ScientificBackground`: Animated particles and grid
- `BiologicalMetricPanel` & `InfoChip`: UI components for displaying live metrics and DNA info

---

## 🎨 Design & Tech Stack

- SwiftUI: Declarative UI framework
- SceneKit: 3D rendering engine for iOS
- CoreMotion: Device motion interaction
- Material & Gradient Effects: Realistic lighting and glow
- Animations: Pulsing heartbeat, rotating helix, particle effects

---

## ⚡ Usage

- Tilt your device to see the DNA helix respond in real-time
- Toggle metrics panel with the “Eye” button
- Observe simulated heart rate, oxygen level, and cell activity changing dynamically

---

## 👩🏻‍💻 About Me

Hi, I’m Emilie (Em’) 👋🏼  
I build experiences that combine code & design, exploring SwiftUI, UI/UX, and creative tech.  
I’m passionate about crafting interactive visualizations and pushing the boundaries of mobile applications.  

- Skills: Swift, SwiftUI, UI/UX, CoreMotion, SceneKit  
- Education: Apple Foundation Program, Swift Certification  
- Interests: Creative coding, scientific visualization, immersive app design  

---

## 📝 License

This project is open source under the MIT License. Feel free to explore, adapt, and create your own scientific visualizations!

---

✨ Built with ❤️ by Emilie (Em’)
