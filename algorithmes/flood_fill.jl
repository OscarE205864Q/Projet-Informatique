include("../config.jl")
include("../defs.jl")

# Fonction pour reconstruire le chemin en partant de la fin
function get_rebuilt_path(map, distances, start, finish)
    map_size = size(map)
    path::Vector{Tuple{Int64, Int64}} = []

    if distances[finish[1], finish[2]] != -1
        node = finish

        while node != start
            pushfirst!(path, node)

            # On itère sur les cases voisines
            for next in [node .+ (1, 0), node .+ (-1, 0), node .+ (0, 1), node .+ (0, -1)]
                # On regarde si la case suivante est la précédente de la case actuelle, auquel cas on passe aux itérations suivantes
                if is_reachable(map_size, next, map[next[1], next[2]]) && distances[next[1], next[2]] == distances[node[1], node[2]] - 1
                    node = next
                    break
                end
            end
        end

        # On ajoute la case initiale au chemin
        pushfirst!(path, start)
    end

    return path
end

# Algorithme flood fill
function flood_fill_algo(map, start, finish)
    # Tuple de la hauteur et largeur de la carte
    map_size = size(map)
    seen_count = 0

    # Création d'une map pour enregistrer les distances
    distances = fill(-1, map_size)
    distances[start[1], start[2]] = 0

    # File d'attente pour le flood fill
    file = [(start, 0)]

	# Tant qu'il y a des cases dans la file, on cherche
    while !isempty(file)
        node, distance = popfirst!(file)

        # Si on a atteint l'arrivée, on arrête la boucle
        if node == finish
            break
        end

        # On itère sur les cases voisines pour progresser
		for next in [node .+ (1, 0), node .+ (-1, 0), node .+ (0, 1), node .+ (0, -1)]
            # On vérifie si le voisin est valide
            if is_reachable(map_size, next, map[next[1], next[2]]) && distances[next[1], next[2]] == -1
                # On met à jour la distance du voisin
                distances[next[1], next[2]] = distance + 1

                # On ajoute le voisin à la file d'attente
                push!(file, (next, distance + 1))

                seen_count += 1
            end
        end
    end

    path = get_rebuilt_path(map, distances, start, finish)

    return [length(path), seen_count, path]
end

starting_time = time()
res = flood_fill_algo(get_map_matrix(MAP_PATH), START, FINISH)
elapsed_time = round(time() - starting_time, digits=4)

print_solution(res, elapsed_time)
