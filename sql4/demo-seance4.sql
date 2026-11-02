-- =====================================================================
--  Séance 4 — démonstration                                   ~45 min
--  Base de démo : demo.db (copie de la base de secours L.db : ne plus
--  l'attribuer à un étudiant). Puis chinook.db pour la partie 6.
--  SQLiteStudio : Ctrl+O, Alt+E, F9 (exécute la requête sous le curseur).
--  sqliteonline.com : File → Open DB ; Run exécute TOUT l'éditeur :
--  sélectionner la commande avant de cliquer (le dire aux étudiants au début).
-- =====================================================================


-- ---------------------------------------------------------------------
-- 0. Où on en est                                          (~3 min)
-- ---------------------------------------------------------------------
-- Jusqu'ici on a seulement LU des bases (SELECT).
-- Aujourd'hui : on CRÉE une table, on AJOUTE, MODIFIE, SUPPRIME des lignes.
-- Puis on s'en sert pour une jointure sur TROIS tables (niveau examen).
-- Rappel de l'ordre des clauses :
--   SELECT … FROM … JOIN … ON … WHERE … GROUP BY … HAVING … ORDER BY …


-- ---------------------------------------------------------------------
-- 1. Les types de colonnes                                 (~3 min)
-- ---------------------------------------------------------------------
-- Chaque colonne a un type. Voir la structure d'une table (marche dans
-- SQLiteStudio comme dans sqliteonline) :
PRAGMA table_info(clients);
-- une ligne par colonne : name, type, notnull (1 = obligatoire), pk (1 = clé primaire)
--   id INTEGER pk=1 | nom TEXT notnull=1 | ville TEXT notnull=1
--   INTEGER = nombre entier   REAL = nombre à virgule   TEXT = texte
-- NOT NULL = la case ne peut pas rester vide.
-- PRIMARY KEY = clé primaire : identifie chaque ligne, jamais deux fois la même.
SELECT * FROM produits;
-- 15 produits, id 1 à 15 : on aura besoin de ces id en partie 5

-- Guillemets : pour du TEXTE, on écrit des apostrophes simples : 'Paris'.
-- SQLiteStudio accepte aussi "Paris", mais "..." désigne normalement un NOM
-- de colonne : WHERE ville = "nom" compare la ville à la colonne nom !
-- À partir d'aujourd'hui : 'texte'.


-- ---------------------------------------------------------------------
-- 2. CREATE TABLE : créer une table                        (~7 min)
-- ---------------------------------------------------------------------
-- La commande qui a créé la table clients (= onglet DDL de SQLiteStudio) :
SELECT sql FROM sqlite_master WHERE name = 'clients';
-- CREATE TABLE clients (id INTEGER PRIMARY KEY, nom TEXT NOT NULL, ville TEXT NOT NULL)
-- C'est exactement ce qu'on va écrire maintenant pour une nouvelle table.
-- (DDL = Data Definition Language : les commandes qui définissent la STRUCTURE,
--  CREATE TABLE, ALTER TABLE ; par opposition à SELECT, INSERT, UPDATE, DELETE.)

-- On veut savoir quel fournisseur livre chaque produit.
CREATE TABLE fournisseurs (
    id   INTEGER PRIMARY KEY,
    nom  TEXT NOT NULL,
    pays TEXT
);
-- La table apparaît dans le panneau de gauche (rafraîchir si besoin), vide :
SELECT * FROM fournisseurs;                   -- 0 ligne


-- ---------------------------------------------------------------------
-- 3. INSERT : ajouter des lignes                           (~7 min)
-- ---------------------------------------------------------------------
-- une ligne : on liste les colonnes, puis les valeurs dans le même ordre
INSERT INTO fournisseurs (id, nom, pays) VALUES (1, 'Bureau Plus', 'France');

-- plusieurs lignes d'un coup, séparées par des virgules
INSERT INTO fournisseurs (id, nom, pays) VALUES
    (2, 'TechDistri', 'Allemagne'),
    (3, 'Maison & Co', 'Espagne');
SELECT * FROM fournisseurs;                   -- 3 lignes

-- ERREUR volontaire 1 : deux fois la même clé primaire
INSERT INTO fournisseurs (id, nom, pays) VALUES (3, 'Doublon', 'Italie');
-- -> UNIQUE constraint failed: fournisseurs.id   (la clé primaire protège)

-- ERREUR volontaire 2 : nom obligatoire (NOT NULL) oublié
INSERT INTO fournisseurs (id, pays) VALUES (4, 'Italie');
-- -> NOT NULL constraint failed: fournisseurs.nom

-- sans donner d'id : SQLite prend le numéro suivant tout seul
INSERT INTO fournisseurs (nom, pays) VALUES ('Papeterie du Nord', 'Belgique');
SELECT * FROM fournisseurs;                   -- id 4 attribué automatiquement


-- ---------------------------------------------------------------------
-- 4. ALTER TABLE : ajouter une colonne (clé étrangère)     (~5 min)
-- ---------------------------------------------------------------------
-- Chaque produit doit pointer vers son fournisseur : une clé étrangère.
ALTER TABLE produits ADD COLUMN fournisseur_id INTEGER REFERENCES fournisseurs(id);
SELECT * FROM produits;                       -- nouvelle colonne, vide (NULL) partout


-- ---------------------------------------------------------------------
-- 5. UPDATE et DELETE : modifier, supprimer               (~10 min)
-- ---------------------------------------------------------------------
-- TOUJOURS : d'abord un SELECT avec le WHERE, pour voir les lignes touchées
SELECT * FROM produits WHERE id IN (2, 5, 6, 7, 11, 13);   -- la papeterie, 6 lignes

UPDATE produits SET fournisseur_id = 1 WHERE id IN (2, 5, 6, 7, 11, 13);
UPDATE produits SET fournisseur_id = 2 WHERE id IN (1, 8, 10, 12);
UPDATE produits SET fournisseur_id = 3 WHERE id IN (3, 4, 9, 14, 15);
SELECT * FROM produits;                       -- chaque produit a son fournisseur

-- UPDATE avec un calcul : Bureau Plus augmente ses prix de 5 %
SELECT nom, prix, ROUND(prix * 1.05, 2) AS nouveau_prix
FROM produits WHERE fournisseur_id = 1;       -- on regarde AVANT (6 produits)
UPDATE produits SET prix = ROUND(prix * 1.05, 2) WHERE fournisseur_id = 1;
SELECT nom, prix FROM produits WHERE fournisseur_id = 1;   -- Calculatrice 111.13 -> 116.69

-- PIÈGE : on relance la MÊME commande une deuxième fois (volontairement) :
UPDATE produits SET prix = ROUND(prix * 1.05, 2) WHERE fournisseur_id = 1;
SELECT nom, prix FROM produits WHERE fournisseur_id = 1;   -- Calculatrice 116.69 -> 122.52 !
-- La base ne se souvient pas que l'augmentation a déjà été faite : chaque
-- exécution ajoute encore 5 %. Pareil pour INSERT (ligne en double).
-- RÈGLE : une commande qui modifie la base s'exécute UNE SEULE FOIS.
-- En cas d'erreur : on repart de la base d'origine. (sqliteonline : attention,
-- Run réexécute tout l'éditeur ; sélectionner la commande avant de cliquer.)
-- Remarque : les montants des commandes déjà passées ne changent pas
-- (ils sont stockés dans commandes, pas recalculés à partir du prix).

-- DANGER : sans WHERE, la commande touche TOUTES les lignes.
--   UPDATE produits SET prix = 0;    -- tous les prix à 0 ! (ne pas exécuter)
--   DELETE FROM commandes;           -- toutes les commandes effacées !
-- Pas de bouton « annuler » : on repart de la base d'origine.

-- DELETE : supprimer les commandes de moins de 30
SELECT COUNT(*) FROM commandes WHERE montant < 30;   -- 12 vont partir
DELETE FROM commandes WHERE montant < 30;
SELECT COUNT(*) FROM commandes;               -- 315 -> 303

-- ajouter puis supprimer un client test
INSERT INTO clients (nom, ville) VALUES ('Test', 'IUT');
SELECT * FROM clients WHERE ville = 'IUT';    -- id 92
DELETE FROM clients WHERE id = 92;


-- ---------------------------------------------------------------------
-- 6. Jointure sur trois tables                            (~12 min)
-- ---------------------------------------------------------------------
-- Si quelque chose a mal tourné avant : rouvrir une copie neuve de L.db
-- et exécuter demo-rattrapage.sql (une fois), puis reprendre ici.
-- Le chiffre d'affaires par fournisseur : les montants sont dans commandes,
-- le lien commande -> produit dans commandes.produit_id,
-- le lien produit -> fournisseur dans produits.fournisseur_id.
-- On enchaîne les JOIN, un par lien :
SELECT commandes.id, produits.nom, fournisseurs.nom, commandes.montant
FROM commandes
JOIN produits     ON commandes.produit_id = produits.id
JOIN fournisseurs ON produits.fournisseur_id = fournisseurs.id;

-- puis on regroupe, comme en séance 3 :
SELECT fournisseurs.nom, COUNT(*) AS nb_commandes,
       ROUND(SUM(commandes.montant), 2) AS ca
FROM commandes
JOIN produits     ON commandes.produit_id = produits.id
JOIN fournisseurs ON produits.fournisseur_id = fournisseurs.id
GROUP BY fournisseurs.id, fournisseurs.nom
ORDER BY ca DESC;   -- Bureau Plus 121 | 23567.67, Maison & Co 101 | 14979.71, TechDistri 81 | 14706.84
-- Papeterie du Nord n'apparaît pas : aucun produit ne la référence
-- (JOIN ne garde que les lignes qui ont une correspondance).

-- même chose sur chinook (ouvrir chinook.db, vérifier la base choisie !) :
-- une piste appartient à un album, un album appartient à un artiste.
--   tracks.AlbumId -> albums.AlbumId      albums.ArtistId -> artists.ArtistId
-- On enchaîne les deux JOIN, un par lien :
SELECT tracks.Name, albums.Title, artists.Name
FROM tracks
JOIN albums  ON tracks.AlbumId = albums.AlbumId
JOIN artists ON albums.ArtistId = artists.ArtistId;
-- 3503 lignes : For Those About To Rock (We Salute You) | ... | AC/DC, ...

-- avec WHERE (avant les groupes) et HAVING (après) :
-- les artistes qui ont au moins 50 pistes de plus de 5 minutes
SELECT artists.Name, COUNT(*) AS nb_pistes_longues
FROM tracks
JOIN albums  ON tracks.AlbumId = albums.AlbumId
JOIN artists ON albums.ArtistId = artists.ArtistId
WHERE tracks.Milliseconds > 300000
GROUP BY artists.ArtistId, artists.Name
HAVING COUNT(*) >= 50
ORDER BY nb_pistes_longues DESC;
-- Iron Maiden 117, Lost 91, Metallica 75, Led Zeppelin 54, The Office 53
-- (chinook contient aussi des épisodes de séries TV : Lost, The Office)


-- ---------------------------------------------------------------------
-- 7. Pour la suite                                         (~3 min)
-- ---------------------------------------------------------------------
-- Devoir 4 : même démarche sur VOTRE base (table categories), à rendre sur Teams.
--   Le fichier sera exécuté en entier sur une copie neuve de votre base :
--   chaque commande une seule fois, dans l'ordre.
-- Examen blanc : sur GitHub, à faire chez vous SUR PAPIER, sans ordinateur,
--   en temps limité (2 h). Corrigé publié ensuite.
-- Examen : vendredi 20 novembre, sur papier.
