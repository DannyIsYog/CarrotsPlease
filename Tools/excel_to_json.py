import json


def is_reindeer(name):
    santa_reindeers = ["Dasher", "Dancer", "Prancer", "Vixen",
                       "Comet", "Cupid", "Donner", "Blitzen", "Rudolph"]
    return name in santa_reindeers


def process_input(input_file, output_file):
    # Read input file and split lines
    with open(input_file, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    # Get header to extract categories
    header = lines[0].strip().split('\t')[1:]

    # Initialize data structure to store results
    result = {"members": {}, "reindeers": {}}

    # Process each line
    for line in lines[1:]:
        # Split the line by tabs
        data = line.strip().split('\t')

        # Extract name and preferences
        name = data[0]
        # remove any extra spaces in the end of the name
        name = name.strip()
        preferences = data[1:]

        # Create member dictionary
        member_data = {"food": {}, "movies": {}, "games": {}, "music": {}}

        for category, preference in zip(header, preferences):
            category_type, category_name = category.lower().split(' [')
            category_name = category_name[:-1]

            member_data[category_type][category_name.lower()
                                       ] = preference.lower()

        # Check if the name is a reindeer
        if is_reindeer(name):
            result["reindeers"][name] = member_data
        else:
            result["members"][name] = member_data

    # Write result to output JSON file
    with open(output_file, 'w', encoding='utf-8') as outfile:
        json.dump(result, outfile, indent=3, ensure_ascii=False)


# Example usage
input_filename = 'input.txt'
output_filename = 'output.json'
process_input(input_filename, output_filename)
