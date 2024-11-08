
############################# Shell Script -- CSV to SQL ###################################

----------------------------------------------------------------------------------------------

-- How to
./csv_to_sql.sh <input_file.csv> <output_file.sql> <schema_name> <table_name> <excluded_columns>

-- example
./csv_to_sql.sh test1.csv test2.sql bckdba ref_com_reason_test is_default,reason_internal_code

----------------------------------------------------------------------------------------------

#!/bin/bash

# Check for the right number of arguments
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <input_file.csv> <output_file.sql> <schema_name> <table_name> [excluded_columns]"
    exit 1
fi

input_file="$1"
output_file="$2"
schema_name="$3"
table_name="$4"
excluded_columns=()

# If the fifth argument (excluded columns) is provided, split by comma
if [ "$#" -ge 5 ]; then
    excluded_columns=(${5//,/ })
fi

# Create a dynamic exclude list for awk
exclude_str=""
for col in "${excluded_columns[@]}"; do
    exclude_str+=",\"$col\""
done

# Read the header line to get column names
header=$(head -n 1 "$input_file")
IFS=',' read -r -a columns <<< "$header"

# Start building the SQL insert statements
echo "INSERT INTO ${schema_name}.${table_name} (" > "$output_file"

# If there are excluded columns, filter them out, otherwise include all columns
if [ ${#excluded_columns[@]} -gt 0 ]; then
    printf '%s\n' "${columns[@]}" | grep -v -E "$(printf '%s|' "${excluded_columns[@]}" | sed 's/|$//')" | tr '\n' ',' | sed 's/,$//g' >> "$output_file"
else
    printf '%s,' "${columns[@]}" | sed 's/,$//' >> "$output_file"
fi

echo ") VALUES" >> "$output_file"

# Process each data line
tail -n +2 "$input_file" | while IFS=',' read -r -a values; do
    echo -n " (" >> "$output_file"
    for i in "${!values[@]}"; do
        if [[ ! " ${excluded_columns[@]} " =~ " ${columns[i]} " ]]; then
            value="${values[i]}"

            # Handle single quotes by escaping them
            value="${value//\'/\'\' }"

            # Add quotes around the values and handle NULLs
            if [ -z "$value" ]; then
                echo -n "NULL," >> "$output_file"
            else
                echo -n "'$value'," >> "$output_file"
            fi
        fi
    done
    # Remove the trailing comma in each record and close with a parenthesis
    sed -i '$ s/,$//' "$output_file"
    echo "), " >> "$output_file"
done

# Remove the last comma and replace with a semicolon at the end of the last line
sed -i '$ s/), $/);/' "$output_file"

echo "SQL insert statements saved to $output_file"


----------------------------------------------------------------------------------------------