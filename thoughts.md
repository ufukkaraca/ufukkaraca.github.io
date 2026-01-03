---
layout: default
title: Blog
description: Short fragments and seeds for longer writing.
---

<section class="container" style="padding-block:var(--space-6);">
  <h1>Blog</h1>
  <p class="muted" style="margin-top:-8px;">Mini‑notes & architectural fragments. {% if journals and journals.size > 0  or technicals and technicals.size > 0 %}Toggle between views below.{% endif %}</p>

  {% if journals and journals.size > 0  or technicals and technicals.size > 0 %}
  <div class="view-toggle" role="tablist" aria-label="Blog content view" style="margin-top:var(--space-5);">
    <button class="view-tab is-active" role="tab" aria-selected="true" data-view="thoughts" id="tab-thoughts">Thoughts</button>
    {% if journals and journals.size > 0 %}
    <button class="view-tab" role="tab" aria-selected="false" data-view="journals" id="tab-journals">Journals</button>
    {% endif %}
    {% if technicals and technicals.size > 0 %}
    <button class="view-tab" role="tab" aria-selected="false" data-view="technicals" id="tab-technicals">Technicals</button>
    {% endif %}
  </div>
  {% endif %}


  {% comment %} Thoughts panel (default) {% endcomment %}
  {% assign thoughts_sorted = site.thoughts | sort:'date' | reverse %}
  <div id="thoughts-panel" role="tabpanel" aria-labelledby="tab-thoughts" class="blog-panel" style="margin-top:var(--space-5);">
    <ul class="thoughts-list">
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
  </div>

  {% comment %} Journals panel (uses `_journals` collection) {% endcomment %}
  {% assign journals = site.journals | if journals and journals.size > 0 sort: 'date' | reverse %}
  <div id="journals-panel" role="tabpanel" aria-labelledby="tab-journals" class="blog-panel" hidden style="margin-top:var(--space-5);">
    <h2 class="section-heading" style="margin-top:0;">Journals & tinkering</h2>
    <ul class="tinkers-list">
      {% if journals and journals.size > 0 %}
        {% for j in journals %}
        <li class="tinker-item">
          <time>{{ j.date | date: '%Y-%m-%d' }}</time>
          <a style="font-weight:600;" href="{{ j.url }}">{{ j.title }}</a>
          {% if j.summary %}<p style="margin:4px 0 0 0;font-size:0.95rem;">{{ j.summary }}</p>{% endif %}
        </li>
        {% endfor %}
      {% else %}
        <li class="tinker-item"><time>{{ 'now' | date: '%Y-%m-%d' }}</time><strong>No journal entries yet</strong><p style="margin:4px 0 0 0;font-size:0.95rem;">First entry coming soon.</p></li>
      {% endif %}
    </ul>
  </div>

  {% comment %} Technicals panel (uses `_technicals` collection) {% endcomment %}
  {% assign technicals = site.technicals | if technicals and technicals.size > 0 sort: 'date' | reverse %}
  <div id="technicals-panel" role="tabpanel" aria-labelledby="tab-technicals" class="blog-panel" hidden style="margin-top:var(--space-5);">
    <h2 class="section-heading" style="margin-top:0;">Technicals</h2>
    {% if technicals and technicals.size > 0 %}
      <ul class="technicals-list">
        {% for item in technicals %}
          <li>
            <time>{{ item.date | date: '%Y-%m-%d' }}</time>
            <a style="font-weight:600;" href="{{ item.url }}">{{ item.title }}</a>
            {% if item.excerpt %}
              <p style="margin:4px 0 0 0;font-size:0.95rem;">{{ item.excerpt | strip_html | truncate:140 }}</p>
            {% elsif item.summary %}
              <p style="margin:4px 0 0 0;font-size:0.95rem;">{{ item.summary }}</p>
            {% endif %}
          </li>
        {% endfor %}
      </ul>
    {% else %}
      <p class="muted">No technical posts found. Create `_technicals` collection items to include them here.</p>
    {% endif %}
  </div>
</section>
