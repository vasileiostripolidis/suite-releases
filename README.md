<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./.github/assets/banner-dark.png">
  <img src="./.github/assets/banner-light.png" alt="Suite: documents, spreadsheets and slides, light and private" width="100%">
</picture>

<p align="center">
  <a href="https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/Suite_Setup.exe"><img src="./.github/assets/btn-windows.png" height="52" alt="Download for Windows"></a>&nbsp;
  <a href="https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/Suite_Setup_Offline.exe"><img src="./.github/assets/btn-offline.png" height="52" alt="Offline installer"></a>&nbsp;
  <a href="https://vasileiostripolidis.github.io/suite-releases/"><img src="./.github/assets/btn-web.png" height="52" alt="Open the website"></a>
</p>

<p align="center">
  <a href="https://github.com/vasileiostripolidis/suite-releases/releases">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://github.com/vasileiostripolidis/suite-releases/raw/site/stats/downloads-dark.svg">
      <img src="https://github.com/vasileiostripolidis/suite-releases/raw/site/stats/downloads-light.svg" width="480" alt="Downloads">
    </picture>
  </a>
</p>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./.github/assets/stack-dark.png">
    <img src="./.github/assets/stack-light.png" height="34" alt="Tauri 2 · Rust · JavaScript · WebView2 · Ed25519-signed updates · Free to use">
  </picture>
</p>

<br>

<p align="center"><img src="./.github/assets/showcase.png" width="92%" alt="DOC, XLS and PPT side by side"></p>

<br>

## Overview

Suite is a light office suite for Windows with three apps: **DOC** for documents, **XLS** for spreadsheets and **PPT** for presentations. One small installer asks which ones you want and installs only those. They open and save Microsoft Office files, run without an internet connection and keep themselves up to date; updating one updates the others too.

|  |  |
|:--|:--|
| **~200 KB** installer | Downloads only the apps you pick; the offline installer carries all three |
| **0** telemetry | No account, no ads, no analytics. Files stay on your computer |
| **3** apps | DOC, XLS and PPT, installed together or on their own |
| **21** file formats | Word, Excel, PowerPoint, OpenDocument, RTF, PDF, Markdown, HTML, CSV and more |
| **0** admin rights | Installs per user; no UAC prompt |

<br>

## The apps

<table>
<tr>
<td width="50%" valign="top">

#### DOC · documents
Opens and saves Word files with their formatting. Styles, tables, images, shapes and equations; headers, footers and page layout; spell check, track changes and comments; mail merge, templates and PDF export. Greek and English interface.

<sub>`.docx` `.docm` `.dotx` `.dotm` `.doc` `.odt` `.rtf` `.pdf` `.xps` `.md` `.htm` `.txt`</sub>

</td>
<td width="50%" valign="top">

#### XLS · spreadsheets
Opens and saves Excel files with their formulas. Charts, pivot tables, slicers, filters and conditional formatting; get & transform data and a data model; track changes, themes and personal templates.

<sub>`.xlsx` `.xlsm` `.xltx` `.xltm` `.xls` `.ods` `.csv` `.tsv`</sub>

</td>
</tr>
<tr>
<td colspan="2" valign="top">

#### PPT · presentations
Opens and saves PowerPoint files. Slide layouts and themes, text with bullets and numbering, shapes, pictures, icons and tables; speaker notes, transitions, slide show with presenter view, and PDF export.

<sub>`.pptx` `.pptm` `.ppsx` `.potx`</sub>

</td>
</tr>
</table>

<table>
<tr>
<td width="50%"><img src="./.github/assets/app-doc.png" alt="DOC"></td>
<td width="50%"><img src="./.github/assets/app-xls.png" alt="XLS"></td>
</tr>
<tr>
<td align="center"><sub><b>DOC</b>: a proposal with headings, a table and a list</sub></td>
<td align="center"><sub><b>XLS</b>: formulas and a chart that follows the data</sub></td>
</tr>
<tr>
<td colspan="2"><img src="./.github/assets/app-ppt.png" alt="PPT"></td>
</tr>
<tr>
<td colspan="2" align="center"><sub><b>PPT</b>: slides with a theme, bullets and shapes</sub></td>
</tr>
</table>

<br>

## Install

1. Download **[Suite_Setup.exe](https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/Suite_Setup.exe)** and open it.
2. Tick **DOC**, **XLS**, **PPT**, or any combination.
3. Press **Install**. The apps appear in the Start menu.

| Installer | Size | When to use it |
|:--|:--|:--|
| `Suite_Setup.exe` | ~200 KB | Normal choice. Fetches the latest version of the apps you pick |
| `Suite_Setup_Offline.exe` | ~25 MB | Computers without internet, or a copy to keep on a USB stick |

Windows 10 / 11, 64-bit. The installers are not code-signed yet, so SmartScreen may ask once: *More info → Run anyway*. Run the installer again any time to add another app.

**Updates:** each app checks for new versions by itself and installs them only after you confirm. Updating one app also updates the other installed apps (an open app is updated as soon as you close it). Updates are signed with an Ed25519 key; an unsigned or altered package is rejected. Documents and settings are kept.

<br>

<details>
<summary><b>Security and privacy</b></summary>
<br>

| | |
|:--|:--|
| Network | No telemetry. The only automatic request is the optional update check against this repository |
| Macros | Off by default, as in Office. Macro code has no access to the system |
| Files | Your documents never leave your computer |
| AI assistant | Optional. Works only if you add your own API key, and only when you ask it |
| Updates | Signed (minisign / Ed25519), never installed without confirmation |

Found a problem? [Open an issue](https://github.com/vasileiostripolidis/suite-releases/issues).

</details>

<br>

---

### 🇬🇷 Ελληνικά

Η **Suite** είναι μια ελαφριά σουίτα γραφείου για Windows με τρεις εφαρμογές: το **DOC** για κείμενα (αρχεία Word), το **XLS** για υπολογιστικά φύλλα (αρχεία Excel) και το **PPT** για παρουσιάσεις (αρχεία PowerPoint). Κατεβάζεις ένα μικρό αρχείο εγκατάστασης και διαλέγεις τι θα εγκατασταθεί. Δουλεύουν χωρίς internet, χωρίς λογαριασμό και χωρίς παρακολούθηση, και ενημερώνονται μόνες τους· η ενημέρωση της μίας ενημερώνει και τις άλλες.

**[Λήψη για Windows](https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/Suite_Setup.exe)** · [Χωρίς σύνδεση](https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/Suite_Setup_Offline.exe) · [Ιστοσελίδα](https://vasileiostripolidis.github.io/suite-releases/)

<sub>© 2026 Τριπολίδης Βασίλειος. Free to use, all rights reserved. The source code is private.</sub>
