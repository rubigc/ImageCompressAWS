# Dokumentation Bildverkleinerung

## 1. Einleitung

Dies ist eine Dokumentation für das Bash-Skript "Bildverkleinerung", das erstellt wurde, um die AWS Cloud-Bildverkleinerungsfunktionen zu nutzen. Dieses Skript erstellt einen AWS S3-Bucket, erstellt eine AWS Lambda-Funktion, fügt einen Trigger hinzu, um die Lambda-Funktion bei der Erstellung von Objekten im Bucket auszulösen, und lädt ein Bild in den Source Bucket hoch, wobei die Verkleinerungsrate und das Ziel-Bucket als Metadaten hinzugefügt werden.

### 2. Autoren

- Ruben Gonzalez Cruz
- Adrian Orlamünde
- Alessandro Melcher

## 3. Variablen erstellen

In diesem Abschnitt werden die erforderlichen Variablen für das Skript initialisiert:

- `IMAGE_PATH`: Der Pfad zum zu verkleinernden Bild.
- `IMAGE_NAME`: Der Name des Bildes.
- `BUCKET_NAME_SRC`: Der Name des Source-Buckets, in dem das Bild hochgeladen wird.
- `BUCKET_NAME_DST`: Der Name des Destination-Buckets, in dem das verkleinerte Bild gespeichert wird.
- `REGION`: Die AWS-Region, in der die Buckets und die Lambda-Funktion erstellt werden.

## 4. Buckets erstellen

Hier werden die beiden S3-Buckets erstellt:

- Der erste Bucket (`$BUCKET_NAME_SRC`) wird erstellt, indem zuerst alle vorhandenen Objekte darin gelöscht werden. Dann wird der Bucket selbst gelöscht und anschließend neu erstellt.

- Der zweite Bucket (`$BUCKET_NAME_DST`) wird auf die gleiche Weise erstellt wie der erste.

## 5. Lambda-Funktion erstellen und ausführen / Trigger hinzufügen

In diesem Abschnitt wird die Lambda-Funktion erstellt und ein Trigger hinzugefügt:

- Die Lambda-Funktion wird erstellt und mit dem Skript `pythonfunction.zip` verknüpft. Sie verwendet Python 3.8 und die Rolle `$LABROLE`.

- Ein Trigger wird hinzugefügt, um die Lambda-Funktion bei der Erstellung von Objekten im Source-Bucket auszulösen. Hier wird auch die Berechtigung für den Trigger definiert.

## 6. Bild in den Source Bucket hochladen

Abschließend wird das Bild in den Source-Bucket hochgeladen. Dabei wird der Benutzer aufgefordert, die Verkleinerungsrate einzugeben, die als Metadaten zusammen mit dem Ziel-Bucket in das Objekt eingefügt wird.

Das Skript ist nun vollständig dokumentiert und ermöglicht es Benutzern, AWS Cloud-Bildverkleinerungsfunktionen mithilfe dieses Bash-Skripts zu nutzen.