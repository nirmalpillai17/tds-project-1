import json
import csv
import pathlib

import sys

if len(sys.argv) < 2:
    print("Usage: python3 json_to_csv.py <file_name.json>")
    exit(1)

base_path = pathlib.Path().absolute()

input_file_path = base_path / sys.argv[1]
output_file_path = base_path / "users.csv"

file = open(output_file_path, "w")
data = json.load(file)
file.close()

for item in data:
    pass

