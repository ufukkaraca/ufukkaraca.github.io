---
layout: default
title: Projects
permalink: /projects/
description: Representative initiatives, experiments, and historical builds.
---

<section class="container" style="padding-block:var(--space-6);">
  <h1 style="margin-top:0;">Projects</h1>
  <p class="muted" style="max-width:60ch;margin-top:-8px;">Mix of current focus items, enabling pipelines, and earlier experiments. Newer items surface systems framing & interface definition work; earlier entries show trajectory.</p>
  <ul class="list" style="margin-top:var(--space-5);">
    {% for item in site.data.projects %}
    <li class="card" data-tags="{% if item.tags %}{{ item.tags | join: ',' }}{% endif %}">
      <div class="card-row">
        <div class="card-title">{{ item.title }}</div>
        <div class="card-meta">{{ item.date }}</div>
      </div>
      <p class="card-desc clamp" data-clamp="3" id="proj-{{ forloop.index }}">{{ item.description }}</p>
      {% if item.tags %}
      <div class="tag-badges" aria-label="Tags">
        {% for tg in item.tags %}<span class="tag-badge" data-tag="{{ tg }}">{{ tg }}</span>{% endfor %}
      </div>
      {% endif %}
      <div style="display:flex;gap:var(--space-3);align-items:center;flex-wrap:wrap;">
        {% if item.link_href %}<a class="arrow-link" href="{{ item.link_url }}">{{ item.link_text }}</a>{% endif %}
        <button class="expand-btn" data-expand data-target="proj-{{ forloop.index }}" aria-expanded="false" hidden>More</button>
      </div>
    </li>
    {% endfor %}
  </ul>
</section>
