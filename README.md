# Interaction Telemetry Lab: A Gamified A/B Testing Framework

## 🎯 Project Overview
This project is a gamified 2D research environment developed as part of my B.Sc. Engineering Thesis. It was designed to conduct **A/B testing** on human-computer interaction methods, specifically comparing **Drag-and-Drop** vs. **Point-and-Click** mechanics.

The primary objective was to measure the impact of these interaction styles on **short-term memory retention** and **cognitive load**, using a custom-built telemetry system to capture high-precision user data.

## 🚀 Key Features
* **Dual Interaction Modules:** Toggleable engine logic for comparing different UX interaction patterns within a controlled environment.
* **Custom Telemetry Engine:** A robust background logging system (GDScript) that captures real-time metrics, including:
    * Precise cursor trajectory and distance (pixels).
    * Interaction frequency and click-stream analysis.
    * Precise task completion duration.
* **Data Integrity & Export:** Automated data serialization for statistical analysis (compatible with Python/Excel/Power BI).
* **Modular Architecture:** Designed for scalability, allowing for easy integration of new levels, puzzles, or interaction types.

## 🛠️ Tech Stack
* **Engine:** Godot Engine 4.x
* **Language:** GDScript
* **Research Methodology:** A/B Testing, NASA-TLX (Cognitive Load Scale), Statistical Significance Testing.

## 📊 Research Outcomes
The framework successfully facilitated a study on 30 participants, leading to actionable insights:
* **+44.7% Relative Memory Lift** observed in the Drag-and-Drop group.
* **Significant reduction in cognitive load** (Mental Demand) validated through NASA-TLX metrics.
* Proven independence of results from time-on-task through **Pearson correlation analysis**.

---
*Developed as a Bachelor of Science Engineering Project.*
