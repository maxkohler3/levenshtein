from levenshtein import levenshtein_distance_weighted

class levenshtein_bridge:
    def __init__(self):
        pass

    def get_levenshtein_distance(self, incoming_text, master_text):
        return levenshtein_distance_weighted(incoming_text,master_text)
