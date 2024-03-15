# Fonction pour reconstruire le chemin depuis l'arrivée
function chemin_optimal(chemin_final, distances, depart, arrivee, case_actuelle)
    if distances[arrivee[1], arrivee[2]] != -1
        case_actuelle = arrivee

        while case_actuelle != depart
            pushfirst!(chemin_final, case_actuelle)

            for (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)]
                suivant = (case_actuelle[1] + dx, case_actuelle[2] + dy)

                if 1 <= suivant[1] <= size(grille, 1) && 1 <= suivant[2] <= size(grille, 2) && distances[suivant[1], suivant[2]] == distances[case_actuelle[1], case_actuelle[2]] - 1
                    case_actuelle = suivant
                    break
                end
            end
        end
        pushfirst!(chemin_final, depart)
    end

    return chemin_final
end

# Algorithme flood fill
function flood_fill(grille, depart, arrivee)
    # Créer une grille pour enregistrer les distances
    distances = fill(-1, size(grille))

    # On initialise la distance du point de départ à 0
    distances[depart[1], depart[2]] = 0

    # File d'attente pour le flood fill
    file = [(depart, 0)]

    # Liste du chemin le plus court, potentiellement vide
    chemin_final = []

    # Initialisation de la case_actuelle pour une utilisation sur tout le scope de la fonction
    case_actuelle = depart

    while !isempty(file)
        case_actuelle, distance = popfirst!(file)

        # Si on a atteint l'arrivée, on arrête la boucle
        if case_actuelle == arrivee
            break
        end

        # On parcour les cases voisines
        for (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)]
            suivant = (case_actuelle[1] + dx, case_actuelle[2] + dy)

            # On vérifie si le voisin est valide
            if 1 <= suivant[1] <= size(grille, 1) && 1 <= suivant[2] <= size(grille, 2) && grille[suivant[1], suivant[2]] == 0 && distances[suivant[1], suivant[2]] == -1
                # On met à jour la distance du voisin
                distances[suivant[1], suivant[2]] = distance + 1

                # On ajoute le voisin à la file d'attente
                push!(file, (suivant, distance + 1))
            end
        end
    end

    return chemin_optimal(chemin_final, distances, depart, arrivee, case_actuelle)
end

# Grille avec obstacles (1)
grille = [
    0 0 0 0 0;
    0 1 1 1 0;
    0 0 0 1 0;
    0 1 1 1 0;
    0 0 0 0 0
]

depart = (1, 1)
arrivee = (3, 3)

chemin = flood_fill(grille, depart, arrivee)
println("Chemin le plus court : ", chemin)
