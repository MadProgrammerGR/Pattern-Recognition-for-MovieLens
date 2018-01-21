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
    uocc  = pd.read_csv("ml-100k/u.occupation", names=["occ"])
    uitem = pd.read_csv("ml-100k/u.item", "|",  names=uitem_names, encoding="latin-1")
    #Fix python3 unicode error https://stackoverflow.com/a/31492722      ^^^

    fivefold=[]
    for i in range(1,6):
        b = pd.read_csv("ml-100k/u"+str(i)+".base", "\t",  names=udata_names)
        t = pd.read_csv("ml-100k/u"+str(i)+".test", "\t",  names=udata_names)
        fivefold.append({"base":b, "test":t})

    occ  = pd.read_csv("ml-100k/u.occupation", names=["occupations"], squeeze=True)
    occ = dict(map(reversed, occ.to_dict().items()))
    uuser['gender'] = uuser['gender'].apply(lambda x: 0 if x == 'M' else 1)
    uuser['occupation_index'] = uuser['occupation'].apply(lambda x: occ[x])

    return {"uuser":uuser, "uitem":uitem, "uocc":uocc, "udata":udata, "ff":fivefold}

def user_preferences(udata, uitem):
    #rating_values = {1:-2, 2:-1, 3:1, 4:2, 5:3}
    rating_values = {1:1, 2:2, 3:3, 4:4, 5:5}
    rates = udata.merge(uitem, left_on="item_id", right_on="movie_id") \
            .drop(columns=["item_id", "movie_id", "timestamp", "movie_title",
                  "release_date", "video_release_date", "IMDb_URL", "unknown"])
    rates["rating_v"] = rates["rating"].replace(rating_values) #https://stackoverflow.com/a/20250996
    rates[rates.columns[2:]] = rates[rates.columns[2:]].mul(rates["rating_v"], axis=0)
    rates.drop(columns=["rating", "rating_v"], inplace=True)
    return rates.replace(0, np.nan).groupby(["user_id"]).mean()

def ff_data_preprocessing(ff, uitem, uuser, uocc):
    rating_values = {1:0, 2:0, 3:0, 4:1, 5:1}
    uocc = uocc.join(pd.get_dummies(uocc))
    uuser = uuser.merge(uocc, left_on="occupation", right_on="occ") \
            .drop(columns=["occupation", "zip_code", "occupation_index", "occ"])
    uitem = uitem.drop(columns=["movie_title", "release_date", "video_release_date", "IMDb_URL", "unknown"])
    for i in range(len(ff)):
        ff[i]["base"] = ff[i]["base"].merge(uuser, left_on="user_id", right_on="user_id") \
                        .merge(uitem, left_on="item_id", right_on="movie_id") \
                        .drop(columns=["item_id", "timestamp", "movie_id"])
        ff[i]["base"]["rating"] = ff[i]["base"]["rating"].replace(rating_values)
        ff[i]["test"] = ff[i]["test"].merge(uuser, left_on="user_id", right_on="user_id") \
                        .merge(uitem, left_on="item_id", right_on="movie_id") \
                        .drop(columns=["item_id", "timestamp", "movie_id"])
        ff[i]["test"]["rating"] = ff[i]["test"]["rating"].replace(rating_values)
    return ff

def create_csv(rd=None, filename="rating_scores_data.csv"):
    if rd is None:
        rd = read_data()
    bsd = user_preferences(rd["udata"], rd["uitem"])
    bsd.to_csv(filename, sep=',')
    return bsd


def create_ff_csv(rd=None, filename_prefix="5folds/ff_"):
    if rd is None:
        rd = read_data()
    ff_data = ff_data_preprocessing(rd["ff"], rd["uitem"], rd["uuser"], rd["uocc"])
    for i in range(len(ff_data)):
        ff_data[i]["base"].to_csv(filename_prefix + str(i) + ".base.csv", sep=",")
        ff_data[i]["test"].to_csv(filename_prefix + str(i) + ".test.csv", sep=",")
    return ff_data

if __name__ == "__main__":
    rd = read_data()
    create_csv(rd)
    create_ff_csv(rd)
