# 🧬 DNA Helix 3D Visualization

**An interactive, real-time 3D DNA helix visualization built with SwiftUI, SceneKit, and CoreMotion**

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-17.0+-brightgreen.svg)](https://developer.apple.com/ios/)
[![Framework](https://img.shields.io/badge/SwiftUI-Framework-blueviolet.svg)](https://developer.apple.com/xcode/swiftui/)
[![SceneKit](https://img.shields.io/badge/SceneKit-3D-blue.svg)](https://developer.apple.com/scenekit/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[Features](#-features) •
[Quick Start](#-quick-start) •
[Architecture](#-architecture) •
[Usage](#-usage) •
[Tech Stack](#-tech-stack)

---

## 📚 About

**DNAHelixView** is an immersive, scientifically-inspired 3D visualization of a DNA double helix. This iOS application combines cutting-edge SwiftUI interfaces with SceneKit's 3D rendering capabilities to create an interactive experience that responds to device motion and simulates real-time biological data.

Perfect for:
- 🎓 **Educational purposes** - Visualizing molecular biology concepts
- 🎨 **Creative coding** - Exploring 3D graphics and animations
- 🧪 **Scientific visualization** - Interactive data presentation
- 📱 **SwiftUI practice** - Learning advanced iOS development

---

## ✨ Features

### 3D Visualization
- 🧬 **Realistic DNA helix** - Accurate double helix structure with base pairs
- 💎 **40 base pairs** rendered with helical geometry
- 🌀 **3.5 helical turns** - True-to-life DNA structure
- ✨ **Glowing materials** - Emission-based lighting for biological feel
- 🎨 **Color-coded strands** - Cyan and teal differentiation

### Interactive Elements
- 📱 **Motion-responsive** - Tilts with device using CoreMotion
- 🫀 **Heartbeat synchronization** - Pulsing glow effect tied to simulated heart rate
- 🔄 **Continuous rotation** - Smooth automatic spinning
- 👆 **Touch-free interaction** - Responds to device orientation

### Real-Time Biological Metrics
- 💓 **Heart Rate Monitor** - Simulated BPM (68-78 range)
- 🫁 **Oxygen Level** - Dynamic O₂ saturation (97-99.5%)
- 🔬 **Cell Activity** - Animated activity percentage
- 📊 **Live Updates** - Metrics update every 2 seconds

### User Interface
- 🎛️ **Toggle metrics panel** - Show/hide biological data
- 💫 **Smooth animations** - Spring-based transitions
- 🌌 **Scientific background** - Animated particles and grid
- 📐 **Info chips** - Base pairs, helical turns, activity stats
- 🎪 **Material effects** - Glassmorphism and blur effects

---

## 🚀 Quick Start

### Prerequisites

- **Xcode 16.2+**
- **iOS 17.0+** deployment target
- **iPhone or iPad** with gyroscope (for motion features)

### Installation

```bash
# Clone the repository
git clone https://github.com/whispem/DNAHelixView
cd DNAHelixView

# Open in Xcode
open DNAHelixView.xcodeproj
```

### Running the App

1. Select your target device (iPhone/iPad simulator or physical device)
2. Press `Cmd+R` or click the "Run" button
3. For best experience, use a physical device to enable motion features

---

## 💻 Usage

### Interacting with the DNA Helix

**Device Motion:**
- Tilt your device left/right to rotate the helix along the Z-axis
- Tilt forward/backward to adjust the X-axis rotation
- Smooth interpolation makes movements feel natural

**UI Controls:**
- Tap the **"Hide Metrics"** button to toggle the data panels
- Watch real-time updates to heart rate and oxygen levels
- Observe cell activity changes synchronized with rotation

**Visual Effects:**
- The helix continuously rotates automatically
- Glow intensity pulses with the simulated heartbeat
- Background particles drift to create depth
- Grid animates to enhance the scientific atmosphere

---

## 🏗️ Architecture

### Component Structure

```
┌────────────────────────────────────────┐
│          DNAHelixView (Root)           │
│         SwiftUI Main Container         │
└──────────┬─────────────────────────────┘
           │
    ┌──────┴──────┬──────────────┬────────────────┐
    │             │              │                │
    ▼             ▼              ▼                ▼
┌────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐
│Scientific│ │DNA3DScene│ │Biological│ │  Info Chips  │
│Background│ │   View   │ │  Metrics │ │  & Controls  │
└────────┘  └──────────┘  └──────────┘  └──────────────┘
                 │
                 ▼
        ┌────────────────┐
        │   SceneKit     │
        │  3D Renderer   │
        └────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌─────────────┐    ┌─────────────┐
│ DNA Helix   │    │  Lighting   │
│  Geometry   │    │   Setup     │
└─────────────┘    └─────────────┘
```

### Key Components

**DNAHelixView.swift**
- Main SwiftUI view
- Manages animation state
- Coordinates all subviews
- Handles biological simulation

**DNA3DSceneView**
- `UIViewRepresentable` wrapper for SceneKit
- Creates and manages 3D scene
- Handles lighting setup
- Updates materials with heartbeat

**MotionManager**
- ObservableObject for CoreMotion data
- Provides tilt X/Y values
- Smooth animation updates

**ScientificBackground**
- Animated particle system
- Dynamic grid rendering
- Gradient effects

**BiologicalMetricPanel**
- Displays heart rate and oxygen
- Pulsing animations
- Glassmorphic design

---

## 🎨 Visual Design

### 3D Helix Construction

**Strand Spheres:**
```swift
- 120 spheres total (40 base pairs × 3 per side)
- Radius: 0.08 units
- Cyan emission glow
- Metallic material (0.8 metalness)
```

**Base Pair Connections:**
```swift
- 40 cylindrical connectors
- Radius: 0.04 units
- Blue emission with transparency
- Connects opposite strands
```

**Nucleotides:**
```swift
- 80 smaller spheres (0.15 radius)
- Cyan/mint color coding
- Enhanced glow effect
```

### Lighting Setup

The scene uses a sophisticated **4-light setup**:

1. **Ambient Light** - Low-intensity base illumination (10%)
2. **Key Light** - Cyan directional (1500 intensity) from top-right
3. **Fill Light** - Mint directional (1000 intensity) from left
4. **Rim Light** - Blue directional (800 intensity) from behind
5. **Spotlight** - White focused light (2000 intensity) from above

This creates depth, highlights the helix structure, and emphasizes the biological theme.

---

## ⚙️ Technical Details

### Performance Optimizations

- **Instancing** - Reuses geometry for spheres
- **Material Batching** - Efficient shader execution
- **Smooth Updates** - 60 FPS target with 0.016s timer
- **Lazy Loading** - Components load on demand
- **Antialiasing** - 4x multisampling for smooth edges

### Animation System

**Rotation:**
```swift
rotationAngle += 0.01  // ~0.6 degrees per frame
```

**Heartbeat:**
```swift
heartbeat = (sin(pulsePhase) + 1) / 2 * 0.6 + 0.4
// Range: 0.4 to 1.0, sine wave pattern
```

**Cell Activity:**
```swift
cellActivity = (sin(rotation * 5) + 1) / 2 * 0.4 + 0.6
// Range: 0.6 to 1.0, tied to rotation
```

---

## 📱 Tech Stack

### Frameworks

- **SwiftUI** - Modern declarative UI framework
- **SceneKit** - 3D rendering and graphics
- **CoreMotion** - Device motion and orientation
- **Combine** - Reactive programming for state management

### Design Patterns

- **MVVM** - Separation of view and logic
- **ObservableObject** - Reactive state management
- **UIViewRepresentable** - UIKit integration bridge
- **Coordinator** - Managing SceneKit references

### Swift Features

- **Property Wrappers** - @State, @StateObject, @Binding
- **Async/Await** - Timer publishers
- **Generics** - Type-safe components
- **Protocol-Oriented** - UIViewRepresentable conformance

---

## 🎓 Learning Outcomes

### Skills Demonstrated

**3D Graphics:**
- SceneKit scene setup and management
- Geometric primitive creation
- Material and lighting design
- Camera positioning and control

**iOS Development:**
- SwiftUI view composition
- CoreMotion sensor integration
- Animation and transitions
- Performance optimization

**UI/UX Design:**
- Glassmorphism effects
- Scientific visualization
- Interactive data display
- Motion-based interaction

**Mathematics:**
- Helical parametric equations
- Sine/cosine for circular motion
- Vector math for 3D positioning
- Interpolation for smooth movement

---

## 🗺️ Potential Enhancements

### Future Features

**Interaction:**
- [ ] Pinch to zoom
- [ ] Pan to rotate manually
- [ ] Tap base pairs for information
- [ ] Speed control slider

**Visualization:**
- [ ] DNA sequence display (A, T, C, G)
- [ ] Unzipping animation
- [ ] Replication visualization
- [ ] Transcription process

**Data:**
- [ ] Real heart rate from HealthKit
- [ ] Custom sequence input
- [ ] Educational mode with labels
- [ ] Export 3D model

**Effects:**
- [ ] Particle system for cells
- [ ] Environmental effects
- [ ] Multiple color schemes
- [ ] Audio feedback

---

## 🤔 Design Decisions

### Why SceneKit Over Metal?

**SceneKit Advantages:**
- Higher-level API (faster development)
- Built-in lighting and materials
- Easier camera management
- Perfect for educational projects

For production apps requiring maximum performance, Metal would be the better choice.

### Why CoreMotion?

Device motion creates an intuitive, immersive interaction:
- No touch required
- Natural exploration of 3D space
- Engaging user experience
- Showcases iOS capabilities

### Why Simulated Data?

Real biological sensors aren't available on iOS:
- Demonstrates data visualization patterns
- Safe for testing and development
- Consistent behavior for screenshots
- Could be replaced with real APIs

---

## 📚 Resources

### Learning Materials

**SwiftUI:**
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui) by Apple
- [Hacking with Swift](https://www.hackingwithswift.com/books/ios-swiftui)

**SceneKit:**
- [SceneKit Documentation](https://developer.apple.com/documentation/scenekit)
- [3D Graphics with SceneKit](https://www.raywenderlich.com/books/3d-apple-games-by-tutorials)

**CoreMotion:**
- [CoreMotion Framework](https://developer.apple.com/documentation/coremotion)
- [Motion Tracking Guide](https://developer.apple.com/documentation/coremotion/getting_processed_device-motion_data)

### Biology References

- DNA structure and geometry
- Base pair spacing (3.4 Å)
- Helical turn period (10 base pairs)
- Major and minor grooves

---

## 🤝 Contributing

This is a personal learning project, but suggestions are welcome!

### Ways to Contribute

- 🐛 **Report bugs** - Found an issue? Open a report
- 💡 **Suggest features** - Ideas for improvements
- 📖 **Improve documentation** - Clarify or expand
- 🎨 **Share variations** - Fork and experiment!

---

## 📜 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

---

## 👤 Author

**Em' ([@whispem](https://github.com/whispem))**

From literature & languages to interactive visualizations. This project combines my interests in science, design, and creative coding to create an immersive learning experience.

**Background:**
- Apple Foundation Program graduate
- Swift Certified
- UI/UX enthusiast
- Scientific visualization explorer

> *"Code is the most beautiful way to bring ideas to life."*

---

## 🌟 Part of My Portfolio

This project showcases:

**Swift & iOS:**
- Advanced SwiftUI patterns
- SceneKit 3D graphics
- CoreMotion integration
- Performance optimization

**Design Skills:**
- Modern UI/UX principles
- Animation and transitions
- Visual effects and materials
- Scientific data presentation

**Creative Coding:**
- Mathematical visualizations
- Interactive experiences
- Real-time graphics
- Immersive interfaces

Check out my other projects:
- [Mini KVStore v2](https://github.com/whispem/mini-kvstore-v2) - Rust storage engine
- [Tiny Log-KV](https://github.com/whispem/tiny-log-kv) - Append-only database
- [CSV-KV Store](https://github.com/whispem/CSV-Key-Value-Store) - Learning persistence

---

## 📬 Contact

- 🐛 **Issues:** [GitHub Issues](https://github.com/whispem/DNAHelixView/issues)
- 💼 **LinkedIn:** [@whispem](https://www.linkedin.com/in/emilie-peretti/)
- 📧 **Email:** contact.whispem@gmail.com

---

✨ **Built with ❤️ by Em'**

[⬆ Back to Top](#-dna-helix-3d-visualization)
