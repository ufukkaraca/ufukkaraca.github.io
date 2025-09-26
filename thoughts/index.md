---
layout: default
title: Thoughts
permalink: /thoughts/
---

<h1>Thoughts</h1>
<p>Short, systems-leaning notes. Subscribe via <a href="/thoughts/feed.xml">Atom feed</a>.</p>
<ul class="thoughts-list">
  {% assign thoughts_sorted = site.thoughts | sort: 'date' | reverse %}
  {% for thought in thoughts_sorted %}
    <li class="thoughts-item">
      <a href="{{ thought.url }}"><strong>{{ thought.title }}</strong></a>
      <small class="thoughts-item-meta">{{ thought.date | date: "%Y-%m-%d" }}</small>
      <div class="thoughts-item-note">{{ thought.excerpt | strip_html | truncate: 160 }}</div>
    </li>
  {% endfor %}
</ul>
