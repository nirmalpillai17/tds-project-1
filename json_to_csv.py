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

in_file = open(input_file_path, "r")
out_file = open(output_file_path, "w")

data = json.load(in_file)

in_file.close()

csv_writer = csv.writer(out_file)

clean = lambda s: str(s).replace('\n', ' ').replace('\r', ' ') if s else ''

csv_writer.writerow([
        "login", "name", "company",
        "location", "email", "hireable",
        "bio", "public_repos", "followers",
        "following", "created_at"])

for item in data:
    csv_writer.writerow([
        clean(item["login"]),
        clean(item["name"]),
        clean(item["company"]).lstrip('@').upper(),
        clean(item["location"]),
        clean(item["email"]),
        clean(item["hireable"]),
        clean(item["bio"]),
        item["public_repos"],
        item["followers"],
        item["following"],
        item["created_at"],
    ])

out_file.close()
