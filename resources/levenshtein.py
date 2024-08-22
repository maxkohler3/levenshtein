from fuzzywuzzy import fuzz

#Declare constants

MIN_LENGTH_RATIO = 8
BASE_SCALE = 0.95
PARTIAL_SCALE = 0.6

def levenshtein_distance_weighted(incoming_text: str, master_text: str) -> int:
    incoming_text = incoming_text.replace(",", " ")
    base = fuzz.ratio(incoming_text, master_text)
 
    len_ratio = float(max(len(incoming_text), len(master_text))) / min(
        len(incoming_text), len(master_text)
    )
 
    # if one string is much shorter than the other
    if len_ratio > MIN_LENGTH_RATIO:
        token_sort = (
            fuzz.token_sort_ratio(incoming_text, master_text, full_process=True)
            * BASE_SCALE
            * PARTIAL_SCALE
        )
        token_set = (
            fuzz.token_set_ratio(incoming_text, master_text, full_process=True)
            * BASE_SCALE
            * PARTIAL_SCALE
        )
    else:
        token_sort = fuzz.token_sort_ratio(incoming_text, master_text, full_process=True) * BASE_SCALE
        token_set = fuzz.token_set_ratio(incoming_text, master_text, full_process=True) * BASE_SCALE
 
    return int(round((max(base, token_sort, token_set))))
