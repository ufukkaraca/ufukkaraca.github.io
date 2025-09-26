---
layout: thought
title: "Failure telemetry affordances"
date: 2025-08-28
excerpt: Good failure data is an *affordance* that invites faster debugging.
---

I look for these in a system under active evolution:

1. A single clickable trace from external symptom → internal cause (logs + metrics + trace IDs aligned)
2. A dead-simple repro harness (curl snippet, CLI subcommand, make target)
3. A structured error taxonomy (machine-actionable codes, not just strings)
4. A blame-light postmortem template encouraging architectural follow-ups

Each missing affordance adds minutes or hours to every failure. Add them early while the system graph is still small.
