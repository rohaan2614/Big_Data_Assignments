from pyspark.sql import SparkSession
from pyspark.sql.types import IntegerType
import time

spark = SparkSession.builder.getOrCreate()

# dataFrames
df_people = spark.read.csv('data/nameBasics.tsv', sep=r'\t', header=True)
df_movies = spark.read.csv('data/basics.tsv', sep=r'\t', header=True)
df_principals = spark.read.csv('data/principals.tsv', sep=r'\t', header=True)

# casting
df_people = df_people.withColumn("birthYear", df_people["birthYear"].cast(IntegerType()))

# filters
df_people = df_people.where(df_people.primaryName.like('Phi%')).where(df_people.deathYear == "\\N")
df_movies = df_movies.where(df_movies.startYear != 2014).where(df_movies.titleType == 'movie')
df_actors = df_principals.where(df_principals.category == 'actor')

# joins
task_1_joins = df_actors.join(df_people, df_people.nconst == df_actors.nconst).join(df_movies, df_movies.tconst == df_actors.tconst)

# results
start = time.time()
results = task_1_joins.select(df_people.nconst, df_people.primaryName).collect()
end = time.time()

print(f'Time to Retrive: {end - start} s')
print('First 10 results:')
print("\t","nconst","\t","Actor Name")
for result in results[:10]:
    print("\t", result['nconst'], "\t", result['primaryName'])

