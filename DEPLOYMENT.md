# Deployment Guide

This site is built with Jekyll and deploys to GitHub Pages via GitHub Actions.

## Local Development

Prerequisites:
- Ruby 3.1+ (recommended 3.2)
- Bundler

Install dependencies:
```bash
bundle install
```

Run the development server:
```bash
bundle exec jekyll serve --livereload
```

Build for production:
```bash
JEKYLL_ENV=production bundle exec jekyll build
```

The output is generated into the `_site/` directory.

## GitHub Pages (with Custom Domain)

This repo includes a workflow at `.github/workflows/jekyll.yml` that:
- Installs Ruby and gems
- Builds the site with `bundle exec jekyll build`
- Publishes `_site` to GitHub Pages

Steps to enable:
1. Push to the `main` branch. The workflow triggers automatically.
2. In GitHub: Settings → Pages → Ensure "Source" is set to "GitHub Actions".
3. Custom domain: Set your domain to `www.karacaufuk.com`. This repo includes a `CNAME` file with that host.
4. DNS records (create at your DNS provider):
   - A records (apex) pointing to GitHub Pages IPs:
     - 185.199.108.153
     - 185.199.109.153
     - 185.199.110.153
     - 185.199.111.153
   - CNAME record for `www` → `<your-username>.github.io` or the repo pages hostname if using org/site repos.
5. After DNS propagates, enable Enforce HTTPS in GitHub Pages settings.

## Environment Notes

- The `Gemfile` uses Jekyll 4.x and standard plugins. No need for the `github-pages` gem because we build via Actions.
- The site base URL is configured in `_config.yml` via `url`. For forks or previews, override with:
  ```bash
  bundle exec jekyll build --baseurl ""
  ```

## Troubleshooting

- Missing gems: run `bundle update` or delete `vendor/bundle` and reinstall.
- Build fails in CI:
  - Check the Actions logs.
  - Ensure `JEKYLL_ENV=production` is set only for `build`.
- 404s for assets on Pages:
  - Ensure all asset links are root-relative (e.g. `/assets/...`).
  - Confirm `_site` contains the referenced files.

## Manual Publish (optional)

If you want to test the exact CI build locally:
```bash
bundle config path vendor/bundle
bundle install
JEKYLL_ENV=production bundle exec jekyll build
```
Then push to `main` to trigger deployment.

