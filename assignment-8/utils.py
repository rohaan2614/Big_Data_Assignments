'''utilities for the code'''
from math import dist, inf

def euclidiean_distance(point_1, point_2):
    if point_1 == point_2:
        return inf
    else:
        return dist(point_1, point_2)
    
def get_distances(points, centeroids):
    distances = {}
    for point in points:
        point_coordinates = point['kMeansNorm']
        point_id = point['_id']
        point_distances = []

        for point_2 in centeroids:
            point_distances.append({point_2['_id'] : euclidiean_distance(point_coordinates, point_2['kMeansNorm'])})
        distances[point_id] = point_distances
    return distances

def get_nearest_clusters(distances_array):
    cluster_assignments = []
    for document in distances_array.keys():
        doc_distances = distances_array[document]
        nearest_cluster, smallest_distance = get_min_across_dicts(doc_distances)
        cluster_assignments.append((document, nearest_cluster))
    return cluster_assignments

def get_min_across_dicts(list_of_dicts):
    smallest_distance = inf
    smallest_distance_key = None
    for dict in list_of_dicts:
        dict_key = list(dict.keys())[0]
        dict_value = dict[dict_key]
        if (smallest_distance > dict_value) :
            smallest_distance = dict_value
            smallest_distance_key = dict_key
    return smallest_distance_key, smallest_distance


def get_new_centeroids(list_of_points):
    sum_x = 0
    sum_y = 0
    new_x = 0
    new_y = 0
    count = 0
    for point in list_of_points:
        sum_x += point['kMeansNorm'][0]
        sum_y += point['kMeansNorm'][1]
        count += 1
    if (count != 0) :
        new_x = sum_x/count
        new_y = sum_y/count
    return new_x, new_y        