---
layout: default
title: Tinkering
description: Rolling log of small experiments and explorations.
---

<section class="container" style="padding-block:var(--space-6);">
  <h1>Tinkering log</h1>
  <p class="muted" style="margin-top:-8px;">Chronological list (edit <code>_data/tinkering.yaml</code>). Each entry: a lightweight breadcrumb of ongoing exploration.</p>
  <ul class="tinker-timeline" style="margin-top:var(--space-5);">
    {% assign tinkering_items = site.data.tinkering | default: nil %}
    {% if tinkering_items %}
      {% for t in tinkering_items %}
      <li class="tinker-item">
        <span class="tinker-meta">{{ t.when }}</span>
        <span class="tinker-title">{{ t.title }}</span>
        {% if t.note %}<p class="muted" style="margin:4px 0 0 0;font-size:0.95rem;">{{ t.note }}</p>{% endif %}
      </li>
      {% endfor %}
    {% else %}
      <li class="tinker-item"><span class="tinker-meta">Now</span><span class="tinker-title">No entries yet</span><p class="muted" style="margin:4px 0 0 0;font-size:0.95rem;">Add items to <code>_data/tinkering.yaml</code>.</p></li>
    {% endif %}
  </ul>
</section>
