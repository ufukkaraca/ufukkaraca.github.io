---
layout: thought
title: "Hardware latency as a first-class constraint"
date: 2025-09-05
excerpt: Treating physical latency budgets like P99 SLA changes the conversations.
---

A board trace length, a sensor debounce, a PCIe transaction boundary — these are latency budgets just as real as API tail latencies. The earlier they show up in design reviews *as explicit constraints*, the fewer rewrites you do later to 'make timing'.

My rule of thumb: if a physical propagation delay meaningfully affects an upper-layer retry/backoff policy, document it *in the same table* as your service SLOs. Force the merge of hardware + software mental models.
