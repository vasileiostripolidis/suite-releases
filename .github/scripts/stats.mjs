// Μετρητής λήψεων για τη σελίδα του αποθετηρίου: διαβάζει τις εκδόσεις και γράφει δύο SVG (σκούρο/ανοιχτό).
// Χρήση: node stats.mjs <φάκελος εξόδου>. Χρειάζεται GH_TOKEN (το GITHUB_TOKEN του workflow αρκεί).
import fs from 'node:fs'; import path from 'node:path';
const out = process.argv[2] || 'stats'; const repo = process.env.GITHUB_REPOSITORY || 'vasileiostripolidis/suite-releases';
let online = 0, offline = 0;
const local = process.env.RELEASES_FILE; // για δοκιμή εκτός Actions
if (local) for (const rel of JSON.parse(fs.readFileSync(local, 'utf8'))) for (const a of rel.assets) { if (a.name === 'Suite_Setup.exe') online += a.download_count; else if (a.name === 'Suite_Setup_Offline.exe') offline += a.download_count; }
for (let page = 1; !local; page++) {
  const r = await fetch(`https://api.github.com/repos/${repo}/releases?per_page=100&page=${page}`, { headers: { authorization: `Bearer ${process.env.GH_TOKEN}`, accept: 'application/vnd.github+json' } });
  if (!r.ok) throw new Error(`GitHub API ${r.status}`);
  const list = await r.json(); if (!list.length) break;
  for (const rel of list) for (const a of rel.assets) { if (a.name === 'Suite_Setup.exe') online += a.download_count; else if (a.name === 'Suite_Setup_Offline.exe') offline += a.download_count; }
  if (list.length < 100) break;
}
const total = online + offline; const fmt = (n) => n.toLocaleString('en-US');
const T = {
  dark: { bg1: '#17150f', bg2: '#0e0d0a', line: '#2f2a1e', chip: '#221f17', text: '#f3f0e8', mute: '#a39b88', a1: '#ecc969', a2: '#b88f2e', c1: '#e2bd5a', c2: '#8a7a52' },
  light: { bg1: '#fffdf7', bg2: '#f7f3e8', line: '#e6dfcc', chip: '#f1ebda', text: '#1d1a12', mute: '#6f6754', a1: '#ecc969', a2: '#b88f2e', c1: '#c99a2e', c2: '#d9c99c' },
};
const icon = (x, y, s, col, d) => `<g transform="translate(${x} ${y}) scale(${s})" fill="none" stroke="${col}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${d}</g>`;
const DL = '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/>';
const WIFI = '<path d="M12 20h.01"/><path d="M2 8.82a15 15 0 0 1 20 0"/><path d="M5 12.86a10 10 0 0 1 14 0"/><path d="M8.5 16.43a5 5 0 0 1 7 0"/>';
const DISK = '<path d="M6 2h9l5 5v13a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2z"/><path d="M14 2v6h6"/><path d="M12 12v6"/><path d="m9 15 3 3 3-3"/>';
function svg(c) {
  const W = 640, bw = 592, on = total ? (online / total) * bw : bw / 2;
  const chip = (x, label, n, col, d) => `<rect x="${x}" y="28" width="132" height="50" rx="14" fill="${c.chip}"/>${icon(x + 12, 36, 0.75, col, d)}<text x="${x + 36}" y="50" font-size="12" font-weight="600" fill="${c.mute}">${label}</text><text x="${x + 12}" y="70" font-size="17" font-weight="700" fill="${c.text}">${fmt(n)}</text>`;
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="132" viewBox="0 0 ${W} 132" font-family="'Segoe UI', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Arial, sans-serif"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c.bg1}"/><stop offset="1" stop-color="${c.bg2}"/></linearGradient><linearGradient id="a" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c.a1}"/><stop offset="1" stop-color="${c.a2}"/></linearGradient><clipPath id="c"><rect x="24" y="100" width="${bw}" height="8" rx="4"/></clipPath></defs>`
    + `<rect x="0.5" y="0.5" width="${W - 1}" height="131" rx="22" fill="url(#g)" stroke="${c.line}"/><rect x="24" y="24" width="56" height="56" rx="16" fill="url(#a)"/>${icon(36, 36, 1.3333, '#1a1405', DL).replace('stroke-width="2"', 'stroke-width="2.2"')}`
    + `<text x="96" y="62" font-size="34" font-weight="700" fill="${c.text}" letter-spacing="-0.5">${fmt(total)}</text><text x="97" y="82" font-size="13" font-weight="600" fill="${c.mute}" letter-spacing="1.4">DOWNLOADS</text>`
    + chip(340, 'Online', online, c.c1, WIFI) + chip(484, 'Offline', offline, c.c2, DISK)
    + `<rect x="24" y="100" width="${bw}" height="8" rx="4" fill="${c.chip}"/><g clip-path="url(#c)"><rect x="24" y="100" width="${on.toFixed(1)}" height="8" fill="${c.c1}"/><rect x="${(24 + on).toFixed(1)}" y="100" width="${(bw - on).toFixed(1)}" height="8" fill="${c.c2}"/></g></svg>`;
}
fs.mkdirSync(out, { recursive: true });
for (const k of ['dark', 'light']) fs.writeFileSync(path.join(out, `downloads-${k}.svg`), svg(T[k]));
fs.writeFileSync(path.join(out, 'summary.json'), JSON.stringify({ total, online, offline }) + '\n');
console.log({ total, online, offline });
