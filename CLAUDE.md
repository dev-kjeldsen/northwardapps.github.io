# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this site is

Jekyll static site for Northward Apps, hosted on GitHub Pages at `northwardapps.com`. Its primary purpose is the web presence for **Granted: US Citizenship Test** (iOS app). Content focuses on U.S. naturalization — the N-400 process, civics test, interview prep.

## Commands

```bash
# Install dependencies
bundle install

# Run local dev server (http://localhost:4000)
bundle exec jekyll serve

# Build only
bundle exec jekyll build
```

No test suite. Validation is visual — run `jekyll serve` and check in a browser.

## Deployment

Pushing to `main` triggers the GitHub Actions workflow (`.github/workflows/build-and-deploy.yml`) which builds and deploys to GitHub Pages. The workflow also runs on a daily cron at 13:00 UTC so future-dated posts go live automatically on their scheduled date without a manual push.

## Architecture

**Two layouts** live in `_layouts/`:
- `default.html` — contains all site CSS (no separate stylesheet), the site header/nav, and footer. All styles are inline here in CSS custom properties.
- `post.html` — extends `default`, wraps content in `<article>`, shows title + date, and appends a hardcoded CTA block for the Granted App Store download.

**Static pages** (`privacy.html`, `delete-data.html`) are standalone HTML files that do not use the Jekyll layout system — they have their own inline styles.

**Blog posts** live in `_posts/` as Markdown with front matter. URLs use the `permalink: /blog/:slug/` pattern from `_config.yml`.

## Post front matter

```yaml
---
layout: post
title: "Post title"
date: 2026-05-11          # Controls publish order and scheduling
author: Granted Team
description: "..."        # Used as teaser on index pages and for jekyll-seo-tag
meta_description: "..."   # Optional override for the teaser shown in post header
last_updated: 2026-05-20  # Optional; shown in header instead of date if present
---
```

`description` doubles as the SEO meta description (via `jekyll-seo-tag`) and the teaser shown on listing pages. Use `meta_description` only when you need a different teaser in the post header vs. SEO.

## Brand colors

```css
--navy: #1B2B5E
--gold: #FFD700
```

These are defined in `_layouts/default.html` and used throughout inline styles on static pages.

## Key conventions

- All content is US naturalization / citizenship-related — it supports the Granted app audience.
- Posts end with a legal disclaimer: *"This article is for general information only and is not legal advice."*
- The Granted App Store CTA in `_layouts/post.html` is hardcoded and appears on every blog post — do not remove it or change the App Store URL without verifying the link.
- Future-dated posts are committed to `main` but won't render until their `date:` passes (the daily cron picks them up).
