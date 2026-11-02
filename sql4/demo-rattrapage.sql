-- =====================================================================
--  Séance 4 — RATTRAPAGE de la démo
--  Si la démo a mal tourné (commande relancée, erreur…) : rouvrir une copie
--  NEUVE de L.db, sélectionner tout ce fichier et l'exécuter une fois.
--  On retrouve alors exactement l'état attendu au début de la partie 6.
-- =====================================================================
CREATE TABLE fournisseurs (
    id   INTEGER PRIMARY KEY,
    nom  TEXT NOT NULL,
    pays TEXT
);
INSERT INTO fournisseurs (id, nom, pays) VALUES
    (1, 'Bureau Plus', 'France'),
    (2, 'TechDistri', 'Allemagne'),
    (3, 'Maison & Co', 'Espagne'),
    (4, 'Papeterie du Nord', 'Belgique');
ALTER TABLE produits ADD COLUMN fournisseur_id INTEGER REFERENCES fournisseurs(id);
UPDATE produits SET fournisseur_id = 1 WHERE id IN (2, 5, 6, 7, 11, 13);
UPDATE produits SET fournisseur_id = 2 WHERE id IN (1, 8, 10, 12);
UPDATE produits SET fournisseur_id = 3 WHERE id IN (3, 4, 9, 14, 15);
UPDATE produits SET prix = ROUND(prix * 1.05, 2) WHERE fournisseur_id = 1;
DELETE FROM commandes WHERE montant < 30;
-- vérification : doit afficher 303
SELECT COUNT(*) FROM commandes;
