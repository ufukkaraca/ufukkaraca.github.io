---
layout: tinker
title: SwitchBot temporary access
date: 2026-01-01
summary: guest keys for smart home devices
---
During my world tour I was doing house swaps with people I didn't know — and needed to give them access to smart home devices for limited windows, with proper tracking of who did what. The normal flow is painful: you add them to your home, they download the app, sign up, and then you have to remember to remove them after. So I built a small system that generates time-limited access links for specific devices. Guests get a clean mobile-friendly page with no sign-up, you get an admin dashboard and usage stats. Runs on Node/Express with SQLite, deploys in one click to Railway. [Source on GitHub](https://github.com/ufukkaraca/switchbot-temporary-access).
