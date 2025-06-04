<h1 align="center">Logicalc</h1>

![Logicalc Build](https://github.com/nthnn/QLBase/actions/workflows/qlbase_build.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE-MIT)
[![License: CERN](https://img.shields.io/badge/License-CERN_OHL_1.2-blue.svg)](LICENSE-CERN)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXX.svg)](https://doi.org/10.5281/zenodo.XXXXXX)
[![Last Commit](https://img.shields.io/github/last-commit/yourusername/Logicalc.svg?style=flat)](https://github.com/yourusername/Logicalc)
![GitHub repo size](https://img.shields.io/github/repo-size/yourusername/Logicalc?logo=git&label=Repo%20Size)

## 🧠 What is Logicalc?

**Logicalc** is an innovative educational mobile application designed to revolutionize how students learn digital logic concepts. By leveraging cutting-edge computer vision and graph algorithms, it provides seamless bidirectional conversions between fundamental logic gate representations:

- **Boolean Algebra Expressions ↔ Circuit Diagrams**  
  Instantly generate schematic diagrams from logic equations, or extract Boolean expressions from circuit images

- **Truth Tables ↔ Timing Diagrams**  
  Visualize signal behavior over time or generate comprehensive truth tables from either equations or diagrams

### Core Technology Integration
Logicalc combines state-of-the-art technologies to deliver accurate conversions:
1. **YOLOv9 Convolutional Neural Network**  
   - Real-time detection of logic gates in circuit diagrams
   - Precision: 97% | Recall: 95% | F1-Score: 96%
   - Trained on 4,532 annotated circuit images

2. **Sugiyama Graph Layout Algorithm**  
   - Hierarchical organization of circuit components
   - Minimizes edge crossings for optimal readability
   - Preserves logical flow from inputs to outputs

3. **Unified Processing Pipeline**  
   ```mermaid
   graph LR
       A[Boolean Expression] --> B[Syntax Parser]
       C[Circuit Image] --> D[YOLOv9 Detection]
       B --> E[Expression Tree]
       D --> F[Component Extraction]
       E --> G[Graph Construction]
       F --> G
       G --> H[Sugiyama Layout]
       H --> I[Output Generator]
       I --> J[Circuit Diagram]
       I --> K[Truth Table]
       I --> L[Timing Diagram]

Developed as a BSCS thesis project at EARIST Manila, it combines deep learning (YOLOv9) with the Sugiyama graph layout algorithm to enhance digital logic education.

### System Flowchart
![Logicalc System Flowchart](assets/system-flowchart.png)

## ✨ Key Features

### 🔄 Bidirectional Conversion
- **Equation → Diagram**: Generate circuit diagrams from Boolean expressions
- **Diagram → Equation**: Extract logic equations from circuit images
- **Truth Table ↔ Timing Diagram**: Visualize signal behavior over time

### 🧩 Supported Components
| Logic Gates | Connectors | Input/Output |
|-------------|------------|--------------|
| AND         | Junction   | Terminal     |
| OR          | Crossover  | Text Label   |
| NOT         | Wire       |              |
| NAND        |            |              |
| NOR         |            |              |
| XOR         |            |              |
| XNOR        |            |              |

### 📊 Performance Metrics
| Metric       | Initial | Final  | Improvement |
|--------------|---------|--------|-------------|
| **F1 Score** | 0.83    | 0.96   | +15.6%      |
| **Precision**| 0.85    | 0.97   | +14.1%      |
| **Recall**   | 0.80    | 0.95   | +18.7%      |
| **mAP@0.5** | 0.81    | 0.98   | +21.0%      |

## ⚙️ System Requirements

### 💻 Development Environment
```bash
# Hardware
- NVIDIA GPU (RTX 3080 recommended for training)
- Arduino UNO + SIM900 Shield (SMS OTP feature)

# Software
- Python 3.8+
- TensorFlow 2.15
- OpenCV 4.8
- PyTorch 1.13
- Android Studio (for mobile deployment)
