<h1 align="center">Logicalc</h1>

![Logicalc Build](https://github.com/nthnn/QLBase/actions/workflows/qlbase_build.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE-MIT)
[![License: CERN](https://img.shields.io/badge/License-CERN_OHL_1.2-blue.svg)](LICENSE-CERN)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXX.svg)](https://doi.org/10.5281/zenodo.XXXXXX)
[![Last Commit](https://img.shields.io/github/last-commit/yourusername/Logicalc.svg?style=flat)](https://github.com/yourusername/Logicalc)
![GitHub repo size](https://img.shields.io/github/repo-size/yourusername/Logicalc?logo=git&label=Repo%20Size)

## 🧠 What is Logicalc?

Logicalc is an educational mobile application that automates conversions between logic gate representations using computer vision and graph algorithms. It transforms between:
- **Boolean expressions ↔ Circuit diagrams**
- **Truth tables ↔ Timing diagrams**

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
