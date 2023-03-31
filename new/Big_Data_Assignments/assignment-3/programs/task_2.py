# LIBRARIES
import psycopg2
import itertools
from utils import find_fds

# CONSTANTS
TABLE = 'task_1'

# MAIN PROGRAM
# connection
conn = psycopg2.connect("dbname=csci_620_ass_2")
print("Database connected successfully")
cur = conn.cursor()
conn.commit()
# Get attributes
cur.execute(f"Select * FROM {TABLE} LIMIT 0")
attributes = [desc[0] for desc in cur.description]

### All possible combinations
for RHS_n_LHS_quantity in range(2, len(attributes) + 1):
    for subset in itertools.combinations(attributes, RHS_n_LHS_quantity):
        RHS_LHS = list(subset)
        RHS = RHS_LHS[0]
        LHS = RHS_LHS[1:]
        find_fds(LHS=LHS, RHS=RHS, cur=cur, conn=conn)

