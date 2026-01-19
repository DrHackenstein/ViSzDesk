
	/// ViSzDesk README \\\

ViSzDesk ist ein Virtueller Szenarien Desktop. Mit dem ersten Start werden eine Reihe Konfigurations-Dateien in einen "content"-Unterordner generiert, wenn sie nicht bereits existieren. Über diese Konfigurations-Dateien können individuelle Desktop-Szenarien erstellt werden.

Im Folgenden werden die Konfigurations-Dateien erklärt.



// CONFIG.CFG \\
Über die config.cfg können generelle Einstellungen getätigt werden, wie einzelne Apps an und aus geschaltet werden. Die neu generierte config.cfg enthält alle möglichen Einstellungsmöglichkeiten mit ihren Standard-Werten. Sie sind selbsterklärend.



// CONTENT.CSV \\
Über die content.csv werden die Inhalte der Szenarien und deren Verknüpfungen definiert. Jede Zeile definiert einen Inhalt. Die genaue Funktion der Zellen der verschiedenen Spalten ist für alle Apps generell identisch aufgebaut. Die PARAMETERS und TRIGGERS Spalten haben jedoch je nach App etwas unterschiedliche Funktionen. Groß- und Kleinschreibung und Leerzeichen wird bei der Erkennung von IDs hierbei generell ignoriert. 
Achtung: Die erste Zeile wird stets als Start des Szenarios geladen und direkt gestartet.

Im Folgenden werden die Spalten und ihre Bedeutung für alle Apps erklärt:

	ID
	Die ID ist eine eindeutige Identifikations-Zeichenfolge über die, die jeweiligen Inhalte angesteuert werden können.

	APP
	Hier wird definiert welche APP den Inhalt verarbeiten soll. Wenn keine passende APP gefunden wird, wird der Inhalt ignoriert.
	Die verschiedenen Apps werden wie folgt angesteuert:
		Chat-App: chat 
		Moderations-App: mod
	
	CID
	Über die CID wird der jeweilige Charakter definiert zu dem der Inhalt gehört. Wenn kein passender Charakter in der characters.csv gefunden wird, wird stattdessen die CID und ggf. ein Standard-Bild angezeigt. Achtung: Auch wenn es sich um eine Spieler*innen-Antwort auf eine Chat-Nachricht handelt, muss die CID des Charakters, auf den geantwortet werden soll, angegeben werden.

	PARAMETERS
	Über die Parameter lässt sich die Darstellung, bzw. Ausführung der Inhalte je nach App anpassen. In diese Zellen werden oft mehrere, durch Komma getrennte Parameter angegeben. Die Reihenfolge und genaue Schreibweise der Parameter spielen dabei eine Rolle!

		Chat-App: 
			Parameter 1: Bestimmt ob es sich um eine Nachricht von dem Charakter ("message", "msg" oder "m") oder um einen Antwort ("response", "rsp" oder "r") hält. Wenn kein Parameter angegeben wird, wird davon ausgegangen, dass es sich um eine Nachricht von dem Charakter handelt.
			Beispiele: "message", "", "response", "rsp", "r"
			
		Mod-App:
			Parameter 1: Bestimmt wie mit dem Inhalt idealerweise umgegangen werden sollte. Dabei steht "0" für zulassen und "1" für moderieren. Wenn keine Angabe gemacht wird, wird davon ausgegangen, dass der Inhalt zugelassen werden kann.
		
	DELAY
	Definiert eine Verzögerung des jeweiligen Inhalts in Sekunden. D.h. wenn der Inhalt ausgelöst wird, wird die angegebene Anzahl Sekunden gewartet, bis er ausgeführt wird. Weitere Verzögerungen, wie die Eingabe-Verzögerung der Chat-App, kommen hierbei noch dazu. Wenn die Zeile leer ist, wird auch nicht verzögert.

	CONTENT
	Der jeweilige Inhalt der in der App angezeigt werden soll. In der Regel ein Text-String (Beispiel: "Hallo, i bims!"). Es können aber auch Bilder, Videos und Audio-Dateien aus dem "content"-Ordner geladen, wenn statt einem Text der Pfad zur jeweiligen Datei in eckigen Klammern eingetragen wird (Beispiel: "[bild.png]", "[audio/lied1.mp3]")
	Unterstützte Formate sind: TBD
	
	TRIGGERS
	Über die Trigger werden mögliche Folge-Inhalte als Komma-getrennte Liste definiert. Wenn die Zeile leer ist oder "-" eingetragen ist, werden keine Folge-Inhalte ausgelöst.
	
		Chat-App:
			In der Chat-App werden immer alle Folge-Inhalte, die aufgelistet sind, ausgelöst. Hierüber werden insbesondere die Antwort-Möglichkeiten der Spieler*innen auf Nachrichten definiert. Folge-Inhalte die bei Antworten angegeben sind, werden erst ausgelöst, wenn diese Antwort-Möglichkeit gewählt wurde.
			Beispiele: "2", "1,2,3", "", "-"
		
		Mod-App:
			Die ersten beiden Stellen der Liste verhalten sich in der Mod-App anders als im Chat. Sie definieren die Reaktionen auf den "Zulassen"- bzw. "Moderieren"-Button. Alle darauf folgenden IDs werden ausgelöst unabhängig davon wie moderiert wurde. Wenn auf die jeweilige Moderation keine Reaktion erfolgen soll kann der Listen-Platz leer bleiben oder mit "-" freigehalten werden.
			Beispiele: "1,2", "1,2,5", "", "-,-,4", ",,4"



// CHARACTERS.CSV \\
In der characters.csv werden die Charaktere für die verschiedenen Apps definiert.
	
	CID
	Definiert die Charakter-ID über den die verschiedenen Apps den Charakter ansprechen können.
	
	NAME
	Definiert den Namen der in den Apps für den Charakter angezeigt werden soll. Wenn das Feld leer ist, wird stattdessen die CID in den Apps angezeigt.
	
	PIC
	Hier kann eine Bild-Datei im "content"-Ordner für den Charakter definiert werden. Dieses wird dann ggf. in der App geladen und als Avatar-Bild angezeigt. Wenn das Feld leer ist oder die Datei nicht gefunden oder geladen werden kann, wird stattdessen der Standard-Avatar angezeigt.



// CREDITS.TXT \\
	Die credits.txt ist eine einfache Textdatei, die auf dem Desktop von Spieler*inne eingesehen werden kann. Sie hat keine weiteren Funktionen und dient einfach der korrekten Akkreditierung der an dem Projekt beteiligten Personen.
