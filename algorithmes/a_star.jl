include("../config.jl")
include("../defs.jl")

# Importation d'un module pour utiliser un tas binaire
using DataStructures

# Enregistrement l'algorithme A star
struct PathData
	total_distance::Float64
	position::Tuple{Int64, Int64}
end

# Fonction pour calculer la "distance manhattan"
manhattan_distance(current, next) = abs(current[1] - next[1]) + abs(current[2] - next[2])

# Algorithme A star avec poids
function a_star_algo(map::Matrix{Char}, start::Tuple{Int64, Int64}, finish::Tuple{Int64, Int64}, w::Float64)
	# Tuple de la hauteur et largeur de la carte
    map_size = size(map)
	seen_count = 0

	# Création d'un dictionnaire (position => distance au point de départ, position) pour stocker le
	true_path_data = Dict(start => PathData(0, (-1, -1)))

	# Création d'un tas binaire de (distance au point de départ, position) ordonné par distance au point de départ
	heap::MutableBinaryHeap{Tuple{Float64, Tuple{Int64, Int64}}} = MutableBinaryHeap{Tuple{Float64, Tuple{Int64, Int64}}}(Base.By(first))
	res = push!(heap, (0, start))

	# Création d'un dictionnaire de (position => position, longueur du chemin, indice du tas binaire) pour stocker les cases visitées et recréer le chemin final
	nodes_dict = Dict(start => NodeData((-1, -1), 0, res))

	# Tant qu'il reste des cases dans le tas, on cherche
	while !isempty(heap)
		# Récupération de la distance totale et de la case courantes
		total_distance, node = pop!(heap)

		# On regarde si on a atteint la case finale
		if node == finish
			break
		end

		# On itère sur les cases voisines pour progresser
		for next in [node .+ (1, 0), node .+ (-1, 0), node .+ (0, 1), node .+ (0, -1)]
			# On vérifie que la case voisine est atteignable
			if is_reachable(map_size, next, map[next[1], next[2]])
				# Récupération du "coût de mouvement" pour se déplacer à la case voisine
				movement_cost = get(MOVEMENT_COST, map[next[1], next[2]], DEFAULT_MOVEMENT_COST)

				# On calcule la nouvelle distance totale entre le point de départ et la case voisine
				new_distance = true_path_data[node].total_distance + movement_cost

				# Si on a pas encore visité la case voisine, on la "recense", ou on met à jour la distance associée si besoin
				if !haskey(true_path_data, next) || new_distance < true_path_data[next].total_distance
					true_path_data[next] = PathData(new_distance, node)

					if !haskey(nodes_dict, next)
						res = push!(heap, (new_distance + w * manhattan_distance(next, finish), next))
						nodes_dict[next] = NodeData(node, total_distance + movement_cost, res)
						seen_count += 1
					else
						update!(heap, nodes_dict[next].heap_index, (new_distance + w * manhattan_distance(next, finish), next))
					end
				end
			end
		end
	end

	# On retourne une liste contenant la taille du chemin, le nombre de cases visitées, et le chemin, s'il existe
	if !(finish in keys(nodes_dict))
		return [0, seen_count, []]
	end

	return [trunc(Int64, true_path_data[finish].total_distance), seen_count, get_rebuilt_path(nodes_dict, finish)]
end

starting_time = time()
res = a_star_algo(get_map_matrix(MAP_PATH), START, FINISH, WEIGHT)
elapsed_time = round(time() - starting_time, digits=4)

print_solution(res, elapsed_time)
