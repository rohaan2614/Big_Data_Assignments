# LIBRARIES
import psycopg2
import time
import itertools
from utils import find_fds_with_pruning

# CONSTANTS
TABLE = 'task_1'
VALID_FDS = {}

# MAIN PROGRAM
# connection
conn = psycopg2.connect("dbname=csci_620_ass_2")
print("Database connected successfully")
cur = conn.cursor()
conn.commit()
# Get attributes
cur.execute(f"Select * FROM {TABLE} LIMIT 0")
attributes = [desc[0] for desc in cur.description]

### All possible combinations with max 2 LHS
start_time = time.time()
for RHS_n_LHS_quantity in range(2, 4):
    for subset in itertools.combinations(attributes, RHS_n_LHS_quantity):
        RHS_LHS = list(subset)
        RHS = RHS_LHS[0]
        LHS = RHS_LHS[1:]
        find_fds_with_pruning(LHS=LHS, RHS=RHS, cur=cur, conn=conn)
        
print(f'Time the operation took: {round(time.time()-start_time,2)}')