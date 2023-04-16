'''utilities for the code'''
from math import dist, inf
from config import *

def euclidiean_distance(point_1, point_2):
    # if point_1 == point_2:
    #     return inf
    # else:
    #     return dist(point_1, point_2)
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
    # print("Distance Array:")
    # print("\t", distances_array)
    cluster_assignments = []
    sum = 0
    for document in distances_array.keys():
        doc_distances = distances_array[document]
        nearest_cluster, squared_distance = get_min_across_dicts(doc_distances)
        sum += squared_distance
        cluster_assignments.append((document, nearest_cluster, squared_distance))
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

def get_new_centeroid(list_cluster_members):
    sum_x = 0
    sum_y = 0
    new_x = 0
    new_y = 0
    count = 0
    # print("Computing new Centeroid:")
    for point in list_cluster_members:
        sum_x += point['kMeansNorm'][0]
        sum_y += point['kMeansNorm'][1]
        count += 1
        # print("\t",sum_x,",\t", sum_y)
    if (count != 0) :
        new_x = sum_x/count
        new_y = sum_y/count
    return new_x, new_y        

def initialize_centeroids(genre, num_of_centeroids, db) :
    '''Task 2 code converted into a method'''
    # k random documents associated with genre g
    pipeline = [{'$match': {'genres': {'$elemMatch': {'$eq': genre}}}}, {'$sample': {'size': num_of_centeroids}}, {'$project': {'kMeansNorm': 1}}]

    k_means_collection = db.get_collection(scored_collection)
    centeroids = db.get_collection(task_2_collection)
    results = k_means_collection.aggregate(pipeline=pipeline)
    modified_results = []
    i = 1
    for movie in results:
        movie['_id'] = i
        modified_results.append(movie)
        i += 1

    # delete previous centeroids
    centeroids.drop()
    # populate new centeroids
    centeroids.insert_many(modified_results)
    print("Centoroids initialized:")
    i = 1
    for result in modified_results:
        print("\t",result)

def get_number_clusters(collection, genre):
    pipeline = [{'$match': {'genres': {'$elemMatch': {'$eq': genre}}}}, {'$count': '#clusters'}]
    return list(collection.aggregate(pipeline))[0]['#clusters']

def get_clusters(db, genre):
    '''Returns clusters of the passed genre '''
    pipeline = [{'$match': {'genres': {'$elemMatch': {'$eq': genre}}}}]
    collection = db.get_collection(scored_collection)
    return list(collection.aggregate(pipeline))

def assign_clusters(db, genre):
    '''Assigns movies to their nearest clusters'''
    src_collection = db.get_collection(scored_collection)
    centeroids_collection = db.get_collection(task_2_collection)
    # get movies of that genre
    points = list(src_collection.find({'genres': {'$elemMatch': {'$eq': genre}}}, {'kMeansNorm': 1}))
    centeroids = list(centeroids_collection.find({}))
    # assign nearest clusters
    distances = get_distances(points, centeroids)
    cluster_assignments = get_nearest_clusters(distances)
    # print("Clusters:\t",cluster_assignments,"\n\n\n")
    for i in range(len(distances)):
        data_point_id = cluster_assignments[i][0]
        query = {"_id": data_point_id}
        new_value = {"$set": {"cluster": cluster_assignments[i][1], "squared_distance": cluster_assignments[i][2]}}
        src_collection.update_one(query, new_value)

def update_centeroids(db, genre):
    '''Updates centeroids by accomodating new datapoints'''
    src_collection = db.get_collection(scored_collection)
    centeroids_collection = db.get_collection(task_2_collection)
    old_centeroids = list(centeroids_collection.find())
    # print(centeroids)
    k = list(centeroids_collection.aggregate(pipeline=[{'$count': 'k'}]))[0]['k']
    new_centeroids = {}
    for i in range(1, k+1):
        filter = {'genres': {'$elemMatch': {'$eq': genre}},'cluster': i}
        project={'kMeansNorm': 1}
        new_centeroids[i] = get_new_centeroid(list(src_collection.find(filter=filter, projection=project)))
    # print(new_centeroids)
    for i in range(1, k+1):
        data_point_id = i
        query = {"_id": data_point_id}
        new_value = {"$set": {"cluster": new_centeroids[i]}}
        centeroids_collection.update_one(query, new_value)
    new_centeroids = list(centeroids_collection.find())
    print('Centeroids updated as:')
    for i in range(len(old_centeroids)):
        number = i+1
        old_centeroid = old_centeroids[i]['kMeansNorm']
        new_centeroid = new_centeroids[i]['kMeansNorm']
        print(f"{number}\t{old_centeroid}   ->  {new_centeroid}")

def get_cluster_members(db, cluster_number, genre):
    '''Returns a list of all the members of that cluster'''
    filter = {'genres': {'$elemMatch': {'$eq': genre}},'cluster': cluster_number}
    project={'kMeansNorm': 1, 'cluster' : 1}
    k_means_collection = db.get_collection(scored_collection)
    return list(k_means_collection.find(filter=filter, projection=project))

def get_centeroids(db):
    centeroids_collection = db.get_collection(task_2_collection)
    return list(centeroids_collection.find({}))

def get_SSE(genre, db):
    '''Sums over squared distance in the mongo collection'''
    src_collection = db.get_collection(scored_collection)
    return list(src_collection.aggregate([{'$match': {'genres': {'$elemMatch': {'$eq': genre}}}}, { '$group': {'_id': 1,'SSE': {'$sum': '$squared_distance'}}}]))[0]['SSE']


def run_k_means(genre, num_of_clusters, db, max_iterations=5):
    '''Runs k_means until max_iteractions or convergence'''
    k_means_collection = db.get_collection(scored_collection)
    centeroids_collection = db.get_collection(task_2_collection)
    initialize_centeroids(
        genre=genre, num_of_centeroids=num_of_clusters, db=db)
    SSEs = []
    for iter in range(max_iterations):
        data_points = list(k_means_collection.find({'genres': {'$elemMatch': {
                       '$eq': genre}}}, {'kMeansNorm': 1, 'genres': 1, 'cluster': 1}))
        print("iteration: ",iter + 1)
        for data_point in data_points:
            print("\tDatapoint: ", data_point)
            centeroids = get_centeroids(db=db)
            distances = get_distances([data_point], centeroids)
            for distance in distances.values():
                for dist in distance:
                    print("\t\tDistance_to_centeroid: ", dist)
            cluster_assignments = get_nearest_clusters(distances)
            assigned_cluster = cluster_assignments[0][1]
            print("\tNearest Cluster: ", assigned_cluster)
            k_means_collection.update_one({"_id": data_point['_id']}, {"$set": {"cluster": assigned_cluster, "squared_distance" : cluster_assignments[0][-1]}})
            current_centeroid = list(centeroids_collection.find({'_id' : cluster_assignments[0][1]}))[0]['kMeansNorm']
            new_centeroid = get_new_centeroid([{'kMeansNorm' : current_centeroid}, data_point])
            centeroids_collection.update_one({"_id": assigned_cluster}, {"$set": {"kMeansNorm": new_centeroid}})
            print()
        SSE = get_SSE(genre, db)
        print("\tSSE:", SSE)
        SSEs.append(SSE)
        if (len(SSEs)>=3) :
            if (SSEs[-1] == SSEs[-2]) & (SSEs[-2] == SSEs[-3]):
                print("******* POINT OF CONVERGENCE ACHIEVED *******")
                print(f"******* k-Means PAUED AFTER {iter} iterations *******")
                break
        print("\n\n")
    return SSEs[-1]
