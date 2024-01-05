#!/bin/bash

# Demander le chemin du répertoire Git
while true; do
    read -p "Entrez le chemin du répertoire Git : " repo_path
    if [[ -d "$repo_path" ]]; then
        break
    else
        echo "Le chemin du répertoire n'existe pas. Veuillez entrer un chemin valide."
    fi
done

# Demander le nombre de lignes à sélectionner (integer uniquement)
while true; do
    read -p "Entrez le nombre de lignes à partir duquel le script fera effet : " lines_to_select
    if [[ "$lines_to_select" =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Veuillez entrer une valeur entière."
    fi
done

# Demander le nombre de seconde à vérifier (integer uniquement)
while true; do
    read -p "Entrez le nombre de seconde où le script fera une vérification : " time_check
    if [[ "$time_check" =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Veuillez entrer une valeur entière."
    fi
done

# Demander le nombre de seconde avant de tout détruire (integer uniquement)
while true; do
    read -p "Entrez le nombre de seconde avant que le script détruise tout : " time_before_destruction
    if [[ "$time_before_destruction" =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Veuillez entrer une valeur entière."
    fi
done

reccurency=0

while true; do
    # Vérifier si le code a été poussé dans les dernières 24 heures
    last_commit=$(git -C "$repo_path" log -1 --format=%ct)
    current_time=$(date +%s)
    time_diff=$((current_time - last_commit))

    if [[ "$lines_changed" -gt $lines_to_select ]]; then
        # Le code a été poussé dans les dernières 24 heures avec plus de lignes changées que le nombre de lignes à sélectionner
        if [ "$time_diff" -gt "$time_before_destruction" ] && ["$reccurency" -gt 5]; then
            echo "Suppression du code..."
            # Supprimer le code
            rm -rf "$repo_path"
            break
        else
            echo "Vous avez $lines_changed lignes modifiées. Pensez à effectuer un git push."
            reccurency=$((reccurency + 1))
        fi
    else
        # Le code n'est pas assez important pour être push
        continue
    fi

    # Attendre 1 heure avant de vérifier à nouveau
    sleep $time_check
done
