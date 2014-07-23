# CHR-Minesweeper

Simple Minesweeper application written in Prolog and Constraint Handling Rules (CHR). It was created as an exercise for the "Programming Paradigms" lecture at the [University of Ulm](http://uni-ulm.de). You will find the [tasks below](https://github.com/fnogatz/CHR-Minesweeper#exercises-english-and-german).

## Usage

The complete program can be programmatically used by specifying some `minesweeper/2`, `mine/2` (or `mines/1`) and `check/2` constraints. Have a look at the [Exercises section](https://github.com/fnogatz/CHR-Minesweeper#exercises-english-and-german) for the meanings of these constraints.

To start a Minesweeper game with this Prolog/CHR implementation you can simply use the `main` predicate. First load the source code, for example with [SWI-Prolog](http://www.swi-prolog.org/):

	$ swipl -s Minesweeper

Then call the `main/0` predicate to initialize a new game:

	?- main.
	[Initialization]
	  Numer of Rows:     8.
	  Number of Columns: 8.
	  Number of Mines:   10.
	[Current Field - 0 Seconds]
	   | 1 2 3 4 5 6 7 8 |   
	---+-----------------+---
	 1 | . . . . . . . . | 1 
	 2 | . . . . . . . . | 2 
	 3 | . . . . . . . . | 3 
	 4 | . . . . . . . . | 4 
	 5 | . . . . . . . . | 5 
	 6 | . . . . . . . . | 6 
	 7 | . . . . . . . . | 7 
	 8 | . . . . . . . . | 8 
	---+-----------------+---
	   | 1 2 3 4 5 6 7 8 |   

Now you can check unknown fields by specifying their row and column:

	[Check Location]
	  Row:    1.
	  Column: 1.

	[Current Field - 2 Seconds]
	   | 1 2 3 4 5 6 7 8 |   
	---+-----------------+---
	 1 |     1 . . . . . | 1 
	 2 |     1 . . . . . | 2 
	 3 | 1 1 1 . . . . . | 3 
	 4 | . . . . . . . . | 4 
	 5 | . . . . . . . . | 5 
	 6 | . . . . . . . . | 6 
	 7 | . . . . . . . . | 7 
	 8 | . . . . . . . . | 8 
	---+-----------------+---
	   | 1 2 3 4 5 6 7 8 |   

Other than the original version you can not flag mines, so you have to keep them in mind.

You can also directly start a new game by using the following command:

	$ swipl -s Minesweeper -g main --quiet


## Exercises (English and German)

These are the original tasks. There is an [english](https://github.com/fnogatz/CHR-Minesweeper#english) and [german](https://github.com/fnogatz/CHR-Minesweeper#german) version below.

### English

Minesweeper is a simple computer game, gained its popularity especially from being installed at the Windows platform by default. The aim of the game is to seek the mines on a playing field by using some reasoning.

Therefor the player can reveal some fields. If there is a mine on this field, the game is lost. Otherwise there will be a number which stands for the neighboring mines. This number can therefor be 8 at its maximum.

We want to implement the playing logic behind Minesweeper in CHR to create a text-based application. The given `Play.pl` already contains the required Prolog predicates for the input and output. It is used by the given `Template.pl` which has to be completed in the following tasks.

To remember the size of the playing field, we use a `minesweeper/2` constraint. A playing field with 6 rows and 8 columns can therefor be modelled as follows:

	?- minesweeper(6,8).
	minesweeper(6,8)
	true.

#### a) Generate Mines

A single mine is modelled by a `mine/2` constraint. Therefor `mine(3,5)` represents a mine in the third row and fifth column. The mines should be generated randomly. Therefor a `mines/1` constraint with the amount of mines might be given. Use this constraint to recursively create the mines at the playing field. The remaining `mines(0)` constraint should be removed from the constraint store.

**Tip:**
Use Prolog's predefined predicate `random_between(1,X,R)` to create a random integer `R` between `1` and `X`. By using the `minesweeper/2` constraint you can get the maximum coordinates of the mine.

**Example with random mines:**

	?- minesweeper(6,8), mines(4).
	minesweeper(6,8)
	mine(4,1)
	mine(5,5)
	mine(4,1)
	mine(6,4)
	true .

#### b) Replace Duplicates

As you can see in the previous example, there might be multiples mines with the same coordinates. Add a rule to replace such a duplicate by a new mine.

**Example with random mines:**

	?- minesweeper(6,8), mine(4,1), mine(4,1).
	minesweeper(6,8)
	mine(6,6)
	mine(4,1)
	true .

#### c) Remove `check/2` beyond the `minesweeper/2` boundaries

The revelation of a field by the player is modelled by a `check/2` constraint. `check(3,4)` therefor means, that the the player opens the the third row and fourth column. To prevent multiple revelations of the same field, we use the following simpagation rule to remove them:

	check(A,B) \ check(A,B) <=> true.

Besides that we wand to remove all `check/2` constraints outside of the playing field given by `minesweeper/2`. Implement this by one or more simpagation rules.

**Example:**

	?- minesweeper(6,8), check(4,9), check(0,3), check(3,4), check(5,-1).
	minesweeper(6,8)
	check(3,4)
	true .

#### d) Check: Mine found

Now we want to test if there is a mine at the position given by `check/2`. Implement a rule that writes `That was a mine!` to the standard output and terminates the program via `halt/0` in this case.

**Example:**

	?- mine(3,4), check(3,4).
	That was a mine!%

#### e) Check: Count neighboring Mines

If there is no mine at the position given by `check/2`, the number of neighboring mines must be calculated. This number `Mines` should be hold in a `field(X,Y,Mines)` constraint for the position `(X,Y)`.

**Hint:**
Propage for each neighboring a `field(X,Y,1)`. Afterwards these constraints can be summed.

**Example:**

	?- mine(3,3), mine(1,4), mine(2,4), check(3,4), check(6,6).
	mine(2,4)
	mine(1,4)
	mine(3,3)
	field(3,4,2)
	check(6,6)
	check(3,4)
	true .

#### f) Check: Add default `field/3` Constraint

To create a `field/3` constraint for the fields without any neighboring mine you have to create a `field(X,Y,0)` constraint too. Implement a propagation rule that creates these constraints.

**Example:**

	?- mine(3,3), mine(1,4), mine(2,4), check(3,4), check(6,6).
	mine(2,4)
	mine(1,4)
	mine(3,3)
	field(6,6,0)
	field(3,4,2)
	check(6,6)
	check(3,4)
	true .

#### g) Check all neighbors of `field(X,Y,0)`

If the players reveals a field without any neighboring mine, only a `field(X,Y,0)` constraint will be created. In the ASCII representation this field will be empty. Because this field has no neighboring mine, the player will consequently open the neighboring fields as long as no number greater than 0 appears. Therefor its neighboring fields are revealed in the Windows version by default.

Implement a rule that reveals all the neighboring fields for the current `check/2` constraint once it has no neighboring mine. Why don't we need to check the boundaries of the playing field?


### German

Minesweeper ist ein simples Computerspiel, das vor allem durch seine standardmäßige Installation auf den Windows-Betriebssystemen große Bekanntheit erlangte. Ziel des Spiels ist es, durch logisches Denken herauszufinden, hinter welchen Spielfeldern sich Minen verbergen.

Der Spieler kann dabei auf dem rechteckigen Spielfeld einzelne Felder aufdecken. Verbirgt sich hinter dem aufzudeckenden Feld eine Mine, ist das Spiel verloren. Andernfalls erscheint eine Zahl, die angibt, an wieviele Minen dieses Feld angrenzt. Im Extremfall kann dies also gerade 8 sein.

Wir wollen die Spiellogik hinter Minesweeper mit Hilfe von CHR implementieren und so eine funktionierende, textbasierte Anwendung realisieren. Die gegebene Datei `Play.pl` enthält bereits die zur Ein- und Ausgabe benötigten Prologprädikate. Diese werden von der gegebenen `Template.pl` verwendet, die um die Spiellogik ergänzt werden soll.

Um die Maße des Spielfeldes zu merken, wird ein `minesweeper/2` Constraint verwendet. Ein Spielfeld mit 6 Reihen und 8 Spalten wird somit wie folgt modelliert:

	?- minesweeper(6,8).
	minesweeper(6,8)
	true .

#### a) Zufallsmininen generieren

Eine einzelne Mine wird durch ein `mine/2` Constraint modelliert. `mine(3,5)` steht also für eine Mine in der dritten Zeile und fünften Spalte. Die Minen sollen nun zufällig generiert werden. Hierfür wird ein `mines/1` Constraint mit der Anzahl der Minen übergeben. Erzeuge rekursiv eine entsprechende Anzahl an Minen auf dem Spielfeld. Das verbliebene `mines(0)` Constraint kann aus dem Constraintspeicher entfernt werden.

**Hinweis:**
Verwende das Prolog-Prädikat `random_between(1,X,R)`, um `R` an eine Zufallszahl zwischen `1` und `X` zu binden. Unter Nutzung des `minesweeper/2` Constraints kannst Du die maximalen Koordinaten der Mine bestimmen.

**Beispiel mit zufälligen Minen:**

	?- minesweeper(6,8), mines(4).
	minesweeper(6,8)
	mine(4,1)
	mine(5,5)
	mine(4,1)
	mine(6,4)
	true .

#### b) Duplikate ersetzen

Wie im Beispiel der vorigen Teilaufgabe ersichtlich, könnten so auch zwei Minen auf dem selben Feld generiert werden. Schreibe eine Regel, die ein solches Duplikat durch eine neue Mine ersetzt.

**Beispiel mit zufällig generierter neuer Mine:**

	?- minesweeper(6,8), mine(4,1), mine(4,1).
	minesweeper(6,8)
	mine(6,6)
	mine(4,1)
	true .

#### c) `check/2` außerhalb der `minesweeper/2` Grenzen entfernen

Das Auswählen eines Feldes durch den Spieler wird durch ein `check/2` Constraint modelliert. `check(3,4)` bedeutet also, dass der Spieler das Feld in der dritten Zeile und vierten Spalte abfragt. Um mehrfache Berechnungen auszuschließen, werden über die Simpagationsregel

	check(A,B) \ check(A,B) <=> true.

entsprechende `check/2` Duplikate entfernt. Daneben sollen alle `check/2` Constraints entfernt werden, die sich außerhalb der durch das `minesweeper/2` gegebenen Feldgrenzen befinden. Implementiere eine oder mehrere entsprechende Simpagationsregeln.\\

**Beispiel:**

	?- minesweeper(6,8), check(4,9), check(0,3), check(3,4), check(5,-1).
	minesweeper(6,8)
	check(3,4)
	true .

#### d) Check: Mine gefunden

Nun muss zuerst geprüft werden, ob sich an der durch `check/2` gegebenen Position eine Mine befindet. Definiere eine Regel, die in diesem Falle den Satz `That was a mine!` in die Standardausgabe schreibt und über das Prologprädikat `halt/0` die Programmausführung beendet.

**Beispiel:**

	?- mine(3,4), check(3,4).
	That was a mine!%

#### e) Check: Umliegende Minen zählen

Falls sich an der per `check(X,Y)` übergebenen Position keine Mine befindet, muss die Anzahl der unmittelbar benachbarten Minen bestimmt werden. Diese Anzahl `Mines` soll für das Feld an der Position `(X,Y)` in einem `field(X,Y,Mines)` Constraint festgehalten werden. Propagiere hierzu zunächst für jede benachbarte Mine ein `field(X,Y,1)` Constraint und fasse diese anschließend zusammen.

**Beispiel:**

	?- mine(3,3), mine(1,4), mine(2,4), check(3,4), check(6,6).
	mine(2,4)
	mine(1,4)
	mine(3,3)
	field(3,4,2)
	check(6,6)
	check(3,4)
	true .

#### f) Check: Standard `field/3` hinzufügen

Um auch ein `field/3` Constraint für Felder ohne benachbarte Mine zu erzeugen, muss immer auch ein `field(X,Y,0)` Constraint erzeugt werden. Implementierte eine Propagierungsregel, die dieses Constraint erzeugt.

**Beispiel:**

	?- mine(3,3), mine(1,4), mine(2,4), check(3,4), check(6,6).
	mine(2,4)
	mine(1,4)
	mine(3,3)
	field(6,6,0)
	field(3,4,2)
	check(6,6)
	check(3,4)
	true .

#### g) Alle Nachbarfelder von `field(X,Y,0)` prüfen

Öffnet der Spieler bislang ein Feld ohne benachbarte Mine, wird nur ein `field(X,Y,0)` Constraint für diese Position erzeugt. In der ASCII-Darstellung wird das entsprechende Feld leer dargestellt. Da dieses Feld keine benachbarte Mine besitzt, wird der Spieler in den nächsten Schritten offensichtlich sukzessive die umliegenden Felder öffnen, bis wieder eine Zahl ungleich 0 erscheint. In der Windows-Version werden daher bei einem Feld ohne benachbarte Mine auch gleich die umliegenden Felder geöffnet.

Implementiere eine Regel, die für das aktuelle `check/2` Constraint alle umliegenden Felder per `check/2` öffnet, falls dieses keine benachbarte Mine hat. Wieso müssen die Spielfeldgrenzen nicht beachtet werden?
