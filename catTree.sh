#!/bin/bash

OUTPUT="output.txt"
> "$OUTPUT"

EXCLUDE_DIRS=(

)

EXCLUDE_FILES=(

)

ALLOWED_EXTENSIONS=(

)

declare -A SKIPPED_DIR_ALREADY_WRITTEN

is_excluded_dir() {
    for d in "${EXCLUDE_DIRS[@]}"; do
        if [[ "$1" == *"/$d/"* ]]; then
            echo "$d"
            return 0
        fi
    done
    return 1
}

is_excluded_file() {
    for f in "${EXCLUDE_FILES[@]}"; do
        if [[ "$1" == *"/$f" || "$1" == "$f" ]]; then
            return 0
        fi
        if [[ "$f" == *"*"* ]]; then
            if [[ "$(basename "$1")" == $f ]]; then
                return 0
            fi
        fi
    done
    return 1
}

has_allowed_extension() {
    for ext in "${ALLOWED_EXTENSIONS[@]}"; do
        if [[ "$1" == *"$ext" ]]; then
            return 0
        fi
    done
    return 1
}

process_file() {
    local file="$1"

    local matched_dir
    matched_dir=$(is_excluded_dir "$file")
    if [[ $? -eq 0 ]]; then
        local dirpath="./$matched_dir"
        if [[ -z "${SKIPPED_DIR_ALREADY_WRITTEN[$dirpath]}" ]]; then
            echo "[SKIP_DIR] $dirpath" >> "$OUTPUT"
            SKIPPED_DIR_ALREADY_WRITTEN[$dirpath]=1
        fi
        return
    fi

    if is_excluded_file "$file"; then
        echo "[SKIP_FILE] $file" >> "$OUTPUT"
        return
    fi

    if has_allowed_extension "$file"; then
        echo "===== $file =====" >> "$OUTPUT"
        cat "$file" >> "$OUTPUT"
        echo -e "\n\n" >> "$OUTPUT"
    else
        echo "[NO_CAT] $file" >> "$OUTPUT"
    fi
}

while IFS= read -r file; do
    process_file "$file"
done < <(find . -type f | sort)

echo "Done -> saved in $OUTPUT"

