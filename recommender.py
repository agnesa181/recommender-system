import pandas as pd

data = pd.read_csv("/home/pi/RSL/userReviews.csv", sep=";")

print(data.head())
print(data[:3])
print(data.movieName.iloc[1])

column_names = ['movieName', 'Metascore_w', 'Author', 'AuthorHref', 'Date', 'Summary', 'InteractionsYesCount', 'InteractionsTotalCount', 'InteractionsThumbUp', 'InteractionsThumbDown']
subset = pd.DataFrame(columns = column_names)
subset = pd.DataFrame(columns=data.columns.tolist())
        
subset = data[data.movieName == 'scary-movie']

print(subset)

recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc','abs_inc'])

for idx, Author in subset.iterrows():
    print(Author)
    author = Author[['Author']].iloc[0]
    ranking = Author[['Metascore_w']].iloc[0]
    
    
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    print(filter1)
    print(filter2)
    
    p_recommendations = data[filter1 & filter2]
    print(p_recommendations.head())
    
    p_recommendations.loc[:,'rel_inc'] = p_recommendations.Metascore_w/ranking
    p_recommendations.loc[:,'abs_inc'] = p_recommendations.Metascore_w - ranking
    
    recommendations = recommendations.append(p_recommendations)
    
    recommendations = recommendations.sort_values(['rel_inc', 'abs_inc'], ascending=False)
    
    recommendations = recommendations.drop_duplicates(subset='movieName', keep="first")
    
    recommendations.head(50).to_csv("/home/pi/RSL/recommendationsBasedOnMetascore.csv", sep=";", index=False)
    print(recommendations.head(50))
    print(recommendations.shape)