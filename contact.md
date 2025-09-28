---
layout: default
title: Contact
permalink: /contact/
description: Contact channels and social links for Ufuk Karaca.
---

<section class="container" style="padding-block:var(--space-6);">
  <h1 style="margin-top:0;">Contact</h1>
  <p class="muted" style="max-width:60ch;margin-top:-8px;">Reach out for systems/platform engineering collaboration, rapid prototyping loops, interface framing discussions, or mentoring. I prefer concise context + the constraint or question you’re wrestling with.</p>

  <div class="contact-grid" style="margin-top:var(--space-5);display:grid;gap:var(--space-3);grid-template-columns:repeat(auto-fit,minmax(240px,1fr));">
    <div class="card" style="padding:var(--space-4);display:flex;flex-direction:column;gap:var(--space-2);">
      <span class="muted" style="text-transform:uppercase;letter-spacing:.06em;font-size:.7rem;font-weight:600;">email</span>
      <div>
        {% include email.html label="Email" class="arrow-link" %}
      </div>
    </div>
    {% for s in site.data.contact.socials %}
    <div class="card" style="padding:var(--space-4);display:flex;flex-direction:column;gap:var(--space-2);">
      <span class="muted" style="text-transform:uppercase;letter-spacing:.06em;font-size:.7rem;font-weight:600;">{{ s.name }}</span>
  <div><a class="arrow-link" href="{{ s.link }}">Open</a></div>
    </div>
    {% endfor %}
  </div>

</section>
