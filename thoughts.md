---
layout: default
title: Thoughts
description: Short fragments and seeds for longer writing.
---

<section class="container" style="padding-block:var(--space-6);">
  <h1>Thoughts</h1>
  <p class="muted" style="margin-top:-8px;">Mini‑notes & architectural fragments. Some may grow into longer pieces.</p>
  {% assign thoughts_sorted = site.thoughts | sort:'date' | reverse %}
  <ul class="thoughts-list" style="margin-top:var(--space-5);">
  {% if thoughts_sorted and thoughts_sorted.size > 0 %}
    {% for thought in thoughts_sorted %}
    <li class="thoughts-item">
      <time>{{ thought.date | date: '%Y-%m-%d' }}</time>
      <a style="font-weight:600;" href="{{ thought.url }}">{{ thought.title }}</a>
      <p style="margin:4px 0 0 0;font-size:0.95rem;">{{ thought.excerpt | strip_html | truncate: 160 }}</p>
    </li>
    {% endfor %}
  {% else %}
  <li class="thoughts-item"><time>{{ 'now' | date: '%Y-%m-%d' }}</time><strong>No published thoughts yet</strong><p style="margin:4px 0 0 0;font-size:0.95rem;">First entry coming soon.</p></li>
  {% endif %}
  </ul>
</section>
