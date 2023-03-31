# libraries
import psycopg2

# connection
conn = None
try:
    conn = psycopg2.connect(
        host="localhost",
        database="imdb",
        user="postgres",
        password="postgres")

    # curser
    cur = conn.cursor()


    # pre-transaction 
    cur.execute("SELECT COUNT(*) FROM tconsts;")
    prior = cur.fetchall()

    # transaction
    cur.execute("BEGIN; INSERT INTO TCONSTS(TCONST) VALUES (99999999), VALUES (1), VALUES(8888888); COMMIT;")
    
    # post-transaction count
    cur.execute("SELECT COUNT(*) FROM tconsts;")
    post = cur.fetchall()
    
    if (prior == post):
        print("No changes")
    else :
        print("CHANGED! PROBLEM!!")

    # close connection
    cur.close()
except psycopg2.DatabaseError as error:
    print(error)
finally:
    if conn is not None:
        conn.close()