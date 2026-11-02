-- =====================================================================
--  Séance 3 — démonstration (chinook.db)        ~40 min
--  Ouvrir chinook.db, un seul éditeur SQL (Alt+E), exécuter avec F9.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. COUNT : laisser SQL compter à notre place          (~5 min)
-- ---------------------------------------------------------------------
-- Rappel S1 : on comptait les lignes en bas de la fenêtre de résultats.
SELECT * FROM customers WHERE Country = 'USA';      -- 13 lignes (en bas)

SELECT COUNT(*) FROM customers WHERE Country = 'USA';   -- 13, en une case
SELECT COUNT(*) FROM customers;                         -- 59
-- Message : le résultat n'est plus une liste, c'est UNE ligne, UNE valeur.


-- ---------------------------------------------------------------------
-- 2. SUM, AVG, MIN, MAX                                  (~5 min)
-- ---------------------------------------------------------------------
SELECT SUM(Total) FROM invoices;                        -- 2328.6
SELECT AVG(Total) FROM invoices;                        -- 5.6518...
SELECT ROUND(AVG(Total), 2) FROM invoices;              -- 5.65 (ROUND vu en S2)

-- plusieurs agrégats d'un coup, avec des noms de colonnes (AS, vu en S2)
SELECT COUNT(*) AS nb_factures,
       SUM(Total) AS ca_total,
       ROUND(AVG(Total), 2) AS panier_moyen,
       MIN(Total) AS plus_petite,
       MAX(Total) AS plus_grande
FROM invoices;                                          -- 412 | 2328.6 | 5.65 | 0.99 | 25.86

-- avec un WHERE : l'agrégat porte seulement sur les lignes gardées
SELECT SUM(Total) FROM invoices WHERE BillingCountry = 'France';   -- 195.1


-- ---------------------------------------------------------------------
-- 3. GROUP BY : un résultat PAR pays                     (~10 min)
-- ---------------------------------------------------------------------
-- Problème : le CA de CHAQUE pays. Avec WHERE, il faudrait 24 requêtes...
SELECT SUM(Total) FROM invoices WHERE BillingCountry = 'Germany';  -- 156.48
-- ... et ainsi de suite. GROUP BY fait tout d'un coup :

SELECT BillingCountry, SUM(Total)
FROM invoices
GROUP BY BillingCountry;                                -- 24 lignes

-- Analogie : tableau croisé dynamique (TCD) Excel
--   GROUP BY BillingCountry  = mettre "pays" en lignes
--   SUM(Total)               = mettre "Total" en valeurs, avec "Somme"

-- avec un nom de colonne, et trié (comme en S2) :
SELECT BillingCountry, SUM(Total) AS ca_pays
FROM invoices
GROUP BY BillingCountry
ORDER BY ca_pays DESC;                                  -- USA 523.06 en tête

-- plusieurs agrégats par groupe :
SELECT BillingCountry, COUNT(*) AS nb_factures, SUM(Total) AS ca_pays
FROM invoices
GROUP BY BillingCountry
ORDER BY ca_pays DESC;

-- PIÈGE : une colonne dans le SELECT qui n'est ni regroupée, ni agrégée
SELECT BillingCountry, BillingCity, SUM(Total)
FROM invoices
GROUP BY BillingCountry;
-- SQLite ne dit rien, mais quelle ville afficher pour les USA ? Il y en a 13 :
-- il en prend une au hasard. Le résultat n'a pas de sens.
-- (D'autres logiciels SQL refusent carrément la requête.)
-- RÈGLE : dans le SELECT, seulement des colonnes du GROUP BY + des agrégats.

-- si on veut vraiment les villes : on regroupe par pays ET par ville
SELECT BillingCountry, BillingCity, SUM(Total) AS ca
FROM invoices
GROUP BY BillingCountry, BillingCity
ORDER BY ca DESC;


-- ---------------------------------------------------------------------
-- 4. GROUP BY après une jointure                         (~8 min)
-- ---------------------------------------------------------------------
-- Combien chaque client a-t-il dépensé ? Le nom est dans customers,
-- les montants dans invoices -> jointure (S2), puis regroupement.
SELECT customers.CustomerId, customers.FirstName, customers.LastName,
       COUNT(*) AS nb_factures,
       SUM(invoices.Total) AS total_depense
FROM invoices
JOIN customers ON invoices.CustomerId = customers.CustomerId
GROUP BY customers.CustomerId, customers.FirstName, customers.LastName
ORDER BY total_depense DESC;                            -- Helena Holý, 49.62

-- Pourquoi regrouper par CustomerId et pas seulement par le nom ?
-- Deux clients différents peuvent porter le même nom : regroupés par nom,
-- leurs factures seraient additionnées ensemble. L'id (clé primaire) est
-- unique. -> Dans vos bases individuelles, il y a des homonymes !


-- ---------------------------------------------------------------------
-- 5. HAVING : filtrer les groupes                         (~8 min)
-- ---------------------------------------------------------------------
-- Les pays avec plus de 5 clients
SELECT Country, COUNT(*) AS nb_clients
FROM customers
GROUP BY Country
ORDER BY nb_clients DESC;                               -- USA 13, Canada 8, ...

SELECT Country, COUNT(*) AS nb_clients
FROM customers
GROUP BY Country
HAVING COUNT(*) > 5;                                    -- USA 13, Canada 8 (France et Brésil : 5, pas > 5)

-- Essayer avec WHERE -> erreur (montrer le message) :
SELECT Country, COUNT(*) AS nb_clients
FROM customers
WHERE COUNT(*) > 5
GROUP BY Country;                                       -- misuse of aggregate: COUNT()

-- WHERE filtre les LIGNES avant le regroupement ;
-- HAVING filtre les GROUPES après le regroupement.
-- Les deux ensemble : factures de plus de 10 $, par pays, pays avec au moins 5 telles factures
SELECT BillingCountry, COUNT(*) AS nb_grosses_factures
FROM invoices
WHERE Total > 10
GROUP BY BillingCountry
HAVING COUNT(*) >= 5
ORDER BY nb_grosses_factures DESC;                      -- 5 pays : USA 15, Canada 8, ...

-- Ordre d'écriture, à retenir :
-- SELECT ... FROM ... JOIN ... WHERE ... GROUP BY ... HAVING ... ORDER BY


-- ---------------------------------------------------------------------
-- 6. (optionnel, 2 min) COUNT(*) et COUNT(colonne) : les valeurs vides
-- ---------------------------------------------------------------------
SELECT COUNT(*), COUNT(Company) FROM customers;         -- 59 | 10
-- COUNT(colonne) ne compte pas les cases vides (NULL) :
-- seuls 10 clients ont une entreprise renseignée.
