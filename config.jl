MAP_PATH = "../theglaive.map"  # Chemin relatif au fichier dans le dossier "algorithmes"
START = (189, 193)  # Position de départ
FINISH = (226, 437)  # Position d'arrivée
DEFAULT_MOVEMENT_COST = 1  # Coût d'un déplacement normal
MOVEMENT_COST = Dict('S' => 5, 'W' => 8)  # Coût de déplacement sur les surfaces spéciales
WEIGHT = 0.5  # Coefficient du poids pour l'algorithme A star
