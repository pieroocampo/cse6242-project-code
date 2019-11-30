import pandas as pd
import cpi
import datetime

if __name__ == "__main__":
    df = pd.read_csv('dc_properties_sales_with_metro_grocery_cafeterias_libraries_phousing_schools.csv')
    df['PRICE_ADJ'] = df.apply(lambda x: cpi.inflate(x.PRICE, x.SALEYEAR2), axis=1)
    df.to_csv('dc_properties_sales_with_metro_grocery_cafeterias_libraries_phousing_schools_priceadj.csv')
