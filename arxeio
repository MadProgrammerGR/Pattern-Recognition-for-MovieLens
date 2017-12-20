COPY u_data FROM 'C:\Users\sotiris dim\Desktop\Programming\Ergasies\Pattern Recognition\ml-100k\u.data' WITH (DELIMITER '	');
COPY u_user FROM 'C:\Users\sotiris dim\Desktop\Programming\Ergasies\Pattern Recognition\ml-100k\u.user' WITH (DELIMITER '|');
COPY u_item FROM 'C:\Users\sotiris dim\Desktop\Programming\Ergasies\Pattern Recognition\ml-100k\u.item' WITH (DELIMITER '|');

Copy ( 
    SELECT ud.user_id, gender, age,
        avg(nullif(rating*action,0)) as action, avg(nullif(rating*adventure,0)) as adventure,avg(nullif(rating*animation,0)) as animation,
        avg(nullif(rating*childrens,0)) as childrens, avg(nullif(rating*crime,0)) as crime, avg(nullif(rating*documentary,0)) as documentary, avg(nullif(rating*drama,0)) as drama, 
        avg(nullif(rating*fantasy,0)) as fantasy, avg(nullif(rating*filmnoir,0)) as filmnoir, avg(nullif(rating*horror,0)) as horror, avg(nullif(rating*musical,0)) as musical, 
        avg(nullif(rating*mystery,0)) as mystery, avg(nullif(rating*romance,0)) as romance, avg(nullif(rating*scifi,0)) as scifi, avg(nullif(rating*thriller,0)) as thriller,
        avg(nullif(rating*war,0)) as war, avg(nullif(rating*western,0)) as western
    FROM u_data as ud inner join u_user as uu on ud.user_id = uu.user_id
        inner join u_item as ui on ud.item_id = ui.movie_id
    GROUP BY ud.user_id, gender, age
) To 'C:\Users\sotiris dim\Desktop\test.csv' With (format CSV, DELIMITER ',', header);