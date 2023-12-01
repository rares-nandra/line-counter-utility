#!/bin/bash

directories=()
files=()
total_lines=0
total_files=0
not_found_directories=()
not_found_files=()

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d)
            shift
            while [[ $# -gt 0 && ! $1 == -* ]]; do
                if [ -d "$1" ]; then
                    directories+=("$1")
                else
                    not_found_directories+=("$1")
                fi
                shift
            done
            ;;
        -f)
            shift
            while [[ $# -gt 0 && ! $1 == -* ]]; do
                if [ -f "$1" ]; then
                    files+=("$1")
                else
                    not_found_files+=("$1")
                fi
                shift
            done
            ;;
        *)
            shift
            ;;
    esac
done

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        file_lines=$(wc -l < "$file")
        file_name=$(basename "$file")

        last_line=$(tail -n 1 "$file")
        if [ -n "$last_line" ]; then
            ((file_lines++))
        fi

        echo "File: $file_name - Lines: $file_lines"
        ((total_lines += file_lines))
        ((total_files++))
    fi
done

for directory in "${directories[@]}"; do
    echo -e "\n\nCounting in: $directory\n\n"
    directory_lines=0
    directory_files=0

    if [ -d "$directory" ]; then
        while IFS= read -r -d '' file; do
            if [[ -f "$file" ]]; then
                file_lines=$(wc -l < "$file")
                file_name=$(basename "$file")

                last_line=$(tail -n 1 "$file")
                if [ -n "$last_line" ]; then
                    ((file_lines++))
                fi

                echo "File: $file_name - Lines: $file_lines"
                ((directory_lines += file_lines))
                ((total_lines += file_lines))
                ((directory_files++))
                ((total_files++))
            fi
        done < <(find "$directory" -type f -print0)

        echo -e "\nTotal lines in $directory: $directory_lines"
        echo "Total files in $directory: $directory_files"
    else
        not_found_directories+=("$directory")
    fi
done

echo -e "\n\nTotal files counted: $total_files"
echo -e "Total lines in all files: $total_lines\n"

if [ ${#not_found_directories[@]} -gt 0 ]; then
    echo "The following directories were not found:"
    printf '%s\n' "${not_found_directories[@]}"
fi

if [ ${#not_found_files[@]} -gt 0 ]; then
    echo "The following files were not found:"
    printf '%s\n' "${not_found_files[@]}"
fi