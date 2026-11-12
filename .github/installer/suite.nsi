; Suite — κοινό πρόγραμμα εγκατάστασης για τις εφαρμογές (DOC, XLS, PPT).
; Ο χρήστης επιλέγει ποιες εφαρμογές θα εγκατασταθούν. Κάθε εφαρμογή εγκαθίσταται με το δικό της πρόγραμμα εγκατάστασης
; (σιωπηλά), οπότε έχει τη δική της απεγκατάσταση και τις δικές της αυτόματες ενημερώσεις.
;
; Δύο εκδοχές από το ίδιο αρχείο:
;   makensis suite.nsi                         → Suite_Setup.exe (μικρό· κατεβάζει την τελευταία έκδοση κάθε εφαρμογής)
;   makensis -DOFFLINE -DDOC_EXE=… -DXLS_EXE=… -DPPT_EXE=… suite.nsi → Suite_Setup_Offline.exe (περιέχει τις εφαρμογές)
;
; Σιωπηλή εγκατάσταση: Suite_Setup.exe /S /APPS=doc,xls,ppt
;
; Για νέα εφαρμογή (π.χ. PPT): πρόσθεσε ένα !insertmacro APP … παρακάτω και την περιγραφή της.

Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "Sections.nsh"

!ifndef VERSION
  !define VERSION "1.0.0"
!endif
!define SUITE "Suite"
!ifndef DOC_EXE
  !define DOC_EXE ""
!endif
!ifndef XLS_EXE
  !define XLS_EXE ""
!endif
!ifndef PPT_EXE
  !define PPT_EXE ""
!endif
!ifdef OFFLINE
  !define OUTFILE "Suite_Setup_Offline.exe"
!else
  !define OUTFILE "Suite_Setup.exe"
!endif

Name "${SUITE}"
OutFile "${OUTFILE}"
RequestExecutionLevel user
SetCompressor /SOLID lzma
ShowInstDetails show
BrandingText "${SUITE} ${VERSION}"
VIProductVersion "${VERSION}.0"
VIAddVersionKey /LANG=1032 "ProductName" "${SUITE}"
VIAddVersionKey /LANG=1032 "FileDescription" "Εγκατάσταση ${SUITE} (DOC, XLS, PPT)"
VIAddVersionKey /LANG=1032 "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=1032 "ProductVersion" "${VERSION}"
VIAddVersionKey /LANG=1032 "LegalCopyright" "Vasileios Tripolidis"

!define MUI_ICON "suite.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_ABORTWARNING
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_WELCOMEPAGE_TITLE "Εγκατάσταση ${SUITE}"
!ifdef OFFLINE
  !define MUI_WELCOMEPAGE_TEXT "Θα επιλέξετε ποιες εφαρμογές θα εγκατασταθούν στον υπολογιστή σας:$\r$\n$\r$\n  •  DOC — επεξεργαστής κειμένου ($\".docx$\")$\r$\n  •  XLS — υπολογιστικό φύλλο ($\".xlsx$\")$\r$\n  •  PPT — παρουσιάσεις ($\".pptx$\")$\r$\n$\r$\nΑυτό το αρχείο περιέχει ήδη τις εφαρμογές και δεν χρειάζεται σύνδεση στο Internet. Κάθε εφαρμογή ενημερώνεται έπειτα αυτόματα.$\r$\n$\r$\nΠατήστε «Επόμενο» για να συνεχίσετε."
!else
  !define MUI_WELCOMEPAGE_TEXT "Θα επιλέξετε ποιες εφαρμογές θα κατεβούν και θα εγκατασταθούν στον υπολογιστή σας:$\r$\n$\r$\n  •  DOC — επεξεργαστής κειμένου ($\".docx$\")$\r$\n  •  XLS — υπολογιστικό φύλλο ($\".xlsx$\")$\r$\n  •  PPT — παρουσιάσεις ($\".pptx$\")$\r$\n$\r$\nΚατεβαίνει πάντα η τελευταία έκδοση και μόνο ό,τι επιλέξετε. Χρειάζεται σύνδεση στο Internet. Κάθε εφαρμογή ενημερώνεται έπειτα αυτόματα.$\r$\n$\r$\nΠατήστε «Επόμενο» για να συνεχίσετε."
!endif
!define MUI_COMPONENTSPAGE_TEXT_TOP "Επιλέξτε τις εφαρμογές που θέλετε να εγκαταστήσετε. Όσες είναι ήδη εγκατεστημένες ενημερώνονται στην τελευταία έκδοση."
!define MUI_FINISHPAGE_TITLE "Η εγκατάσταση ολοκληρώθηκε"
!define MUI_FINISHPAGE_TEXT "$R9"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "Greek"

Var Failed
Var Done
Var Tmp

; ---------- μία εφαρμογή ----------
; ID: μικρό όνομα (για /APPS=), NAME: όνομα προϊόντος (κλειδί απεγκατάστασης), JSON: latest.json του ενημερωτή, EXE: (offline) αρχείο εγκατάστασης
!macro APP ID NAME JSON EXE
Section "${NAME}" sec_${ID}
  DetailPrint "———— ${NAME} ————"
  StrCpy $0 "$Tmp\${NAME}_setup.exe"
  !ifdef OFFLINE
    SetOutPath "$Tmp"
    File "/oname=${NAME}_setup.exe" "${EXE}"
  !else
    DetailPrint "Λήψη της τελευταίας έκδοσης του ${NAME}…"
    nsExec::ExecToStack '"$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$Tmp\get.ps1" -Json "${JSON}" -Out "$0"'
    Pop $1
    Pop $2
    ${If} $1 != 0
      DetailPrint "Η λήψη του ${NAME} απέτυχε: $2"
      StrCpy $Failed "$Failed${NAME} (λήψη) "
      Goto done_${ID}
    ${EndIf}
    DetailPrint "Κατέβηκε η έκδοση $2"
  !endif
  DetailPrint "Εγκατάσταση του ${NAME}…"
  ExecWait '"$0" /S' $1
  ${If} $1 != 0
    DetailPrint "Η εγκατάσταση του ${NAME} απέτυχε (κωδικός $1)."
    StrCpy $Failed "$Failed${NAME} "
  ${Else}
    ReadRegStr $2 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "DisplayVersion"
    DetailPrint "Το ${NAME} $2 εγκαταστάθηκε."
    StrCpy $Done "$Done${NAME} "
  ${EndIf}
  Delete "$0"
  !ifndef OFFLINE
  done_${ID}:
  !endif
SectionEnd
!macroend

; πριν από τις ενότητες: φάκελος προσωρινών και (online) το σενάριο λήψης
Section "-prepare"
  InitPluginsDir
  StrCpy $Tmp "$PLUGINSDIR"
  StrCpy $Failed ""
  StrCpy $Done ""
  !ifndef OFFLINE
    FileOpen $9 "$Tmp\get.ps1" w
    FileWrite $9 "param([string]$$Json, [string]$$Out)$\r$\n"
    FileWrite $9 "$$ErrorActionPreference = 'Stop'; $$ProgressPreference = 'SilentlyContinue'$\r$\n"
    FileWrite $9 "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}$\r$\n"
    FileWrite $9 "try {$\r$\n"
    FileWrite $9 "  $$j = Invoke-RestMethod -UseBasicParsing -Uri $$Json$\r$\n"
    FileWrite $9 "  $$u = $$j.platforms.'windows-x86_64'.url$\r$\n"
    FileWrite $9 "  if (-not $$u) { throw 'δεν βρέθηκε αρχείο εγκατάστασης' }$\r$\n"
    FileWrite $9 "  Invoke-WebRequest -UseBasicParsing -Uri $$u -OutFile $$Out$\r$\n"
    FileWrite $9 "  if ((Get-Item $$Out).Length -lt 100000) { throw 'το αρχείο είναι ελλιπές' }$\r$\n"
    FileWrite $9 "  Write-Output $$j.version; exit 0$\r$\n"
    FileWrite $9 "} catch { Write-Output $$_.Exception.Message; exit 1 }$\r$\n"
    FileClose $9
  !endif
SectionEnd

!insertmacro APP doc DOC "https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/doc.json" "${DOC_EXE}"
!insertmacro APP xls XLS "https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/xls.json" "${XLS_EXE}"
; το PPT μπαίνει στο offline μόνο αν δόθηκε το αρχείο του
!ifdef OFFLINE
  !if "${PPT_EXE}" != ""
    !define HAS_PPT
  !endif
!else
  !define HAS_PPT
!endif
!ifdef HAS_PPT
!insertmacro APP ppt PPT "https://github.com/vasileiostripolidis/suite-releases/releases/latest/download/ppt.json" "${PPT_EXE}"
!endif

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${sec_doc} "DOC: επεξεργαστής κειμένου, συμβατός με αρχεία Word (.docx)."
  !insertmacro MUI_DESCRIPTION_TEXT ${sec_xls} "XLS: υπολογιστικό φύλλο, συμβατό με αρχεία Excel (.xlsx)."
  !ifdef HAS_PPT
  !insertmacro MUI_DESCRIPTION_TEXT ${sec_ppt} "PPT: παρουσιάσεις, συμβατές με αρχεία PowerPoint (.pptx)."
  !endif
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; ---------- βοηθητικά ----------
; Στο όνομα της ενότητας εμφανίζεται η εγκατεστημένη έκδοση
!macro MARK ID NAME
  ReadRegStr $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "DisplayVersion"
  ${If} $1 != ""
    SectionSetText ${sec_${ID}} "${NAME}  (εγκατεστημένο $1 — ενημέρωση)"
  ${EndIf}
  ; /APPS=doc,xls: μόνο όσα αναφέρονται
  ${If} $3 != ""
    Push "$3"
    Push "${ID}"
    Call HasWord
    Pop $4
    ${If} $4 == 0
      !insertmacro UnselectSection ${sec_${ID}}
    ${EndIf}
  ${EndIf}
!macroend

; HasWord: (λίστα με κόμματα, λέξη) → 1/0
Function HasWord
  Exch $R1 ; λέξη
  Exch
  Exch $R0 ; λίστα
  Push $R2
  Push $R3
  Push $R4
  Push $R5
  StrCpy $R0 ",$R0,"
  StrCpy $R1 ",$R1,"
  StrLen $R3 $R1
  StrCpy $R4 0
  StrCpy $R2 0
  loop:
    StrCpy $R5 $R0 $R3 $R2
    ${If} $R5 == ""
      Goto out
    ${EndIf}
    ${If} $R5 == $R1
      StrCpy $R4 1
      Goto out
    ${EndIf}
    IntOp $R2 $R2 + 1
    Goto loop
  out:
  StrCpy $R0 $R4
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

Function .onInit
  ${GetParameters} $0
  ClearErrors
  ${GetOptions} $0 "/APPS=" $3
  ${If} ${Errors}
    StrCpy $3 ""
  ${EndIf}
  !insertmacro MARK doc DOC
  !insertmacro MARK xls XLS
  !ifdef HAS_PPT
  !insertmacro MARK ppt PPT
  !endif
FunctionEnd

Function .onSelChange
  ; τουλάχιστον μία εφαρμογή
  SectionGetFlags ${sec_doc} $0
  SectionGetFlags ${sec_xls} $1
  IntOp $0 $0 & ${SF_SELECTED}
  IntOp $1 $1 & ${SF_SELECTED}
  IntOp $0 $0 | $1
  !ifdef HAS_PPT
  SectionGetFlags ${sec_ppt} $1
  IntOp $1 $1 & ${SF_SELECTED}
  IntOp $0 $0 | $1
  !endif
  GetDlgItem $2 $HWNDPARENT 1
  EnableWindow $2 $0
FunctionEnd


Section "-finish"
  ${If} $Failed != ""
    StrCpy $R9 "Δεν ολοκληρώθηκε: $Failed$\r$\n$\r$\nΕλέγξτε τη σύνδεση στο Internet και δοκιμάστε ξανά, ή χρησιμοποιήστε το Suite_Setup_Offline.exe.$\r$\n$\r$\nΕγκαταστάθηκαν: $Done"
    SetErrorLevel 2
  ${Else}
    StrCpy $R9 "Εγκαταστάθηκαν: $Done$\r$\n$\r$\nΘα τις βρείτε στο μενού Έναρξη και στην επιφάνεια εργασίας. Κάθε εφαρμογή απεγκαθίσταται χωριστά από τις Ρυθμίσεις → Εφαρμογές."
  ${EndIf}
SectionEnd
