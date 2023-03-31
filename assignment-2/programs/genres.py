with open('clean_data/genres.tsv', 'r') as source_file:
    genres = {}
    # skip header
    next(source_file)
    for line in source_file:
        for genre in line.split(','):
            genres[genre.strip()] = None

with open('clean_data/genres.txt', 'w') as destination_file:
    destination_file.write('\n'.join(list(genres.keys())))