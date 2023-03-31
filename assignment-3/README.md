# Task 1
### Challenges
*   Characters were nested so I used a python script `characters.py` along with bash command `awk '!NF || !seen[$0]++' unnested_characters.tsv > unnested_characters_UNIQUE.tsv` to remove unnest characters and regenerated actor_title_characters & characters tables
*   Created  views to filter movies (`long_movies`) and actors (`single_character_actor_movies`, `actor_character_info_task_1`, `ACIT_MG`) that are consistent with the instructions. 
*   Created View  to make SQL queries easier to read and manage. 



