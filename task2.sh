#!/bin/bash

# Подготовка данных (Проекция)
tr -s ' ' < query1 | cut -d' ' -f4,6,7 | sort -k1,1 > t1.txt
tr -s ' ' < query4 | cut -d' ' -f2,5 | sort -k1,1 > t4.txt

# Соединение таблиц (Join)
join -1 1 -2 1 t1.txt t4.txt | cut -d' ' -f2,3,5 > j.txt

# Подсчет суммы и фильтрация (без awk)
sort -k1,1 -k2,2 j.txt | sed -e ':a' -e '$!N; /^\(.*\) \(.*\)\n\1 \2/!ba' -e 's/\n/ + /' | while read -r dept city expr; do 
    total=$(echo "$expr" | bc -l)
    if (( $(echo "$total > 1000" | bc -l) )); then 
        echo "$dept $city: $total"
    fi
done
