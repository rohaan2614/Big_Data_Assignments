from pyspark.sql import SparkSession
from pyspark.sql.functions import array_contains, split, col, count, max
import time

spark = SparkSession.builder.getOrCreate()

# dataFrames
df_people = spark.read.csv('data/nameBasics.tsv', sep=r'\t', header=True)
df_movies = spark.read.csv('data/basics.tsv', sep=r'\t', header=True)
df_principals = spark.read.csv('data/principals.tsv', sep=r'\t', header=True)

# splitting
df_movies_2 = df_movies.select(col("tconst"), split(
    col("genres"), ",").alias("genresArray")).drop("genres")

# filters
df_producers = df_principals.where(df_principals.category == 'director')
df_talk_shows = df_movies_2.select(col("tconst").alias("show_id"), array_contains(
    df_movies_2.genresArray, "Talk-Show").alias("talk_show")).where(col("talk_show") == True)
df_people = df_people.where(df_people.primaryName.contains('Gill'))

# joins
df_people = df_people.selectExpr("nconst as person_id", "primaryName as Name")
df_directors = df_people.join(df_producers, df_producers.nconst ==
                              df_people.person_id).select("person_id", "Name", "tconst")
df_shows = df_movies.join(df_talk_shows, df_talk_shows.show_id ==
                          df_movies.tconst).select(df_talk_shows.show_id, "startYear")
df_task_2_data = df_directors.join(df_shows, df_shows.show_id == df_directors.tconst).select(
    'person_id', 'Name', 'tconst', 'startYear')

# grouping
shows_per_year = df_task_2_data.groupby(
    "person_id", "Name", "startYear").agg(count("*").alias("count"))
max_shows_per_capita = shows_per_year.groupby(
    "person_id", "Name").agg(max("count").alias("max_shows"))

# results
start = time.time()
results = shows_per_year.join(max_shows_per_capita, (shows_per_year["count"] == max_shows_per_capita.max_shows) & (
    shows_per_year.person_id == max_shows_per_capita.person_id)).where(col("startYear") == 2017).collect()
end = time.time()

print(f'Time to Retrive: {end - start} s')
print('First 10 results:')
print("\t", 'nconst', "\t", 'Name', "\t\t\t", 'Year', "\t", 'count')
for result in results[:10]:
    print("\t", result['person_id'], "\t", result['Name'],
          "\t", result['startYear'], "\t", result['count'])
