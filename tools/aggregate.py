#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

"""Benchmark result aggregator and plotter for zlb with high-quality SVG output."""

import glob
import json
import os
import sys

import matplotlib.pyplot as plt


def get_color(name):
    """Return fixed identity colors for each language."""
    name = name.lower()
    if name.startswith("zig"):
        return "#f7a41d"  # Zig Orange
    if name.startswith("go"):
        return "#00add8"  # Go Cyan
    if "c_" in name:
        return "#555555"  # C Gray
    if name.startswith("rust"):
        return "#e06c75"  # Rust Pink
    if name.startswith("python"):
        return "#3776ab"  # Python Blue
    if name.startswith("bash"):
        return "#4eaa25"  # Bash Green
    return "#888888"


def calculate_metrics(task):
    """Calculate raw ratios and collect metrics from individual JSON files."""
    base_mean = None
    baseline_path = f"results/{task}_c_std_gcc.json"
    if os.path.exists(baseline_path):
        with open(baseline_path, "r") as f:
            base_mean = json.load(f)["results"][0]["mean"]

    if not base_mean:
        return []

    all_metrics = []
    for json_file in glob.glob(f"results/{task}_*.json"):
        with open(json_file, "r") as f:
            data = json.load(f)
            res = data["results"][0]
            raw_name = res["command"].split()[0].strip("./")
            label = raw_name.replace(f"{task}_", "")
            if "python3" in res["command"]:
                label = "python"
            if "bash" in res["command"]:
                label = "bash"

            raw_mean = res["mean"]
            mem_bytes = res.get("memory_usage_byte", [0])
            mem_mib = (
                (sum(mem_bytes) / len(mem_bytes)) / (1024 * 1024)
                if isinstance(mem_bytes, list)
                else mem_bytes / (1024 * 1024)
            )
            total_cpu = res.get("system", 0) + res.get("user", 0)
            overhead = (res.get("system", 0) / total_cpu) * 100 if total_cpu > 0 else 0

            all_metrics.append({"label": label, "ratio": raw_mean / base_mean, "memory": mem_mib, "overhead": overhead})
    return all_metrics


def save_plots(task, metrics):
    """Generate professional horizontal bar charts in SVG format."""
    if not metrics:
        return
    os.makedirs("results/plots", exist_ok=True)

    plt.rcParams.update(
        {
            "font.size": 10,
            "font.family": "sans-serif",
            "text.color": "#cccccc",
            "axes.labelcolor": "#cccccc",
            "xtick.color": "#cccccc",
            "ytick.color": "#cccccc",
        }
    )

    metrics.sort(key=lambda x: x["ratio"], reverse=True)
    labels = [m["label"] for m in metrics]
    ratios = [m["ratio"] for m in metrics]

    plt.figure(figsize=(12, 10), facecolor="#1a1b26")
    ax = plt.gca()
    ax.set_facecolor("#1a1b26")

    bars = plt.barh(labels, ratios, color=[get_color(label) for label in labels])
    plt.axvline(x=1.0, color="#ff4444", linestyle="--", alpha=0.8, label="GCC Baseline")

    plt.xscale("log")
    plt.xlabel("Relative Time Ratio (Lower is better, Log scale)")
    plt.title(f"ZLB PERFORMANCE: {task.upper()}", fontsize=16, fontweight="bold", pad=20)
    plt.grid(axis="x", which="both", linestyle=":", alpha=0.3)

    for bar in bars:
        width = bar.get_width()
        plt.text(
            width, bar.get_y() + bar.get_height() / 2, f" {width:.2f}x", va="center", fontsize=9, fontweight="bold"
        )

    plt.tight_layout()
    plt.savefig(f"results/plots/{task}_time.svg", format="svg", transparent=True)
    plt.close()

    metrics.sort(key=lambda x: x["memory"], reverse=True)
    labels_mem = [m["label"] for m in metrics]
    mems = [m["memory"] for m in metrics]

    plt.figure(figsize=(12, 10), facecolor="#1a1b26")
    ax = plt.gca()
    ax.set_facecolor("#1a1b26")

    bars = plt.barh(labels_mem, mems, color=[get_color(label) for label in labels_mem])
    plt.xlabel("Memory Usage (MiB)")
    plt.title(f"ZLB RESOURCE: {task.upper()} (Max RSS)", fontsize=16, fontweight="bold", pad=20)
    plt.grid(axis="x", linestyle=":", alpha=0.3)

    for bar in bars:
        width = bar.get_width()
        plt.text(
            width, bar.get_y() + bar.get_height() / 2, f" {width:.1f} ", va="center", fontsize=9, fontweight="bold"
        )

    plt.tight_layout()
    plt.savefig(f"results/plots/{task}_memory.svg", format="svg", transparent=True)
    plt.close()


def update_readme(file_path, summary_content):
    """Update the README file by injecting summary content between markers."""
    if not os.path.exists(file_path):
        return

    with open(file_path, "r") as f:
        content = f.read()

    content = content.replace(".png", ".svg")

    start_marker = "<!-- SUMMARY_START -->"
    end_marker = "<!-- SUMMARY_END -->"
    start_idx = content.find(start_marker)
    end_idx = content.find(end_marker)

    if start_idx != -1 and end_idx != -1:
        new_content = content[: start_idx + len(start_marker)] + "\n" + summary_content + "\n" + content[end_idx:]
        with open(file_path, "w") as f:
            f.write(new_content)


def main():
    """Main execution point."""
    tasks = ["mandel", "sieve", "btree"]
    os.makedirs("results/plots", exist_ok=True)
    overall_summary = ""

    for task in tasks:
        metrics = calculate_metrics(task)
        if not metrics:
            continue
        save_plots(task, metrics)

        task_summary = f"\n### {task.upper()} Results (Actual Measured)\n\n"
        task_summary += "| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |\n"
        task_summary += "| :--- | :--- | :--- | :--- |\n"
        for m in sorted(metrics, key=lambda x: x["ratio"]):
            task_summary += f"| {m['label']} | {m['ratio']:.2f}x | {m['memory']:.2f} | {m['overhead']:.1f}% |\n"
        overall_summary += task_summary
        sys.stdout.write(task_summary)

    update_readme("README.md", overall_summary)
    update_readme("README_ja.md", overall_summary)


if __name__ == "__main__":
    main()
