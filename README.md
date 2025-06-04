<p align="center">
    <img src="assets/logicalc-logo.png" width="220" />
    <h1 align="center">Logicalc</h1>
</p>

![Logicalc Build](https://github.com/yourusername/Logicalc/actions/workflows/build.yml/badge.svg)
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

```mermaid
graph LR
    A[User Input] --> B[Circuit Diagram]
    A --> C[Boolean Expression]
    B --> D[YOLOv9 Detection]
    C --> E[Expression Parser]
    D --> F[Component Extraction]
    E --> F
    F --> G[Graph Construction]
    G --> H[Sugiyama Layout]
    H --> I[Output Generation]
    I --> J[Circuit Diagram]
    I --> K[Truth Table]
    I --> L[Timing Diagram]
