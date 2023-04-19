from pyspark.sql import SparkSession
from pyspark.sql.functions import array_contains
from pyspark.sql.functions import split, col
import time

spark = SparkSession.builder.getOrCreate()

# dataFrames
df_people = spark.read.csv('data/nameBasics.tsv', sep=r'\t', header=True)
df_movies = spark.read.csv('data/basics.tsv', sep=r'\t', header=True)
df_principals = spark.read.csv('data/principals.tsv', sep=r'\t', header=True)

# splitting
df_movies_2 = df_movies.select(col("tconst"), split(col("genres"), ",").alias("genresArray")).drop("genres")

# filters
df_producers = df_principals.where(df_principals.category == 'director')
df_talk_shows = df_movies_2.select("tconst", array_contains(df_movies_2.genresArray, "Talk-Show").alias("talk_show")).where(col("talk_show") == True)
df_people.where(df_people.primaryName.contains('Gill')).show()

# joins
# task_1_joins = df_actors.join(df_people, df_people.nconst == df_actors.nconst).join(df_movies, df_movies.tconst == df_actors.tconst)

# # results
# start = time.time()
# results = task_1_joins.select(df_people.nconst, df_people.primaryName).collect()
# end = time.time()

# print(f'Time to Retrive: {end - start} s')
# print('First 10 results:')
# print("\t","nconst","\t","Actor Name")
# for result in results[:10]:
#     print("\t", result['nconst'], "\t", result['primaryName'])

