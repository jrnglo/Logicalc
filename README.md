<h1 align="center">Logicalc: Logic Gate Converter</h1>

[![Build Status](https://github.com/yourusername/Logicalc/actions/workflows/build.yml/badge.svg)](https://github.com/yourusername/Logicalc/actions)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE-MIT)
[![CERN OHL License](https://img.shields.io/badge/License-CERN_OHL_1.2-blue.svg)](LICENSE-CERN)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXX.svg)](https://doi.org/10.5281/zenodo.XXXXXX)
[![Repo Size](https://img.shields.io/github/repo-size/yourusername/Logicalc?logo=git)](https://github.com/yourusername/Logicalc)

## 🧠 What is Logicalc?

Logicalc is an educational mobile application that automates conversions between logic gate representations. It transforms between:
- **Boolean expressions ↔ Circuit diagrams**
- **Truth tables ↔ Timing diagrams**

Developed as a BSCS thesis project at EARIST Manila, it combines:
- **YOLOv9 CNN** for circuit component detection
- **Sugiyama algorithm** for hierarchical graph layout

### System Architecture
![Logicalc System Flowchart](assets/system-flowchart.png)

## ✨ Key Features
- **Equation → Diagram**: Generate circuit diagrams from Boolean expressions
- **Diagram → Equation**: Extract logic equations from circuit images
- **Truth Table ↔ Timing Diagram**: Visualize signal behavior
- **SMS OTP Verification**: Secure authentication via Arduino/SIM900

## ⚙️ System Requirements

### 💻 Development Environment
```bash
# Hardware
- NVIDIA RTX 3080 24GB GPU (training)
- Arduino UNO + SIM900 Shield (SMS)
- 16GB RAM minimum (32GB recommended)

# Software
- Python 3.8.10
- PyTorch 1.13.1+cu117
- OpenCV 4.8.1
- Android Studio 2022.3.1
- XAMPP 8.2.4 (local server)
