'''utilities for the code'''
# libraries
from math import dist, inf
import copy

def euclidiean_distance(point_1, point_2):
    if point_1 == point_2:
        return inf
    else:
        return dist(point_1, point_2)
    
def get_distances(points):
    points_duplicate = copy.deepcopy(points)
    distances = {}
    for point in points:
        point_coordinates = point['kMeansNorm']
        point_id = point['_id']
        # point_distance = {point_id : []}
        point_distances = []

        for point_2 in points_duplicate:
            point_distances.append(euclidiean_distance(point_coordinates, point_2['kMeansNorm']))
        distances[point_id] = point_distances
    return distances

def get_nearest_clusters(distances_dict):
    clusters = []
    for doc in distances_dict.keys():
        smallest_distance = min(distances_dict[doc])
        nearest_cluster = distances_dict[doc].index(smallest_distance)
        clusters.append(nearest_cluster)
    return clusters