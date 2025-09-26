---
layout: default
title: Tinkering
permalink: /tinkering/
---

<h1>Currently tinkering with</h1>
<p>Rotating set of explorations. Subscribe via <a href="/tinkering/feed.xml">Atom feed</a>.</p>
<ul class="tinker-timeline">
  {% assign tinkering_items = site.data.tinkering %}
  {% for t in tinkering_items %}
    <li class="tinker-item">
      <span class="tinker-meta">{{ t.when }}</span>
      <span class="tinker-title">{{ t.title }}</span>
      {% if t.note %}<div class="tinker-note">{{ t.note }}</div>{% endif %}
    </li>
  {% endfor %}
</ul>
