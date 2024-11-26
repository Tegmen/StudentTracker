; Initialization
Persistent
#NoTrayIcon
#SingleInstance Ignore

; Paths and Variables
roamingPath := A_AppData "\StudentTracker"
exePath := roamingPath "\StudentTracker.exe"
desktopShortcut := A_Desktop "\StudentTracker.lnk"
startupShortcut := A_StartMenu "\Programs\Startup\StudentTracker.lnk"

; Variables to track the last process name and window title
maxActivityAge := 2 * 60 * 60 ; Maximum time activities are shown in the log
activity := []
clipboard := []
flaged := ["youtube", "instagram", "spotify", "gpt", "chatgpt", "openai", "facebook", "minecraft", "tiktok", "game"]


; Main Logic: Installation or Execution
if (A_ScriptFullPath = exePath) {
    ; If running from the roaming folder, it's the main tracker
    MsgBox("StudentTracker läuft im Hintergrund.`n`rCTRL+ALT+Y um Verlauf anzuzeigen.")
} else {
    ; Installer Logic
    if FileExist(exePath) {
        ; If StudentTracker.exe exists, ask for uninstallation
        response := MsgBox("StudentTracker deinstallieren?", "Uninstall", 36)
        if response = "Yes" {
            password := InputBox("Passwort zum Deinstallieren eingeben:").Value
            if password = "byebye" {
                ; Uninstallation Process
                KillStudentTracker() ; Kill the process if running
                FileDelete(exePath)
                DirDelete(roamingPath)
                FileDelete(desktopShortcut)
                FileDelete(startupShortcut)
                MsgBox("StudentTracker wurde deinstalliert.")
                ExitApp
            } else {
                MsgBox("Falsches Passwort, Deinstallation abgebrochen.")
                ExitApp
            }
        } else {
            ExitApp
        }
    } else {
        ; Installation Process
        if !FileExist(roamingPath)
            DirCreate(roamingPath)

        FileCopy(A_ScriptFullPath, exePath, 1) ; Copy this executable to roaming
        FileCreateShortcut(exePath, startupShortcut) ; Add to startup
        FileCreateShortcut(exePath, desktopShortcut) ; Create desktop shortcut
		disclaimerBase64 := "PCFET0NUWVBFIGh0bWw+CjxodG1sIGxhbmc9ImRlIj4KPGhlYWQ+CiAgICA8bWV0YSBjaGFyc2V0PSJVVEYtOCI+CiAgICA8bWV0YSBuYW1lPSJ2aWV3cG9ydCIgY29udGVudD0id2lkdGg9ZGV2aWNlLXdpZHRoLCBpbml0aWFsLXNjYWxlPTEuMCI+CiAgICA8dGl0bGU+U3R1ZGVudFRyYWNrZXIgLSBIaW53ZWlzPC90aXRsZT4KICAgIDxzdHlsZT4KICAgICAgICBib2R5IHsKICAgICAgICAgICAgZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNlcmlmOwogICAgICAgICAgICBsaW5lLWhlaWdodDogMS42OwogICAgICAgICAgICBtYXJnaW46IDIwcHg7CiAgICAgICAgfQogICAgICAgIGgxIHsKICAgICAgICAgICAgY29sb3I6ICMzMzM7CiAgICAgICAgfQogICAgICAgIGgyIHsKICAgICAgICAgICAgY29sb3I6ICM1NTU7CiAgICAgICAgfQogICAgICAgIHAgewogICAgICAgICAgICBtYXJnaW4tYm90dG9tOiAxMHB4OwogICAgICAgIH0KICAgICAgICB1bCB7CiAgICAgICAgICAgIG1hcmdpbjogMTBweCAwOwogICAgICAgICAgICBwYWRkaW5nLWxlZnQ6IDIwcHg7CiAgICAgICAgfQogICAgICAgIGxpIHsKICAgICAgICAgICAgbWFyZ2luLWJvdHRvbTogNXB4OwogICAgICAgIH0KICAgICAgICAuaGlnaGxpZ2h0IHsKICAgICAgICAgICAgZm9udC13ZWlnaHQ6IGJvbGQ7CiAgICAgICAgICAgIGNvbG9yOiByZWQ7CiAgICAgICAgfQogICAgPC9zdHlsZT4KPC9oZWFkPgo8Ym9keT4KICAgIDxoMT5IaW53ZWlzOiBWZXJ3ZW5kdW5nIHZvbiBTdHVkZW50VHJhY2tlcjwvaDE+CiAgICA8cD4KICAgICAgICBEaWVzZXMgR2Vyw6R0IHdpcmQgdm9uIGRlciBTY2h1bGUgYmVyZWl0Z2VzdGVsbHQgdW5kIHVudGVybGllZ3QgZGVuIDxhIGhyZWY9Imh0dHBzOi8vaWxpYXMuZWR1YnMuY2gvaWxpYXMucGhwP2Jhc2VDbGFzcz1pbGxtcHJlc2VudGF0aW9uZ3VpJmNtZD1kb3dubG9hZEZpbGUmcmVmX2lkPTU0NjU1MSZvYmpfaWQ9NDk0ODkmZmlsZV9pZD1pbF9fZmlsZV85MDU0NTUiPlJlZ2VsbiBmw7xyIGRpZSBOdXR6dW5nIHZvbiBzY2h1bGlzY2hlbiBDb21wdXRlcm48L2E+LiBEYXMgUHJvZ3JhbW0gCiAgICAgICAgPHN0cm9uZz5TdHVkZW50VHJhY2tlcjwvc3Ryb25nPiBkaWVudCBkYXp1LCBzaWNoZXJ6dXN0ZWxsZW4sIGRhc3MgZGllIE51dHp1bmcgZGllc2VyIEdlcsOkdGUgbWl0IGRlbiBzY2h1bGlzY2hlbiBSaWNodGxpbmllbiDDvGJlcmVpbnN0aW1tdC4KICAgIDwvcD4KCiAgICA8aDI+V2FzIHdpcmQgZXJmYXNzdD88L2gyPgogICAgPHA+RGFzIFByb2dyYW1tIHplaWNobmV0IGRpZSBmb2xnZW5kZW4gSW5mb3JtYXRpb25lbiBhdWY6PC9wPgogICAgPHVsPgogICAgICAgIDxsaT48c3Ryb25nPkFrdGl2ZSBQcm9ncmFtbWU6PC9zdHJvbmc+IERlciBOYW1lIGRlcyBha3R1ZWxsIGdlw7ZmZm5ldGVuIFByb2dyYW1tcyAoei4gQi4gV29yZCwgQ2hyb21lKS48L2xpPgogICAgICAgIDxsaT48c3Ryb25nPkZlbnN0ZXJ0aXRlbDo8L3N0cm9uZz4gRGVyIFRpdGVsIGRlcyBGZW5zdGVycywgZGFzIGdlcmFkZSBiZW51dHp0IHdpcmQgKHouIEIuIGRlciBOYW1lIGRlciBnZcO2ZmZuZXRlbiBXZWJzZWl0ZSkuPC9saT4KICAgICAgICA8bGk+PHN0cm9uZz5ad2lzY2hlbmFibGFnZTo8L3N0cm9uZz4gSW5oYWx0ZSwgZGllIGluIGRpZSBad2lzY2hlbmFibGFnZSBrb3BpZXJ0IHdlcmRlbiAoei4gQi4gVGV4dCBvZGVyIGVpbmZhY2hlIE9iamVrdGUpLjwvbGk+CiAgICAgICAgPGxpPjxzdHJvbmc+WmVpdHJhdW06PC9zdHJvbmc+IEFsbGUgQWt0aXZpdMOkdGVuIGRlciBsZXR6dGVuIDxzcGFuIGNsYXNzPSJoaWdobGlnaHQiPjIgU3R1bmRlbjwvc3Bhbj4uPC9saT4KICAgIDwvdWw+CgogICAgPGgyPldhcyB3aXJkIDxzcGFuIGNsYXNzPSJoaWdobGlnaHQiPm5pY2h0PC9zcGFuPiBlcmZhc3N0PzwvaDI+CiAgICA8dWw+CgkJPGxpPkluaGFsdGUgdm9uIFByb2dyYW1tZW4sIHouQi4gQ2hhdHMsIGUtTWFpbHMgZXRjLjwvbGk+CiAgICAgICAgPGxpPkluaGFsdGUgdm9uIERhdGVpZW4gKHouIEIuIFdvcmQtRG9rdW1lbnRlLCBQREZzKSB3ZXJkZW4gbmljaHQgZGlyZWt0IGVpbmdlc2VoZW4uPC9saT4KICAgICAgICA8bGk+UHJpdmF0ZSBEYXRlbiBhdcOfZXJoYWxiIGRlciBhdWZnZWbDvGhydGVuIFB1bmt0ZSAoei4gQi4gUGFzc3fDtnJ0ZXIsIGdlc3BlaWNoZXJ0ZSBEYXRlbiBpbiBBcHBzKSB3ZXJkZW4gbmljaHQgZXJmYXNzdC48L2xpPgogICAgICAgIDxsaT5LZWluZSBEYXRlbiB3ZXJkZW4gaW5zIEludGVybmV0IGdlc2VuZGV0IG9kZXIgZXh0ZXJuIGdlc3BlaWNoZXJ0LjwvbGk+CgkJPGxpPkluZm9ybWF0aW9uZW4gZGllIMOkbHRlciBhbHMgMiBTdHVuZGVuIHNpbmQsIHdlcmRlbiBhdXRvbWF0aXNjaCBnZWzDtnNjaHQgdW5kIHNpbmQgZGFuY2ggbmljaHQgbWVociB2ZXJmw7xnYmFyLjwvbGk+CiAgICA8L3VsPgoKICAgIDxoMj5UcmFuc3BhcmVuejwvaDI+CiAgICA8cD4KICAgICAgICBEdSBrYW5uc3QgZGllIGF1ZmdlemVpY2huZXRlbiBEYXRlbiBqZWRlcnplaXQgc2VsYnN0IGVpbnNlaGVuLCBpbmRlbSBTaWUgZGllIFRhc3RlbmtvbWJpbmF0aW9uIAogICAgICAgIDxzdHJvbmc+U3RyZyArIEFsdCArIFk8L3N0cm9uZz4gZHLDvGNrc3QuIEVzIMO2ZmZuZXQgc2ljaCBlaW5lIMOcYmVyc2ljaHQgw7xiZXIgZGllIHp1bGV0enQgYXVmZ2V6ZWljaG5ldGVuIEFrdGl2aXTDpHRlbi4KICAgIDwvcD4KCiAgICA8aDI+V2FydW0gd2lyZCBkaWVzZXMgUHJvZ3JhbW0gZWluZ2VzZXR6dD88L2gyPgogICAgPHA+CiAgICAgICAgRGFzIFppZWwgdm9uIFN0dWRlbnRUcmFja2VyIGlzdCBlcywgZGllIHNjaHVsaXNjaGUgTnV0enVuZyBkZXIgR2Vyw6R0ZSBzaWNoZXJ6dXN0ZWxsZW4gdW5kIGRlbiBGb2t1cyBhdWYgZGFzIExlcm5lbiB6dSBmw7ZyZGVybi4gCiAgICAgICAgRGFzIFByb2dyYW1tIGhpbGZ0IGRhYmVpLCBkaWUgRWluaGFsdHVuZyBkZXIgTnV0enVuZ3NyaWNodGxpbmllbiB6dSDDvGJlcnByw7xmZW4uCiAgICA8L3A+CgogICAgPGgyPlLDvGNrZnJhZ2VuPzwvaDI+CiAgICA8cD4KICAgICAgICBCZWkgRnJhZ2VuIHVuZCBCZWRlbmtlbiBtZWxkZSBEaWNoIGJlaSBNYXJ0aW4gQnLDpG5kbGkuCiAgICA8L3A+CjwvYm9keT4KPC9odG1sPg=="
		OpenBase64Data(disclaimerBase64)
		Sleep 1000
        MsgBox("StudentTracker installiert.")
        Run(exePath) ; Run the installed StudentTracker.exe
        ExitApp
    }
}

; Keybinds
^!x:: ; Ctrl+Alt+X to exit
{
	ib := InputBox("Zum Beenden von StudentTracker Passwort eingeben:")
	if (ib.Result != "Cancel"){	
		if (ib.Value = "byebye") {
			MsgBox("StudentTracker beendet.")
			ExitApp
		} else {
			MsgBox("Falsches Passwort.")
		}
	}
}

^!y:: DisplayLog() ; Ctrl+Alt+Y to display log

; Timers
SetTimer(TrackActivity, 1000) ; Check activity every second
SetTimer(RemoveOldActivities, 60000) ; Remove old activities every minute

; Clipboard Change
OnClipboardChange ClipLog

; Functions
TrackActivity() {
    ; Tracks changes in the active window and logs them
    try {
        process := StrReplace(WinGetProcessName("A"), "\", "/")
    } catch {
        UpdateActivity("NO WINDOW", "-")
        return
    }

    try {
        title := StrReplace(WinGetTitle("A"), "\", "/")
    } catch {
        UpdateActivity(process, "-")
        return
    }
    UpdateActivity(process, title)
}

UpdateActivity(newProcess, newTitle) {
    global activity
    current := activity.Length
    if (current = 0) {
        activity.Push(Map("process", newProcess, "title", newTitle, "start", A_Now, "end", A_Now))
        return
    }
    activity[current]["end"] := A_Now
    if (activity[current]["process"] != newProcess || activity[current]["title"] != newTitle) {
        activity.Push(Map("process", newProcess, "title", newTitle, "start", A_Now, "end", A_Now))
    }
}

ClipLog(DataType) {
    ; Logs clipboard changes
    global clipboard
    if (DataType = 1) {
        cb := RegExReplace(A_Clipboard, "\r?\n") ; Remove linefeeds
        length := StrLen(A_Clipboard)
        clip := (length <= 100) ? "(" length " Zeichen) " cb : "(" length " Zeichen) " SubStr(cb, 1, 100) "..."
        clipboard.Push(Map("time", A_Now, "content", clip))
    } else if (DataType = 2) {
        clipboard.Push(Map("time", A_Now, "content", "Objekt (z.B. Bild)"))
    }
}

DisplayLog() {
    ; Generates and displays the log
	
	;HTML template
    before := "<!DOCTYPE html>`r`n<html lang=`"de`">`r`n<head>`r`n    <meta charset=`"UTF-8`">`r`n    <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">`r`n    <title>Aktivität</title>`r`n    <style>`r`n        table {`r`n            width`: 100%`;`r`n            border-collapse`: collapse`;`r`n            margin-bottom`: 20px`;`r`n        }`r`n`r`n        th, td {`r`n            border`: 1px solid #ddd`;`r`n            padding`: 8px`;`r`n            text-align`: left`;`r`n        }`r`n`r`n        th {`r`n            background-color`: #f4f4f4`;`r`n        }`r`n`r`n        .highlight {`r`n            background-color`: yellow`;`r`n        }`r`n`r`n        .bold {`r`n            font-weight`: bold`;`r`n        }`r`n    </style>`r`n</head>`r`n<body>`r`n    <h1>Aktivität</h1>`r`n    <table id=`"activityTable`">`r`n        <thead>`r`n            <tr>`r`n                <th>Zeit</th>`r`n                <th>Dauer</th>`r`n                <th>Programm</th>`r`n                <th>Titel</th>`r`n            </tr>`r`n        </thead>`r`n        <tbody></tbody>`r`n    </table>`r`n`r`n    <h1>Zwischenablage</h1>`r`n    <table id=`"clipboardTable`">`r`n        <thead>`r`n            <tr>`r`n                <th>Zeit</th>`r`n                <th>Zwischenablage</th>`r`n            </tr>`r`n        </thead>`r`n        <tbody></tbody>`r`n    </table>`r`n`r`n    <script>`r`n        const jsonData = "
	after := "`;`r`n`r`n        function parseTimestamp(timestamp) {`r`n            const year = parseInt(String(timestamp).slice(0, 4), 10)`;`r`n            const month = parseInt(String(timestamp).slice(4, 6), 10) - 1`;`r`n            const day = parseInt(String(timestamp).slice(6, 8), 10)`;`r`n            const hour = parseInt(String(timestamp).slice(8, 10), 10)`;`r`n            const minute = parseInt(String(timestamp).slice(10, 12), 10)`;`r`n            const second = parseInt(String(timestamp).slice(12, 14), 10)`;`r`n            return new Date(year, month, day, hour, minute, second)`;`r`n        }`r`n`r`n        function calculateDuration(start, end) {`r`n            const startTime = parseTimestamp(start)`;`r`n            const endTime = parseTimestamp(end)`;`r`n            const duration = (endTime - startTime) / 1000`; // duration in seconds`r`n            if (duration < 60) {`r`n                return ``${Math.round(duration)}s```;`r`n            } else if (duration < 3600) {`r`n                return ``${Math.floor(duration / 60)}min.```;`r`n            } else {`r`n                return ``${Math.floor(duration / 3600)}h```;`r`n            }`r`n        }`r`n`r`n        function highlightKeywords(text, keywords) {`r`n            keywords.forEach(keyword => {`r`n                const regex = new RegExp(``(${keyword})``, 'gi')`;`r`n                text = text.replace(regex, '<span class=`"bold`">$1</span>')`;`r`n            })`;`r`n            return text`;`r`n        }`r`n`r`n        const flagedKeywords = jsonData.flaged`;`r`n        const activityTable = document.getElementById('activityTable').querySelector('tbody')`;`r`n        jsonData.activity.sort((a, b) => a.start - b.start).forEach(item => {`r`n            const row = document.createElement('tr')`;`r`n            const containsFlag = flagedKeywords.some(keyword => item.process.toLowerCase().includes(keyword) || item.title.toLowerCase().includes(keyword))`;`r`n`r`n            if (containsFlag) row.classList.add('highlight')`;`r`n`r`n            row.innerHTML = ```r`n                <td>${parseTimestamp(item.start).toTimeString().slice(0, 5)}</td>`r`n                <td>${calculateDuration(item.start, item.end)}</td>`r`n                <td>${highlightKeywords(item.process, flagedKeywords)}</td>`r`n                <td>${highlightKeywords(item.title, flagedKeywords)}</td>`r`n            ```;`r`n            activityTable.appendChild(row)`;`r`n        })`;`r`n`r`n        const clipboardTable = document.getElementById('clipboardTable').querySelector('tbody')`;`r`n        jsonData.clipboard.sort((a, b) => a.time - b.time).forEach(entry => {`r`n            const row = document.createElement('tr')`;`r`n            row.innerHTML = ```r`n                <td>${parseTimestamp(entry.time).toTimeString().slice(0, 5)}</td>`r`n                <td>${entry.content}</td>`r`n            ```;`r`n            clipboardTable.appendChild(row)`;`r`n        })`;`r`n    </script>`r`n</body>`r`n</html>`r`n"
    json := ToJson(Map("activity", activity, "clipboard", clipboard, "flaged", flaged))
    html := before "" json "" after
	OpenBase64Data(StringToBase64(html))
}

RemoveOldActivities() {
    ; Removes old activity and clipboard entries
    global maxActivityAge
    cutoffTime := DateAdd(A_Now, -maxActivityAge, "Seconds")
    for i, element in activity {
        if element["end"] < cutoffTime
            activity.RemoveAt(i)
    }
    for i, element in clipboard {
        if element["time"] < cutoffTime
            clipboard.RemoveAt(i)
    }
}

KillStudentTracker() {
    ; Terminates the StudentTracker process if running
    if (PID := ProcessExist("StudentTracker.exe")) {
        ProcessClose(PID)
        Sleep 500
    }
}

ToJson(obj) {
    ; Converts objects to JSON
    if IsObject(obj) {
        if obj.__Class == "Array" {
            json := "["
            for index, value in obj {
                json .= (index > 1 ? "," : "") ToJson(value)
            }
            return json "]"
        } else {
            json := "{"
            for key, value in obj {
                json .= (json != "{" ? "," : "") "`"" key "`": " ToJson(value)
            }
            return json "}"
        }
    } else if IsNumber(obj) {
        return obj
    } else {
        return "`"" StrReplace(obj, "`"", "`\`"") "`""
    }
}

StringToBase64(String, Encoding := "UTF-8") {
    ; Converts a string to Base64
    static CRYPT_STRING_BASE64 := 0x00000001
    static CRYPT_STRING_NOCRLF := 0x40000000

    Binary := Buffer(StrPut(String, Encoding))
    StrPut(String, Binary, Encoding)
    if !(DllCall("crypt32\CryptBinaryToStringW", "Ptr", Binary, "UInt", Binary.Size - 1, "UInt", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", 0, "UInt*", &Size := 0))
        throw OSError()

    Base64 := Buffer(Size << 1, 0)
    if !(DllCall("crypt32\CryptBinaryToStringW", "Ptr", Binary, "UInt", Binary.Size - 1, "UInt", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", Base64, "UInt*", Size))
        throw OSError()

    return StrGet(Base64)
}

OpenBase64Data(data) {
	url := "data:text/html;base64," data
	try {
        Run("msedge.exe " url)  ; Explicitly opens the data in Microsoft Edge
    } catch {
        
		A_Clipboard := url
		loader := "data:text/html;charset=utf-8,%3C!DOCTYPE%20html%3E%3Chtml%3E%3Cbody%20onpaste%3D%22try%7Bdocument.open()%3Bdocument.write(atob((event.clipboardData%7C%7Cwindow.clipboardData).getData('text').trim()))%3Bdocument.close()%3B%7Dcatch%7Balert('Invalid%20Base64')%3B%7D%22%3E%3C/body%3E%3C/html%3E"
    	Run("msedge.exe " loader) ; Replace msedge.exe with your default browser if needed
		sleep 100 
		Send("^v")
	}	
	
}
