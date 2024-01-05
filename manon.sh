#!/bin/bash

# Demander le chemin du répertoire Git
read -p "Entrez le chemin du répertoire Git : " repo_path
# Demander le nombre de lignes à sélectionner
read -p "Entrez le nombre de lignes à parti duquel le script fera effet : " lines_to_select

while true; do
    # Vérifier si le code a été poussé dans les dernières 24 heures
    last_commit=$(git -C "$repo_path" log -1 --format=%ct)
    current_time=$(date +%s)
    time_diff=$((current_time - last_commit))
    twenty_four_hours=$((24 * 60 * 60))

    if [ "$lines_changed" -gt "$lines_to_select" ]; then
        # Le code a été poussé dans les dernières 24 heures avec plus de lignes changées que le nombre de lignes à sélectionner
        if [ "$time_diff" -gt "$twenty_four_hours" ]; then
            echo "Suppression du code..."
            # Supprimer le code
            rm -rf "$repo_path"
        else
            echo "Vous avez $lines_changed lignes modifiées. Pensez à effectuer un git push."
        fi
    else
        # Le code n'est pas assez important pour être push
        continue
    fi

    # Attendre 1 heure avant de vérifier à nouveau
    sleep 3600
done