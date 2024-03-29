include("../config.jl")
include("../defs.jl")

# Importation d'un module pour utiliser un tas binaire
using DataStructures

# Algorithme de Dijkstra
function dijkstra_algo(map::Matrix{Char}, start::Tuple{Int64, Int64}, finish::Tuple{Int64, Int64})
	# Tuple de la hauteur et largeur de la carte
    map_size = size(map)
	seen_count = 0

	# Création d'un tas binaire de (distance au point de départ, position) ordonné par distance au point de départ
	heap::MutableBinaryHeap{Tuple{Int64, Tuple{Int64, Int64}}} = MutableBinaryHeap{Tuple{Int64, Tuple{Int64, Int64}}}(Base.By(first))
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
				new_distance = nodes_dict[node].total_distance + movement_cost

				# Si on a pas encore visité la case voisine, on la "recense", sinon on met à jour sa distance associée si besoin
				if !haskey(nodes_dict, next)
					res = push!(heap, (new_distance, next))
					nodes_dict[next] = NodeData(node, total_distance + movement_cost, res)
					seen_count += 1
				elseif new_distance < nodes_dict[next].total_distance
					update!(heap, nodes_dict[next].heap_index, (new_distance, next))
				end
			end
		end
	end

	# On retourne une liste contenant la taille du chemin, le nombre de cases visitées, et le chemin, s'il existe
	if !(finish in keys(nodes_dict))
		return [0, seen_count, []]
	end

	return [nodes_dict[finish].total_distance, seen_count, get_rebuilt_path(nodes_dict, finish)]
end

starting_time = time()
res = dijkstra_algo(get_map_matrix(MAP_PATH), START, FINISH)
elapsed_time = round(time() - starting_time, digits=4)

print_solution(res, elapsed_time)
