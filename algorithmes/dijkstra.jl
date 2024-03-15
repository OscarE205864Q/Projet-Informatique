# Importation d'un module pour utiliser des structures de données avancées
using DataStructures

# Structure de noeud pour l'algorithme de Dijkstra
struct Node
    position::Tuple{Int, Int}
    distance::Int
end

# Fonction pour initialiser la file de priorité avec les distances
function initialiser_file(grille, depart)
    file = PriorityQueue{Node, Int}()
    distances = Dict{Tuple{Int, Int}, Int}()

    for i in 1:size(grille, 1), j in 1:size(grille, 2)
        distances[(i, j)] = 10000  # On prend un nombre très grand
    end

    distances[depart] = 0
    enqueue!(file, Node(depart, 0), 0)

    return file, distances
end

# Fonction pour reconstruire le chemin depuis l'arrivée
function chemin_optimal(depart, arrivee, case_actuelle, precedents)
    chemin = []
    case_actuelle = arrivee

    while case_actuelle != depart
        pushfirst!(chemin, case_actuelle)

        # Si la case d'arrivée n'est pas dans le dictionnaire, c'est qu'on ne l'a jamais atteinte
        if !(case_actuelle in collect(keys(precedents)))
            return []
        end

        case_actuelle = precedents[case_actuelle]
    end

    pushfirst!(chemin, depart)

    return chemin
end

# Algorithme de Dijkstra
function dijkstra_algo(grille, depart, arrivee)
    # Initialisation des structures de données
    file, distances = initialiser_file(grille, depart)
    precedents = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()

    # Initialisation de case_actuelle pour une utilisation sur tout le scope de la fonction
    case_actuelle = depart

    while !isempty(file)
        node = dequeue!(file)
        case_actuelle, distance_actuelle = node.position, node.distance
        # Si on atteint l'arrivée, on arrête la boucle
        if case_actuelle == arrivee
            break
        end

        for (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)]
            suivant = (case_actuelle[1] + dx, case_actuelle[2] + dy)

            # On teste si la case vers laquelle on essaye d'aller est valide
            if 1 <= suivant[1] <= size(grille, 1) && 1 <= suivant[2] <= size(grille, 2) && grille[suivant[1], suivant[2]] == 0
                nouvelle_distance = distance_actuelle + 1

                # On met à jour le dictionnaire des distances
                if nouvelle_distance < distances[suivant]
                    distances[suivant] = nouvelle_distance
                    enqueue!(file, Node(suivant, nouvelle_distance), nouvelle_distance)
                    precedents[suivant] = case_actuelle
                end
            end
        end
    end

    return chemin_optimal(depart, arrivee, case_actuelle, precedents)
end

# Grille avec obstacles (1)
grille = [
    0 0 0 0 0;
    0 1 1 1 0;
    0 1 0 1 0;
    0 1 1 1 0;
    0 0 0 0 0
]

depart = (1, 1)
arrivee = (3, 3)

chemin = dijkstra_algo(grille, depart, arrivee)
println("Chemin le plus court : ", chemin)
