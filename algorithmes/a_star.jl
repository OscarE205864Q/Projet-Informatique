# Structure de noeud pour l'algorithme A star
struct Node
    x::Int
    y::Int
    precedent::Union{Nothing, Node}
    g::Float64
    h::Float64
end

# Fonction de distance de Manhattan pour l'heuristique
manhattan(node::Node, goal::Node) =
    abs(node.x - goal.x) + abs(node.y - goal.y)

# Fonction retournant la node avec le g minimal dans le set
function minimum_explorable(explorable::Set{Node})
    node_minimale = first(explorable)

    for node in explorable
        if node.g + node.h < node_minimale.g + node_minimale.h
            current = node
        end
    end

    return node_minimale
end

# Fonction retournant le liste représentant les cases du chemin optimal
function chemin_optimal(node_actuelle)
    chemin = []

    while node_actuelle.precedent !== nothing
        pushfirst!(chemin, (node_actuelle.x, node_actuelle.y))
        node_actuelle = node_actuelle.precedent
    end

    pushfirst!(chemin, (node_actuelle.x, node_actuelle.y))

    return chemin
end

# Algorithme A star
function a_star_algo(grille, depart::Node, arrivee::Node)
    explorable = Set{Node}()
    termine = Set{Tuple{Int64, Int64}}()

    start_node = Node(depart.x, depart.y, nothing, 0.0, manhattan(depart, arrivee))
    push!(explorable, start_node)

    while !isempty(explorable)
        node_actuelle = minimum_explorable(explorable)

        # On teste si on est arrivé
        if (node_actuelle.x, node_actuelle.y) == (arrivee.x, arrivee.y)
            return chemin_optimal(node_actuelle)
        end

        # On ajoute la node actuelle dans le set des chemins déjà vus
        delete!(explorable, node_actuelle)
        push!(termine, (node_actuelle.x, node_actuelle.y))

        suivants = [(node_actuelle.x + 1, node_actuelle.y), (node_actuelle.x - 1, node_actuelle.y),
                     (node_actuelle.x, node_actuelle.y + 1), (node_actuelle.x, node_actuelle.y - 1)]

        for suivant in suivants
            # Si la node suivante ne représente pas une étape de chemin valide, on l'écarte
            if suivant[1] < 1 || suivant[1] > size(grille, 1) || suivant[2] < 1 || suivant[2] > size(grille, 2) || grille[suivant[1], suivant[2]] == 1
                continue
            end

            node_suivante = Node(suivant[1], suivant[2], node_actuelle, node_actuelle.g + 1.0, manhattan(node_actuelle, arrivee))

            # Si la node est pas le set des chemins écartés, on l'ignore
            if (node_suivante.x, node_suivante.y) in termine
                continue
            end

            # Si la node n'est pas dans le set des chemins explorables, on l'ajoute
            if !(node_suivante in explorable)
                push!(explorable, node_suivante)
            end
        end
    end

    # Si aucun chemin n'a été trouvé, on renvoie une liste vide
    return []
end

# Grille avec obstacles (1)
grille = [
    0 0 0 0 0;
    0 1 1 1 0;
    0 1 0 1 0;
    0 1 1 1 0;
    0 0 0 0 0
]

# Node de départ
depart = Node(1, 1, nothing, 0.0, 0.0)
# Node d'arrivée
arrivee = Node(3, 3, nothing, 0.0, 0.0)
# Chemin le plus court obtenu par l'agorithme A star
chemin = a_star_algo(grille, depart, arrivee)

println("Chemin le plus court : ", chemin)
