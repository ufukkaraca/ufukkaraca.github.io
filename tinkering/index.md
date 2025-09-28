---
layout: default
title: Tinkering
permalink: /tinkering/
description: Active and past exploratory engineering threads.
---
<section class="container" style="padding-block:var(--space-6);">
 <h1 style="margin-top:0;">Tinkering</h1>
 <p class="muted" style="max-width:62ch;margin-top:-8px;">Lightweight exploration threads, instrumentation spikes & architectural probes. These often feed into more formal project work once validated.</p>
 {% assign tinkers_sorted = site.tinkers | sort: 'date' | reverse %}
 <ul class="tinker-timeline" style="margin-top:var(--space-5);">
  {% if tinkers_sorted and tinkers_sorted.size > 0 %}
   {% for t in tinkers_sorted %}
   <li class="tinker-item">
    <span class="tinker-meta">{{ t.date | date: '%Y-%m' }}</span>
    <span class="tinker-title"><a class="muted-link" href="{{ t.url }}" style="font-weight:600">{{ t.title }}</a></span>
    {% if t.summary %}<p class="muted" style="margin:4px 0 0 0;font-size:0.85rem;">{{ t.summary }}</p>{% endif %}
   </li>
   {% endfor %}
  {% else %}
   <li class="tinker-item"><span class="tinker-meta">Now</span><span class="tinker-title">No tinkers yet</span><p class="muted" style="margin:4px 0 0 0;font-size:0.85rem;">First entries coming soon.</p></li>
  {% endif %}
 </ul>
</section>
