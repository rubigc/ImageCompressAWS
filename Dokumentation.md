# Dokumentation Bildverkleinerung

## 1. Einleitung

Dies ist eine Dokumentation für das Bash-Skript "Bildverkleinerung", das erstellt wurde, um die AWS Cloud-Bildverkleinerungsfunktionen zu nutzen. Dieses Skript erstellt einen AWS S3-Bucket, erstellt eine AWS Lambda-Funktion, fügt einen Trigger hinzu, um die Lambda-Funktion bei der Erstellung von Objekten im Bucket auszulösen, und lädt ein Bild in den Source Bucket hoch, wobei die Verkleinerungsrate und das Ziel-Bucket als Metadaten hinzugefügt werden.

### Autoren

- Ruben Gonzalez Cruz
- Adrian Orlamünde
- Alessandro Melcher

### Ausführung

Navigieren Sie mit dem Befehl "cd" in das Verzeichnis, in dem sich alle Projektdateien befinden. Führen Sie dann den folgenden Befehl aus: "./script.sh".

## 2. Variablen erstellen

In diesem Abschnitt werden die erforderlichen Variablen für das Skript initialisiert:

- `IMAGE_PATH`: Der Pfad zum zu verkleinernden Bild.
- `IMAGE_NAME`: Der Name des Bildes.
- `BUCKET_NAME_SRC`: Der Name des Source-Buckets, in dem das Bild hochgeladen wird.
- `BUCKET_NAME_DST`: Der Name des Destination-Buckets, in dem das verkleinerte Bild gespeichert wird.
- `REGION`: Die AWS-Region, in der die Buckets und die Lambda-Funktion erstellt werden.

<img src="/Images/Variablen.png" height="150" Width="400"/>

## 3. Buckets erstellen

Hier werden die beiden S3-Buckets erstellt:

- Der erste Bucket (`$BUCKET_NAME_SRC`) wird erstellt, indem zuerst alle vorhandenen Objekte darin gelöscht werden. Dann wird der Bucket selbst gelöscht und anschließend neu erstellt.

- Der zweite Bucket (`$BUCKET_NAME_DST`) wird auf die gleiche Weise erstellt wie der erste.

<img src="/Images/Buckets.png" height="400" Width="550"/>

## 4. Lambda-Funktion erstellen und ausführen / Trigger hinzufügen

In diesem Abschnitt wird die Lambda-Funktion erstellt und ein Trigger hinzugefügt:

- Die Lambda-Funktion wird erstellt und mit dem Skript `pythonfunction.zip` verknüpft. Sie verwendet Python 3.8 und die Rolle `$LABROLE`.

- Ein Trigger wird hinzugefügt, um die Lambda-Funktion bei der Erstellung von Objekten im Source-Bucket auszulösen. Hier wird auch die Berechtigung für den Trigger definiert.

<img src="/Images/Lambda.png" height="700" Width="1200"/>

## 5. Bild in den Source Bucket hochladen

Abschließend wird das Bild in den Source-Bucket hochgeladen. Dabei wird die Verkleinerungsrate als Metadaten zusammen mit dem Ziel-Bucket in das Objekt eingefügt. Die Variable für die Verkleinerungsrate wird im Script initialisiert, ohne dass der Benutzer dazu aufgefordert wird, den Wert einzugeben.

<img src="/Images/Hochladen.png" height="100" width="900"/>

## 6. Mögliche Probleme

Da es sich um ein Bash-Skript handelt, sollten Unix-Zeilenumbrüche (LF) verwendet werden, während Windows Zeilenumbrüche mit CRLF hat. Wenn Sie die Datei von GitHub auf Windows herunterladen, könnte es zu Fehlern kommen. Bitte verwenden Sie die Datei, die wir Ihnen in der .zip-Datei via Teams mitgeschickt haben, um diese Probleme zu vermeiden. Andernfalls können Sie das Tool dos2unix verwenden, um die Datei kurzfristig zu konvertieren.

## 7. Reflexion

### Adrian
Aus meiner Perspektive verlief das Projekt sehr erfolgreich. Die Aufgabenverteilung innerhalb unseres Teams war effektiv, da wir die individuellen Stärken jedes Mitglieds optimal nutzen konnten. Meine Aufgabe konzentrierte sich auf die Lambda-Funktion und deren Trigger, während Alessandro für das Bash-Skript und die Erstellung der Buckets zuständig war. Ruben wiederum entwickelte das Python-Skript zur Datenverkleinerung.

Zu Beginn arbeiteten wir unabhängig an verschiedenen Teilen des Projekts. Nachdem jeder seinen Abschnitt fertiggestellt hatte, führten wir die einzelnen Komponenten zusammen. Während der Integration überprüften und diskutierten wir den gesamten Code gemeinsam, was zu wertvollen Ergänzungen und Verbesserungen führte.

Zeitlich gesehen war unser Zeitplan recht straff, doch es gelang uns, alles rechtzeitig fertigzustellen. Darüber hinaus blieb uns genügend Zeit, um das Gesamtsystem gründlich zu testen und sicherzustellen, dass alles reibungslos funktioniert.

### Ruben
Das Projekt war aus meiner Sicht ein großer Erfolg. Wir haben die Stärken jedes Teammitglieds effektiv genutzt. Meine Hauptaufgabe lag in der Entwicklung des Python-Skripts zur Datenverkleinerung, während meine Teamkollegen sich auf andere Bereiche konzentrierten. Anfangs arbeiteten wir unabhängig, aber die spätere Integration und gemeinsame Überprüfung des Codes führten zu wichtigen Verbesserungen.

Besonders zufriedenstellend war unser Zeitmanagement. Trotz eines straffen Zeitplans gelang es uns, alle Aufgaben rechtzeitig abzuschließen und ausreichend Zeit für umfassende Tests zu haben, um die Funktionalität unseres Systems zu gewährleisten.

Ich hatte auch einige Probleme bei der Lambda-Funktion und der Verpackung der Bibliotheken, aber nach dem Konsultieren einer bestimmten Dokumentation für bestimmte Python-Bibliotheken, die dies erforderten, konnte ich das Problem mit dem Import lösen, indem ich diese Bibliotheken im Voraus kompilierte.

### Alessandro
Das Projekt war im Großen und Ganzen eine lehrreiche Erfahrung. Dank vorheriger Übungen verlief die Umsetzung fast reibungslos, und ich konnte effizient das Skript erstellen. Die Integration von S3-Funktionalitäten zeigte die praktische Anwendbarkeit von Bash-Scripting im Cloud-Umfeld.

Allerdings stellten sich auch Herausforderungen, insbesondere das Übergeben von Übergabeparametern an die in Python geschriebene Lambda-Funktion und das Zeitmanagement. Ich nehme mir vor, für das nächste Projekt etwas früher zu beginnen. Obwohl alles geklappt hat, wäre es viel angenehmer gewesen, wenn wir das Projekt etwas früher gestartet hätten.

Trotz dieser Herausforderungen betrachte ich die Erfahrung insgesamt als gewinnbringend für meine technischen Fähigkeiten.