# Enregistrement pour les algorithmes de Dijkstra et A star
struct NodeData
	position::Tuple{Int64, Int64}
	total_distance::Union{Int64, Float64}
	heap_index::Int64
end

# Fonction créant la matrice associée au fichier carte
function get_map_matrix(map_path::String)
	# Lecture du fichier carte
	map_file = open(map_path, "r")

	# Ligne inutile, type du fichier
	readline(map_file)

	# Lignes des dimensions de la carte, la hauteur et la largeur
	height = parse(Int64, split(readline(map_file))[2])
	width =  parse(Int64, split(readline(map_file))[2])

	# Ligne inutile, "map"
	readline(map_file)

	# Initialisation de la matrice représentant la carte
	map_matrix = fill('.', (height, width))

	for (line, line_index) in zip(eachline(map_file), 1:height)
		for (char, column_index) in zip(line, 1:width)
			map_matrix[line_index, column_index] = char
		end
	end

	# Fermeture du fichier
	close(map_file)

	return map_matrix
end

# Fonction testant si une case de coordonnées x et y est atteignable (si on se situe à côté)
function is_reachable(dimensions::Tuple{Int64, Int64}, coordinates::Tuple{Int64, Int64}, tile_symbol::Char)
	# Unpacking des tuples
	height, width = dimensions
	x, y = coordinates

	return tile_symbol != '@' && x >= 1 && y >= 1 && x <= width && y <= height
end

# Fonction pour reconstruire le chemin
function get_rebuilt_path(nodes_dict, finish)
	# Création du chemin avec la case d'arrivée
	path::Vector{Tuple{Int64, Int64}} = [finish]
	node = nodes_dict[finish].position

	while node != (-1, -1)
		# On insère la node
		insert!(path, 1, node)
		node = nodes_dict[node].position
	end

	return path
end

# Fonction pour accorder en nombre des mots à print
plural_adjuster(counter, singular::String, plural::String) =
	return counter >= 2 ? plural : singular

# Fonction pour afficher les informations relatives à une solution
function print_solution(solution, elapsed_time=nothing)
	# Si un temps est passé on l'affiche
	if !isnothing(elapsed_time)
		println("Solution trouvée en $elapsed_time secondes")
	end

	# Si le chemin est vide, c'est que la solution est "impossible"
	if solution[3] == []
		println("Pas de chemin possible vers la position finale")
	else
		println("Longueur du chemin : $(solution[1]) case" * plural_adjuster(solution[1], "", "s"))
		println("Nombre de cases visitées : $(solution[2])")
		println("Chemin complet :\n", solution[3])
	end
end
