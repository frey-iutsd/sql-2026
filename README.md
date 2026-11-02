# BDD SQL — BUT3 FA GEA 2026-2027

*IUT de Saint-Denis — cours de Jonas Frey*

Tous les documents du cours sont ici. Pour télécharger un fichier : cliquez dessus, puis sur le bouton de téléchargement (« Download raw file », icône ⤓ en haut à droite).

## Notes de cours

- **[notes/notes-S1-S4.pdf](notes/notes-S1-S4.pdf)** : résumé de tout ce qui a été vu (séances 1 à 4). C'est le document à utiliser pour réviser l'examen.

## Bases de données

- **[sql2/chinook.db](sql2/chinook.db)** : la base des démonstrations (musique). Son schéma (tables et liens) : https://www.sqlitetutorial.net/sqlite-sample-database/
- **[sql2/bdd/](sql2/bdd/)** : les bases individuelles. Prenez le fichier qui porte **votre numéro étudiant** (par exemple `12401234.db`). Si on vous a attribué une lettre (A, B…), prenez le fichier de cette lettre.

## Logiciel

- **SQLiteStudio 3.4.21** (la version des salles de l'IUT) : https://github.com/pawelsalawa/letos/releases/tag/3.4.21 — Windows : `…windows-x64-installer.exe`, Mac : `…macos-x64-installer.dmg`.
- **Sans rien installer (Mac compris)** : https://sqliteonline.com/ — menu **File → Open DB**, puis choisissez votre fichier `.db`.

## Séances et devoirs

| Séance | Date | Contenu | Documents |
|---|---|---|---|
| 1 | 9 sept. | `SELECT`, `WHERE`, `LIKE`, `AND`/`OR`/`IN` | TD1 (sur Teams) |
| 2 | 21 sept. | `DISTINCT`, `ORDER BY`, colonnes calculées, clés, `JOIN` | [diaporama](sql2/), Devoir 2 (sur Teams) |
| 3 | 19 oct. | `COUNT`/`SUM`/`AVG`…, `GROUP BY`, `HAVING` | [diaporama](sql3/seance3-slides.pdf), [Devoir 3](sql3/devoir3.pdf), [démonstration](sql3/demo-seance3.sql) |
| 4 | 3 nov. | `CREATE TABLE`, `INSERT`, `UPDATE`, `DELETE`, jointures sur trois tables | [Devoir 4](sql4/devoir4.pdf) |
| Examen | **ven. 20 nov.** | écrit, sur papier, sans ordinateur | [examen blanc](examen-blanc/examen-blanc.pdf) (corrigé publié ensuite) |

## Rendre un devoir

Un fichier texte `Prénom-NOM-SQL-DevoirN.txt` : une ligne `-- exercice N` avant chaque réponse, les requêtes telles quelles, les réponses qui ne sont pas des requêtes précédées de `--`. Déposez-le dans le devoir correspondant sur Teams, puis cliquez sur **Rendre**.
