# License Manager

A single-page static site that documents all asset licenses for a client website delivery. Hosted on GitHub Pages.

## Project purpose

The client requires proof of licensing for every asset used in their website. This page organises those licenses in two tabs: Images (stock photos with PDF certificates) and Fonts (Google Fonts with OFL details).

## File structure

```
index.html          — entire app, single file, no build step
manifest.js         — auto-generated image list for local preview
update-manifest.ps1 — regenerates manifest.js by scanning Images/
update-manifest.bat — double-click wrapper for update-manifest.ps1
Images/
  1/   — one folder per image: contains the .jpg/.png + license .pdf
  2/
  ...
```

## How images are loaded

- **On GitHub Pages**: `index.html` auto-detects the GitHub Pages URL, calls the GitHub Contents API to list `Images/` folders, and renders cards dynamically — no manifest needed.
- **Local preview**: Run `update-manifest.bat` once to regenerate `manifest.js`, then open `index.html` in a browser.

Adding a new image = create a new numbered folder under `Images/`, drop the image and its PDF license inside, push to GitHub. No other changes required.

## Images tab

Each image card shows:
- Thumbnail (with hover zoom)
- Folder number badge + Licensed / AI Generated badge
- Download buttons: image file + license PDF
- AI Generated images have no PDF (they are free, no license needed)

## Fonts tab

Three assets documented:

| Asset                    | License                           | Source                         |
|--------------------------|-----------------------------------|--------------------------------|
| Gotu                     | SIL OFL 1.1 (free)                | Google Fonts                   |
| Montserrat               | SIL OFL 1.1 (free)                | Google Fonts                   |
| Font Awesome Pro Plus    | Commercial (paid, owned)          | fontawesome-pro-plus_v7.3.0_web|

Gotu and Montserrat are loaded via Google Fonts CDN. Font cards render each typeface in its own font. Bottom strips explain the two license types — OFL (green) and Font Awesome commercial (orange).

Font Awesome Pro Plus v7.3.0 — commercial license: attribution not required; brand icons may only represent their owner. License file: `c:\Users\C1\Documents\Received Files\fontawesome-pro-plus_v7.3.0_web\LICENSE.txt`.

To add another Google Font: add a new `.font-card` block inside `#tab-fonts`, add the font to the Google Fonts `<link>` in `<head>`, and add a CSS rule `.font-NAME .font-preview-name, .font-NAME .font-preview-sample { font-family: ... }`.

## Tabs

Switching is handled by `switchTab(name, btn)` in the inline `<script>`. No framework — plain HTML/CSS/JS, zero dependencies except Google Fonts.
