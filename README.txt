
	/// ViSzDesk README \\\

ViSzDesk ist ein Virtueller Szenarien Desktop. Mit dem ersten Start werden eine Reihe Konfigurations-Dateien in einen "content"-Unterordner generiert, wenn sie nicht bereits existieren. Über diese Konfigurations-Dateien können individuelle Desktop-Szenarien erstellt werden.

Im Folgenden werden die Konfigurations-Dateien erklärt.



// CONFIG.CFG \\
Über die config.cfg können generelle Einstellungen getätigt werden, wie einzelne Apps an und aus geschaltet werden. Die neu generierte config.cfg enthält alle möglichen Einstellungsmöglichkeiten mit ihren Standard-Werten. Sie sind größtenteils selbsterklärend. Im Folgenden sind ein paar der Einstellungsmöglichkeiten, die vielleicht nicht gleich ersichtlich sind, erläutert:

	text_files
	In der text_files Variable können Text-Dateien (.txt), die sind im Content-Ordner befinden angegeben werden. Standardmäßig wird hier eine credits.txt geladen, die die Beteiligten des Projekts auflistet. Es können beliebig viele solche Dateien mit Komma getrennt angegeben werden. Sie tauchen als Desktop-Dateien auf, die Spieler*innen einsehen, aber nicht verändern können. Um die anzuzeigenden Texte visuell ansprechender zu formatieren kann BBCode verwendet werden.
	Zu Infos zu BBCode siehe: https://docs.godotengine.org/en/stable/engine_details/class_reference/index.html#doc-class-reference-bbcode

	clock_start_time
	Definiert die Start-Zeit die in der Taskleiste angezeigt wird. Sie muss im Format "HH:MM" angegeben werden. Wenn die Variable nicht definiert ist oder nicht geladen werden kann, wird die System-Zeit der Spieler*in verwendet.
	
	clock_show_date
	Definiert ob das Datum unter der Uhrzeit in der Taskleiste angezeigt werden soll.
	
	clock_start_date
	Definiert das Start-Datum die in der Taskleiste angezeigt wird. Das Datum muss in dem Format "DD.MM.YYYY" angegeben werden. Wenn die Variable nicht definiert ist oder nicht geladen werden kann, wird die System-Zeit der Spieler*in verwendet.
	HINWEIS: Um 0 Uhr wird der Tag eins hochgezählt, Monat und Jahr bleiben jedoch stets unangetastet. Es können also unrealistische Daten entstehen.
	
	chat_notification_beep_sound & chat_notification_beep_sound
	Über diese Variablen können individuelle Notifizierungs-Beeps definiert werden. Sie müssen sich im Content-Ordner befinden und in einem der unterstützten Formate (.mp3, .ogg, .wav) sein. Wenn die Variablen leer gelassen werden oder die angegebenen Dateien nicht geladen werden können, werden stattdessen die Standard-Sounds verwendet.



// SZENARIO.CSV \\
Über die szenario.csv werden die Inhalte der Szenarien und deren Verknüpfungen definiert. Jede Zeile definiert einen Inhalt. Die genaue Funktion der Zellen der verschiedenen Spalten ist für alle Apps generell identisch aufgebaut. Die PARAMETERS und TRIGGERS Spalten haben jedoch je nach App etwas unterschiedliche Funktionen. Groß- und Kleinschreibung und Leerzeichen wird bei der Erkennung von IDs hierbei generell ignoriert. 
Achtung: Die erste Zeile wird stets als Start des Szenarios geladen und direkt gestartet.

Im Folgenden werden die Spalten und ihre Bedeutung für alle Apps erklärt:

	ID
	Die ID ist eine eindeutige Identifikations-Zeichenfolge über die, die jeweiligen Inhalte angesteuert werden können. Wenn die ID-Zelle leer ist oder bereits eine Zeile mit der selben ID eingelesen wurde, wird die Zeile nicht eingelesen. Es wird dazu eine Warnung in die Debug-Konsole ausgegeben.

	APP
	Hier wird definiert welche APP den Inhalt verarbeiten soll. Wenn keine passende APP gefunden wird, wird der Inhalt ignoriert und nur die angegebenen Trigger ausgelöst. Die implementierten Apps können wie folgt angesteuert werden:
		Chat-App: "chat"
		Moderations-App: "mod"
	
	CID
	Über die CID wird der jeweilige Charakter definiert zu dem der Inhalt gehört. Wenn kein passender Charakter in der characters.csv gefunden wird, wird stattdessen die CID und ggf. ein Standard-Bild angezeigt. Achtung: Auch wenn es sich um eine Spieler*innen-Antwort auf eine Chat-Nachricht handelt, muss die CID des Charakters, auf den geantwortet werden soll, angegeben werden.

	PARAMETERS
	Über die Parameter lässt sich die Darstellung, bzw. Ausführung der Inhalte je nach App anpassen. In diese Zellen werden oft mehrere, durch Komma getrennte Parameter angegeben. Die Reihenfolge und genaue Schreibweise der Parameter spielen dabei eine Rolle!

		Chat-App: 
			1. Nachrichten-Typ: Bestimmt den Nachrichten-Typ, also ob es sich um eine Nachricht von dem Charakter ("message", "msg" oder "m") oder um einen Antwort ("response", "rsp" oder "r") hält. Wenn kein Parameter angegeben wird, wird davon ausgegangen, dass es sich um eine Nachricht von dem Charakter handelt.
			Beispiele: "message", "", "response", "rsp", "r"
			
			2. Override: Bestimmt ob vorherige Antwortmöglichkeiten oder Nachrichten überschrieben werden sollen. Wenn "o", "ovr", "ovrd" oder "override" angegeben wird, werden beim Nachrichten-Typ "Antwort" alle bestehenden Antwortmöglichkeiten und beim Nachrichten-Typ "Nachricht" alle bestehenden Nachrichten aus dem Chat entfernt. Danach wird ggf. die aktuelle Antwort bzw. Nachricht geladen.
			Beispiele: "r,o", "rsp,ovrd", "response,override"
			
		Mod-App:
			1. Moderation: Bestimmt wie mit dem Inhalt idealerweise umgegangen werden sollte. Dabei steht "0" für zulassen und "1" für moderieren. Wenn keine Angabe gemacht wird, wird davon ausgegangen, dass der Inhalt zugelassen werden kann.
			Beispiele: "", "0", "1"
			
			2. Override: Bestimmt ob vorherige Mod-Inhalte überschrieben werden sollen. Wenn "o", "ovr", "ovrd" oder "override" angegeben wird, werden alle bestehenden Posts, inklusive denen im Backlog, entfernt. Danach wird ggf. der neue Inhalt angezeigt.
			Beispiele: "0,o", "1,ovrd", ",override"
			
			3. Inaktive Buttons: Bestimmt ob die Buttons zum Moderieren des Inhalt inaktiv bleiben sollen. Wenn "i", "in" oder "inaktiv" angegeben wird, werden die Buttons zum moderieren nicht aktiv geschaltet, wenn er geladen wird. Das bedeutet jedoch auch, dass die Spieler*in keine Möglichkeit hat den Inhalt zu moderieren, um den nächsten zu sehen. Die Mod-App wird damit praktisch inaktiv geschaltet bis ein neuer Mod-Inhalt mit "Override" ausgelöst wird, der den aktuellen Inhalt (und den Backlog) überschreibt.
			Beispiele: "0,i", "1,in", ",inactive"
		
	DELAY
	Definiert eine Verzögerung des jeweiligen Inhalts in Sekunden. D.h. wenn der Inhalt ausgelöst wird, wird die angegebene Anzahl Sekunden gewartet, bis er ausgeführt wird. Weitere Verzögerungen, wie die Eingabe-Verzögerung der Chat-App, kommen hierbei noch dazu. Wenn die Zeile leer ist, wird auch nicht verzögert.

	CONTENT
	Der jeweilige Inhalt der in der App angezeigt werden soll. In der Regel ein Text-String (Beispiel: "Hallo, i bims!"). Es können aber auch zusätzlich Bilder, Videos und Audio-Dateien aus dem "content"-Ordner geladen, wenn in dem Text der Pfad zur jeweiligen Datei in doppelt eckigen Klammern eingetragen wird (Beispiel: "[[bild.png]]", "[[audio/lied1.mp3]]"). Wenn die Content-Zelle leer gelassen wird, werden nur die entsprechenden Parameter und Trigger abgearbeitet aber Inhalt in der jeweiligen App angezeigt.
	
	Unterstützte werden folgende Formate: 
		Bilder: .png, .jpg, .ktx, .svg, .tga, .webp
		Audio: .mp3, .ogg, .wav
		Video: .ogv
	
	
	TRIGGERS
	Über die Trigger werden mögliche Folge-Inhalte als Komma-getrennte Liste definiert. Wenn die Zeile leer ist oder "-" eingetragen ist, werden keine Folge-Inhalte ausgelöst.
	
		Chat-App:
			In der Chat-App werden immer alle Folge-Inhalte, die aufgelistet sind, ausgelöst. Hierüber werden insbesondere die Antwort-Möglichkeiten der Spieler*innen auf Nachrichten definiert. Folge-Inhalte die bei Antworten angegeben sind, werden erst ausgelöst, wenn diese Antwort-Möglichkeit gewählt wurde.
			Beispiele: "2", "1,2,3", "", "-"
		
		Mod-App:
			Die ersten beiden Stellen der Liste verhalten sich in der Mod-App anders als im Chat. Sie definieren die Reaktionen auf den "Zulassen"- bzw. "Moderieren"-Button. Alle darauf folgenden IDs werden ausgelöst sobald der Post angezeigt wird, also noch bevor moderiert wurde. Wenn auf die jeweilige Moderation keine Reaktion erfolgen soll kann der Listen-Platz leer bleiben oder mit "-" freigehalten werden.
			Beispiele: "1,2", "1,2,5", "", "-,-,4", ",,4"



// CHARACTERS.CSV \\
In der characters.csv werden die Charaktere für die verschiedenen Apps definiert.
	
	CID
	Definiert die Charakter-ID über den die verschiedenen Apps den Charakter ansprechen können.
	
	NAME
	Definiert den Namen der in den Apps für den Charakter angezeigt werden soll. Wenn das Feld leer ist, wird stattdessen die CID in den Apps angezeigt.
	
	PIC
	Hier kann eine Bild-Datei im "content"-Ordner für den Charakter definiert werden. Es muss sich dabei um eine Bild im png-Format handeln. Dieses wird dann ggf. in der App geladen und als Avatar-Bild angezeigt. Wenn das Feld leer ist oder die Datei nicht gefunden oder geladen werden kann, wird stattdessen der Standard-Avatar angezeigt.
	Zusätzlich kann eines der 20 integrierten Charakter-Bilder verwendet werden. Um auf diese Zuzugreifen muss lediglich statt einem Bild der Name des Bildes in eckigen Klammern angegeben werden. Beispiel: [char_001], [char_015], [char_020]
