---
layout: default
title: Contact
permalink: /contact/
description: Contact channels and social links for Ufuk Karaca.
---

<section class="container" style="padding-block:var(--space-6);">
  <h1 style="margin-top:0;">Contact</h1>
  <p class="muted" style="max-width:60ch;margin-top:-8px;">Reach out for systems/platform engineering collaboration, rapid prototyping loops, interface framing discussions, or mentoring. I prefer concise context + the constraint or question you’re wrestling with.</p>

  <h2 class="section-heading" style="margin-top:var(--space-5);">Primary</h2>
  <p><a class="arrow-link" href="mailto:{{ site.data.contact.email }}">{{ site.data.contact.email }}</a></p>

  <h2 class="section-heading" style="margin-top:var(--space-5);">Social</h2>
  <ul class="list" style="--gap:var(--space-2);">
    {% for s in site.data.contact.socials %}
    <li class="card" style="padding:var(--space-3) var(--space-4);display:flex;justify-content:space-between;align-items:center;">
      <span style="text-transform:capitalize;">{{ s.name }}</span>
      <a class="arrow-link" href="{{ s.link }}">Open</a>
    </li>
    {% endfor %}
  </ul>

  <h2 class="section-heading" style="margin-top:var(--space-5);">Signal & Boundaries</h2>
  <p class="muted" style="max-width:60ch;">I respond quickest to clear problem framing. Cold outreach without context may be skipped. No recruiting blasts.</p>

  <p style="margin-top:var(--space-6);"><a class="arrow-link" href="/">← Back home</a></p>
</section>
