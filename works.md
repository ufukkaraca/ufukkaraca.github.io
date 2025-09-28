---
layout: default
title: Works
permalink: /works/
description: Aggregate view of selected systems projects & active tinkering threads.
---

<section class="container" style="padding-block:var(--space-6);">
  <h1 style="margin-top:0;">Works</h1>
  <p class="muted" style="max-width:64ch;margin-top:-8px;">Snapshot of system‑leaning projects and current exploration threads. Toggle between <em style="font-style:normal;font-weight:600;">Projects</em> and <em style="font-style:normal;font-weight:600;">Tinkering</em>. Tag filters apply only to projects.</p>

  <div class="view-toggle" role="tablist" aria-label="Works content view" style="margin-top:var(--space-5);">
    <button class="view-tab is-active" role="tab" aria-selected="true" data-view="projects" id="tab-projects">Projects</button>
    <button class="view-tab" role="tab" aria-selected="false" data-view="tinkering" id="tab-tinkering">Tinkering</button>
  </div>

  {% assign all_projects = site.data.projects %}
  {% assign all_tags = '' | split: '' %}
  {% for p in all_projects %}
    {% if p.tags %}
      {% for t in p.tags %}
        {% unless all_tags contains t %}
          {% assign all_tags = all_tags | push: t %}
        {% endunless %}
      {% endfor %}
    {% endif %}
  {% endfor %}
  {% assign sorted_tags = all_tags | sort %}

  <div id="projects-panel" role="tabpanel" aria-labelledby="tab-projects" class="works-panel" style="margin-top:var(--space-5);">
    <h2 class="section-heading" style="margin-top:0;">Selected projects</h2>
    <div class="filter-toolbar" aria-label="Project tag filters">
      <button class="tag-filter is-active" data-filter="*" aria-pressed="true">All <span class="count" aria-hidden="true">({{ all_projects | size }})</span></button>
      {% for tag in sorted_tags %}
        {% assign tag_count = 0 %}
        {% for p in all_projects %}
          {% if p.tags and p.tags contains tag %}
            {% assign tag_count = tag_count | plus: 1 %}
          {% endif %}
        {% endfor %}
        <button class="tag-filter" data-filter="{{ tag }}" aria-pressed="false" aria-label="Filter projects by tag {{ tag }} ({{ tag_count }})">{{ tag }} <span class="count" aria-hidden="true">({{ tag_count }})</span></button>
      {% endfor %}
    </div>
    <ul class="list works-projects" id="works-projects" style="margin-top:var(--space-4);">
      {% for item in all_projects %}
      <li class="card work-item" data-tags="{% if item.tags %}{{ item.tags | join: ',' }}{% endif %}">
        <div class="card-row">
          <div class="card-title">{{ item.title }}</div>
          <div class="card-meta">{{ item.date }}</div>
        </div>
        <p class="card-desc clamp" data-clamp="3" id="work-proj-{{ forloop.index }}">{{ item.description }}</p>
        {% if item.tags %}
        <div class="tag-badges" aria-label="Tags">
          {% for tg in item.tags %}<span class="tag-badge" data-tag="{{ tg }}">{{ tg }}</span>{% endfor %}
        </div>
        {% endif %}
        <div style="display:flex;gap:var(--space-3);align-items:center;flex-wrap:wrap;">
          {% if item.link_href %}<a class="arrow-link" href="{{ item.link_url }}">{{ item.link_text }}</a>{% endif %}
          <button class="expand-btn" data-expand data-target="work-proj-{{ forloop.index }}" aria-expanded="false" hidden>More</button>
        </div>
      </li>
      {% endfor %}
    </ul>
    <p class="empty-note" id="projects-empty" style="display:none;margin-top:var(--space-4);">No projects match this tag.</p>
  </div>

  {% assign tinkers = site.tinkers | sort: 'date' | reverse %}
  {% assign tinker_years = '' | split: '' %}
  {% if tinkers and tinkers.size > 0 %}
    {% for tk in tinkers %}
      {% assign year = tk.date | date: '%Y' %}
      {% unless tinker_years contains year %}
        {% assign tinker_years = tinker_years | push: year %}
      {% endunless %}
    {% endfor %}
  {% endif %}
  {% assign sorted_tinker_years = tinker_years | sort | reverse %}
  <div id="tinkering-panel" role="tabpanel" aria-labelledby="tab-tinkering" class="works-panel" hidden style="margin-top:var(--space-5);">
    <h2 class="section-heading" style="margin-top:0;">Recent tinkering</h2>
    <div class="filter-toolbar" aria-label="Tinkering year filter">
  <button class="year-filter is-active" data-year="*" aria-pressed="true">All Time <span class="count" aria-hidden="true">({{ tinkers | size }})</span></button>
      {% for y in sorted_tinker_years %}
        {% assign year_count = 0 %}
        {% for tk in tinkers %}
          {% assign year = tk.date | date: '%Y' %}
          {% if year == y %}
            {% assign year_count = year_count | plus: 1 %}
          {% endif %}
        {% endfor %}
        <button class="year-filter" data-year="{{ y }}" aria-pressed="false" aria-label="Filter tinkering items by year {{ y }} ({{ year_count }})">{{ y }} <span class="count" aria-hidden="true">({{ year_count }})</span></button>
      {% endfor %}
    </div>
    <ul class="tinker-timeline" id="works-tinkering" style="margin-top:var(--space-4);">
      {% if tinkers and tinkers.size > 0 %}
        {% for t in tinkers %}
        <li class="tinker-item" data-year="{{ t.date | date: '%Y' }}" data-tags="tinker">
          <span class="tinker-meta">{{ t.date | date: '%Y-%m' }}</span>
          <span class="tinker-title"><a class="muted-link" href="{{ t.url }}" style="font-weight:600">{{ t.title }}</a></span>
          {% if t.summary %}<p class="muted" style="margin:4px 0 0 0;font-size:0.95rem;">{{ t.summary }}</p>{% endif %}
        </li>
        {% endfor %}
      {% else %}
        <li class="tinker-item"><span class="tinker-meta">Now</span><span class="tinker-title">No tinkers yet</span><p class="muted" style="margin:4px 0 0 0;font-size:0.95rem;">First entries coming soon.</p></li>
      {% endif %}
    </ul>
    <p class="empty-note" id="tinkering-empty" style="display:none;margin-top:var(--space-4);">No tinkering entries for that year.</p>
  <p style="margin-top:var(--space-3);"><a class="arrow-link" href="/works/#tinkering">All tinkering (anchor) →</a></p>
  </div>

</section>
