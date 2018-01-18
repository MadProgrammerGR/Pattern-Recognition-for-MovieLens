import pandas as pd
import numpy as np

def read_data():
    udata_names=["user_id", "item_id", "rating", "timestamp"]
    uuser_names=["user_id", "age", "gender", "occupation", "zip_code"]
    uitem_names=["movie_id", "movie_title", "release_date", "video_release_date",
                 "IMDb_URL", "unknown", "Action", "Adventure", "Animation", "Children's",
                 "Comedy", "Crime", "Documentary", "Drama", "Fantasy", "Film-Noir",
                 "Horror", "Musical", "Mystery", "Romance", "Sci-Fi", "Thriller",
                 "War", "Western"]

    udata = pd.read_csv("ml-100k/u.data", "\t", names=udata_names)
    uuser = pd.read_csv("ml-100k/u.user", "|",  names=uuser_names)
    uocc  = pd.read_csv("ml-100k/u.occupation", names=["occupations"], squeeze=True)
    uitem = pd.read_csv("ml-100k/u.item", "|",  names=uitem_names, encoding="latin-1")
    #Fix python3 unicode error https://stackoverflow.com/a/31492722      ^^^

    occ = dict(map(reversed, uocc.to_dict().items()))
    uuser['gender'] = uuser['gender'].apply(lambda x: 0 if x == 'M' else 1)
    uuser['occupation'] = uuser['occupation'].apply(lambda x: occ[x])

    return {"uuser":uuser, "uitem":uitem, "uocc":uocc, "udata":udata}

def user_preferences(udata, uitem):
    #rating_values = {1:-2, 2:-1, 3:1, 4:2, 5:3}
    rating_values = {1:1, 2:2, 3:3, 4:4, 5:5}
    rates = udata.merge(uitem, left_on="item_id", right_on="movie_id").drop(
            columns=["item_id", "movie_id", "timestamp", "movie_title",
                     "release_date", "video_release_date", "IMDb_URL", "unknown"]
           )
    rates["rating_v"] = rates["rating"].replace(rating_values) #https://stackoverflow.com/a/20250996
    rates[rates.columns[2:]] = rates[rates.columns[2:]].mul(rates["rating_v"], axis=0)
    rates.drop(columns=["rating", "rating_v"], inplace=True)
    return rates.replace(0, np.nan).groupby(["user_id"]).mean()

def create_csv(rd=None, filename="rating_scores_data.csv"):
    if rd is None:
        rd = read_data()
    bsd = user_preferences(rd["udata"], rd["uitem"])
    bsd.to_csv(filename, sep=',')
    return bsd

if __name__ == "__main__":
    create_csv()
