# LIBRARIES
import psycopg2
import time
import itertools

# CONSTANTS
TABLE = 'task_1'
VALID_FDS = {}

# HELPER METHODS
def create_query_string(LHS=[], RHS=[], table=TABLE):
    "creates a the query that will return whether RHS has a functional dependency on LHS."
    if type(LHS) == str : 
        LHS = [LHS]
    if type(RHS) == str : 
        RHS = [RHS]
    
    LHS_string = ''
    for lhs in LHS:
        LHS_string += lhs + ', '
    LHS_string = LHS_string[:-2]

    RHS_string_1 = ''
    RHS_string_2 = ''
    RHS_string_3 = ''
    for rhs in RHS:
        RHS_string_1 += f'COUNT({rhs}), '
        RHS_string_2 += rhs + ', '
        RHS_string_3 += f'COUNT({rhs}) > 1 AND '
    
    RHS_string_1 = RHS_string_1[:-2]
    RHS_string_2 = RHS_string_2[:-2]
    RHS_string_3 = RHS_string_3[:-5]

    query_string = f'SELECT EXISTS (SELECT {LHS_string}, {RHS_string_1} FROM (SELECT DISTINCT {LHS_string}, {RHS_string_2} FROM {table}) AS SQ GROUP BY {LHS_string} HAVING {RHS_string_3});'
    return query_string


def find_fds (LHS, RHS, cur, conn, table=TABLE) :
    start_time = time.time()
    cur.execute(create_query_string(LHS=LHS, RHS=RHS, table=table))
    conn.commit()
    duration = round(time.time() - start_time,3)
    result = cur.fetchall()
    if (result[0][0]):
        print(f"Functional Dependency ABSENT in : {LHS} -> {RHS}, Duration: {duration}")
    else:
        print(f"Functional Dependency PRESENT in : {LHS} -> {RHS}, Duration: {duration}")

def find_fds_with_pruning (LHS, RHS, cur, conn, table=TABLE) :
    prune = False
    if type(RHS) == list:
        RHS = RHS[0]
    if RHS in VALID_FDS.keys():
        for lhs in LHS:
            if lhs in VALID_FDS[RHS]:
                prune = True
                print(f'{LHS} -> {RHS} PRUNNED because FD {lhs}->{RHS} exists')
    
    if (not prune): 
        start_time = time.time()
        cur.execute(create_query_string(LHS=LHS, RHS=RHS, table=table))
        conn.commit()
        duration = round(time.time() - start_time,3)
        result = cur.fetchall()
        if (result[0][0]):
            print(f"Functional Dependency ABSENT in : {LHS} -> {RHS}, Duration: {duration}")
        else:
            print(f"Functional Dependency PRESENT in : {LHS} -> {RHS}, Duration: {duration}")
            if RHS not in VALID_FDS.keys():
                VALID_FDS[RHS] = set()
            for lhs in LHS:
                    VALID_FDS[RHS].add(lhs)