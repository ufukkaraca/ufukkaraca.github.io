document.addEventListener('DOMContentLoaded', function () {
    var header = document.querySelector('.site-header');
    var scrollCue = document.querySelector('[data-scroll-cue]');
    var hero = document.querySelector('[data-hero]');
    var afterHeroSections = hero ? Array.from(document.querySelectorAll('section:not(#home)')) : [];
    var heroHeight = 0;
    var onScroll = function () {
        if (!header) return;
        if (window.scrollY > 8) {
            header.classList.add('is-scrolled');
        } else {
            header.classList.remove('is-scrolled');
        }
    };
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });

    // Scroll cue hide logic
    function hideCueOnScroll() {
        if (!scrollCue) return;
        // Hide a bit later so cue remains visible during initial micro-scroll
        var threshold = 120; // px before hiding cue
        if (window.scrollY > threshold) {
            scrollCue.classList.add('is-hidden');
        } else {
            scrollCue.classList.remove('is-hidden');
        }
    }
    hideCueOnScroll();
    window.addEventListener('scroll', hideCueOnScroll, { passive: true });

    // Resize handling (debounced) to ensure hero fills viewport after orientation / chrome UI changes
    var resizeTimer = null;
    function adjustHeroHeight() {
        if (!hero) return;
        // Using CSS 100svh handles most mobile cases; fallback for older browsers
        hero.style.minHeight = '100svh';
        heroHeight = hero.getBoundingClientRect().height;
    }
    adjustHeroHeight();
    window.addEventListener('resize', function () {
        if (resizeTimer) cancelAnimationFrame(resizeTimer);
        resizeTimer = requestAnimationFrame(adjustHeroHeight);
    });

    // Subtle upward acceleration of following content while scrolling through hero
    function shiftAfterHero() {
        if (!heroHeight || !afterHeroSections.length) return;
        var y = window.scrollY;
        var progress = Math.min(Math.max(y / heroHeight, 0), 1); // 0 -> 1 across hero
        // Ease-out curve (quadratic) for smoother start
        var eased = 1 - Math.pow(1 - progress, 2);
        var maxShift = 112; // increased maximum upward additional shift
        var shift = Math.round(eased * maxShift);
        // Respect reduced motion preference
        var prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        afterHeroSections.forEach(function (sec) {
            sec.style.transform = prefersReduced ? '' : 'translateY(' + (-shift) + 'px)';
        });
    }
    shiftAfterHero();
    window.addEventListener('scroll', shiftAfterHero, { passive: true });
    window.addEventListener('resize', function () { requestAnimationFrame(shiftAfterHero); });

    var observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.15 });

    document.querySelectorAll('.reveal').forEach(function (el) {
        observer.observe(el);
    });

    /* Clamp expansion logic */
    function prepareClamp(el) {
        if (!el) return;
        // Create a mirror to check overflow
        var lineClamp = el.getAttribute('data-clamp');
        if (!lineClamp) return;
        // If scroll height exceeds client height, show button
        requestAnimationFrame(function () {
            if (el.scrollHeight > el.clientHeight + 4) {
                var btn = el.parentElement.querySelector('[data-expand]');
                if (btn) {
                    btn.hidden = false;
                    if (!btn.hasAttribute('aria-expanded')) btn.setAttribute('aria-expanded', 'false');
                    if (btn.hasAttribute('data-target')) {
                        var tid = btn.getAttribute('data-target');
                        if (tid) btn.setAttribute('aria-controls', tid);
                    }
                }
            }
        });
    }

    document.querySelectorAll('.clamp').forEach(prepareClamp);

    document.addEventListener('click', function (e) {
        var btn = e.target.closest('[data-expand]');
        if (!btn) return;
        var targetId = btn.getAttribute('data-target');
        var target = targetId ? document.getElementById(targetId) : btn.parentElement.querySelector('.clamp');
        if (!target) return;
        var expanded = target.classList.toggle('is-expanded');
        if (expanded) {
            btn.textContent = 'Less';
            btn.setAttribute('aria-expanded', 'true');
        } else {
            btn.textContent = 'More';
            btn.setAttribute('aria-expanded', 'false');
        }
    });

    /* TODO (Streams Disabled): X + Goodreads embed loader code removed. Restore from git history when re‑enabling. */

    // Works page: view toggle (projects / tinkering) + tag filtering
    var viewTabs = document.querySelectorAll('.view-tab');
    if (viewTabs.length) {
        var projectsPanel = document.getElementById('projects-panel');
        var tinkeringPanel = document.getElementById('tinkering-panel');
        var filterToolbar = projectsPanel ? projectsPanel.querySelector('.filter-toolbar') : null;
        var filterButtons = filterToolbar ? Array.from(filterToolbar.querySelectorAll('.tag-filter')) : [];
        var tinkeringYearToolbar = document.querySelector('#tinkering-panel .filter-toolbar');
        var yearButtons = tinkeringYearToolbar ? Array.from(tinkeringYearToolbar.querySelectorAll('.year-filter')) : [];
        var projectItems = Array.from(document.querySelectorAll('#works-projects .work-item'));

        function applyFilter(tag) {
            var shown = 0;
            projectItems.forEach(function (el) {
                var tags = (el.getAttribute('data-tags') || '').split(',').filter(Boolean);
                var show = tag === '*' || tags.includes(tag);
                el.style.display = show ? '' : 'none';
                if (show) shown++;
            });
            var empty = document.getElementById('projects-empty');
            if (empty) empty.style.display = shown === 0 ? '' : 'none';
        }

        function switchView(view) {
            var isProjects = view === 'projects';
            projectsPanel.hidden = !isProjects;
            tinkeringPanel.hidden = isProjects;
            viewTabs.forEach(function (t) {
                var active = t.getAttribute('data-view') === view;
                t.classList.toggle('is-active', active);
                t.setAttribute('aria-selected', active ? 'true' : 'false');
                if (active) t.focus({ preventScroll: true });
            });
            // Update hash without scrolling jump
            if (view === 'tinkering') {
                history.replaceState(null, '', '#tinkering');
            } else if (location.hash === '#tinkering') {
                history.replaceState(null, '', '#');
            }
            try { localStorage.setItem('works:view', view); } catch (e) { }
        }

        viewTabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                var v = tab.getAttribute('data-view');
                switchView(v);
            });
            tab.addEventListener('keydown', function (e) { // basic arrow key nav
                if (![37, 39].includes(e.keyCode)) return; // left/right
                var tabs = Array.from(viewTabs);
                var idx = tabs.indexOf(tab);
                idx = e.keyCode === 37 ? (idx - 1 + tabs.length) % tabs.length : (idx + 1) % tabs.length;
                tabs[idx].click();
            });
        });

        // Initial selection (hash > persisted > default)
        var persistedView = null;
        try { persistedView = localStorage.getItem('works:view'); } catch (e) { }
        if (location.hash === '#tinkering') {
            switchView('tinkering');
        } else if (persistedView && ['projects', 'tinkering'].includes(persistedView)) {
            switchView(persistedView);
        }

        if (filterToolbar) {
            filterToolbar.addEventListener('click', function (e) {
                var btn = e.target.closest('.tag-filter');
                if (!btn) return;
                var tag = btn.getAttribute('data-filter');
                filterButtons.forEach(function (b) { b.classList.remove('is-active'); b.setAttribute('aria-pressed', 'false'); });
                btn.classList.add('is-active');
                btn.setAttribute('aria-pressed', 'true');
                applyFilter(tag);
                try { localStorage.setItem('works:tag', tag); } catch (e) { }
            });
            // apply persisted tag filter
            var persistedTag = null; try { persistedTag = localStorage.getItem('works:tag'); } catch (e) { }
            if (persistedTag && persistedTag !== '*') {
                var match = filterButtons.find(function (b) { return b.getAttribute('data-filter') === persistedTag; });
                if (match) {
                    match.click();
                }
            } else {
                applyFilter('*');
            }
        }

        if (tinkeringYearToolbar) {
            var tinkerItems = Array.from(document.querySelectorAll('#works-tinkering .tinker-item'));
            function applyYear(year) {
                var shown = 0;
                tinkerItems.forEach(function (el) {
                    var y = el.getAttribute('data-year');
                    var show = year === '*' || y === year;
                    el.style.display = show ? '' : 'none';
                    if (show) shown++;
                });
                var empty = document.getElementById('tinkering-empty');
                if (empty) empty.style.display = shown === 0 ? '' : 'none';
            }
            tinkeringYearToolbar.addEventListener('click', function (e) {
                var btn = e.target.closest('.year-filter');
                if (!btn) return;
                var yr = btn.getAttribute('data-year');
                yearButtons.forEach(function (b) { b.classList.remove('is-active'); b.setAttribute('aria-pressed', 'false'); });
                btn.classList.add('is-active');
                btn.setAttribute('aria-pressed', 'true');
                applyYear(yr);
                try { localStorage.setItem('works:year', yr); } catch (e) { }
            });
            // apply persisted year filter
            var persistedYear = null; try { persistedYear = localStorage.getItem('works:year'); } catch (e) { }
            if (persistedYear && persistedYear !== '*') {
                var ybtn = yearButtons.find(function (b) { return b.getAttribute('data-year') === persistedYear; });
                if (ybtn) ybtn.click(); else applyYear('*');
            } else {
                applyYear('*');
            }
        }
    }
});

