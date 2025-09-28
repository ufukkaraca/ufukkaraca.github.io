---
layout: default
title: Experience
permalink: /experience/
description: Professional background – roles, education, leadership & a quick skills snapshot.
---

<section class="container">
  <h1 style="margin-top:0;">Background & Experience</h1>
  <p class="muted" style="max-width:60ch;">A systems‑leaning path across HMI, embedded platforms, rapid prototyping, and sustainability‑flavored innovation work. Below is a concise roll‑up of roles, academic grounding, and leadership programs that shaped how I decompose and ship multi‑domain products.</p>

  <h2 style="margin-top:var(--space-5);">Roles</h2>
  <ul class="list" style="margin-top:var(--space-3);">
    {% for r in site.data.experience %}
    <li class="card" style="padding:var(--space-4);">
      <div class="card-row"><div class="card-title">{{ r.company }}</div><div class="card-meta">{{ r.dates }}</div></div>
      <p style="font-weight:600;margin:.25rem 0 0 0;">{{ r.role }}</p>
      <p style="margin:.5rem 0 0 0;">{{ r.description }}</p>
    </li>
    {% endfor %}
  </ul>

  <h2 style="margin-top:var(--space-6);">Education</h2>
  <ul class="list" style="margin-top:var(--space-3);">
    {% for e in site.data.education %}
    <li class="card" style="padding:var(--space-4);">
      <div class="card-row"><div class="card-title">{{ e.degree }}</div><div class="card-meta">{{ e.date }}</div></div>
      <p style="margin:.5rem 0 0 0;">{{ e.institution }}</p>
      {% if e.notes %}<p class="muted" style="margin:.5rem 0 0 0;font-size:.95rem;">{{ e.notes }}</p>{% endif %}
    </li>
    {% endfor %}
  </ul>

  <h2 style="margin-top:var(--space-6);">Leadership & Fellowships</h2>
  <ul class="list" style="margin-top:var(--space-3);">
    {% for l in site.data.leadership %}
    <li class="card" style="padding:var(--space-4);">
      <div class="card-row"><div class="card-title">{{ l.name }}</div><div class="card-meta">{{ l.dates | join: ', ' }}</div></div>
      <p style="font-weight:600;margin:.25rem 0 0 0;">{{ l.role }}</p>
      <p style="margin:.5rem 0 0 0;">{{ l.description }}</p>
    </li>
    {% endfor %}
  </ul>

  <h2 style="margin-top:var(--space-6);">Skills (snapshot)</h2>
  {% assign skills = site.data.skills %}
  <div style="display:grid;gap:var(--space-4);grid-template-columns:repeat(auto-fit,minmax(240px,1fr));margin-top:var(--space-3);">
    <div><h3 style="margin:0 0 var(--space-2);font-size:1rem;text-transform:uppercase;letter-spacing:.05em;color:var(--muted);">Languages</h3><ul style="list-style:none;padding:0;margin:0;">{% for l in skills.languages %}<li style="margin:2px 0;">{{ l }}</li>{% endfor %}</ul></div>
    <div><h3 style="margin:0 0 var(--space-2);font-size:1rem;text-transform:uppercase;letter-spacing:.05em;color:var(--muted);">Innovation & Systems</h3><ul style="list-style:none;padding:0;margin:0;">{% for i in skills.innovation_systems %}<li style="margin:2px 0;">{{ i }}</li>{% endfor %}</ul></div>
    <div><h3 style="margin:0 0 var(--space-2);font-size:1rem;text-transform:uppercase;letter-spacing:.05em;color:var(--muted);">Technical</h3><ul style="list-style:none;padding:0;margin:0;">{% for t in skills.technical %}<li style="margin:2px 0;">{{ t }}</li>{% endfor %}</ul></div>
    <div><h3 style="margin:0 0 var(--space-2);font-size:1rem;text-transform:uppercase;letter-spacing:.05em;color:var(--muted);">Certifications</h3><ul style="list-style:none;padding:0;margin:0;">{% for c in skills.certifications %}<li style="margin:2px 0;">{{ c }}</li>{% endfor %}</ul></div>
  </div>

  <h2 style="margin-top:var(--space-6);">Writing & Notes</h2>
  <p style="max-width:60ch;">Short architectural fragments and system notes live in the <a href="/thoughts/">thoughts section</a>. A few may grow into longer artifacts later.</p>

</section>
