---
layout: thought
title: "Shaping experiments with invariants"
date: 2025-09-01
excerpt: Decide the invariants before you touch code; they become the guardrails for fast iteration.
---

When I sketch an experiment plan, I first write a small bulleted list:

- What *must not* change (data durability guarantees, protocol framing, external API signatures)
- What can be sloppy (internal naming, logging verbosity, performance)
- The kill condition (signal that tells me to stop the line)

Those invariants lower cognitive load: during iteration I don't keep re-litigating fundamentals. Speed goes up, risk stays bounded.
