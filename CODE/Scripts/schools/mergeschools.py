import pandas as pd

if __name__ == "__main__":
    df = pd.read_csv('Address_Points_With_Schools.csv')
    df_f = df[['FULLADDRESS', 'elementary_school','middle_school','high_school']]

    df2 = pd.read_csv('dc_properties_sales_with_metro_stations_grocery_stores_cafeterias_libraries_public_housing.csv')
    df3 = pd.merge(left=df2, right=df_f, left_on='FULLADDRESS', right_on='FULLADDRESS')

    df3.to_csv('dc_properties_sales_with_metro_grocery_cafeterias_libraries_phousing_schools.csv')