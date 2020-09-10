import time, datetime
import requests
import csv, json 
from io import StringIO
import pandas as pd
import pathlib
import tempfile

def make_temp_path():
  with tempfile.NamedTemporaryFile() as temp:
    return pathlib.Path(temp.name)

path = make_temp_path()

def get_temp_path():
  return path

def watch_for_updates():
    """
    Waits until 8pm every day and updates the 
    data in the server.
    """
    while True:
        update()
        time.sleep(60 * 60)

def update():
    """
    Updates the data in the server.
    """
    # get data from the server
    # repo
    # https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series
    
    US_confirmed = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
    global_confirmed = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
    US_deaths = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
    global_deaths = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
    global_recovered = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"   
   
    US_confirmed_df = pd.read_csv(StringIO(requests.get(url = US_confirmed).content.decode('utf-8')))
    US_deaths_df = pd.read_csv(StringIO(requests.get(url = US_deaths).content.decode('utf-8')))
    global_confirmed_df = pd.read_csv(StringIO(requests.get(url = global_confirmed).content.decode('utf-8')))
    global_deaths_df = pd.read_csv(StringIO(requests.get(url = global_deaths).content.decode('utf-8')))
    global_recovered_df = pd.read_csv(StringIO(requests.get(url = global_recovered).content.decode('utf-8')))

    # change data into the correct json form
    
    US_df = pd.merge(filter_df(US_deaths_df, deaths=True), \
            filter_df(US_confirmed_df), \
            on=[ 'latitude', 'longitude' ], \
            how='left', suffixes=('', '_y'))
    US_df.drop(list(US_df.filter(regex='_y$')), axis=1, inplace=True)
    US_df['uid']  = US_df['uid'].astype('Int64')
    US_df['fips'] = US_df['fips'].astype('Int64')

    US_df.drop(US_df[US_df.county == "Kings"].index, inplace=True)
    US_df.drop(US_df[US_df.county == "Queens"].index, inplace=True)
    US_df.drop(US_df[US_df.county == "Bronx"].index, inplace=True)
    US_df.drop(US_df[US_df.county == "Richmond"].index, inplace=True)
    US_df.drop(US_df[US_df.county == "Unassigned"].index, inplace=True)
    US_df.drop(US_df[US_df.county.str.contains("Out of", na=False)].index, inplace=True)

    global_df_wout_recovered = pd.merge(filter_df(global_deaths_df, deaths=True, recovered=False, worldwide=True), \
            filter_df(global_confirmed_df, deaths=False, recovered=False, worldwide=True), \
            on=[ 'latitude', 'longitude' ], \
            how='left', suffixes=('', '_y'))
    global_df_wout_recovered.drop(list(global_df_wout_recovered.filter(regex='_y$')), axis=1, inplace=True)

    global_df_recovered = filter_df(global_recovered_df, deaths = False, recovered=True, worldwide=True)
    global_df_recovered['confirmed_recovered'] = global_df_recovered['confirmed_recovered'].astype('Int64')
    global_df_recovered['daily_change_recovered'] = global_df_recovered['daily_change_recovered'].astype('Int64')
    global_df_recovered['weekly_change_recovered'] = global_df_recovered['weekly_change_recovered'].astype('Int64')

    global_df = pd.merge(global_df_wout_recovered, global_df_recovered,\
         on=[ 'latitude', 'longitude' ], how='left', suffixes=('', '_y'))
    global_df.drop(list(global_df.filter(regex='_y$')), axis=1, inplace=True)

    covid_data = pd.merge(US_df, global_df, how='outer')

    covid_data.to_json(str(path), orient='records')

    # save the data to the file

def filter_df(df, deaths=False, recovered=False, worldwide=False):

    if worldwide == True: 
        ### For Global confirmed cases and confirmed deaths dataframes 
        return filter_df_worldwide(df, deaths, recovered)

    else:
        ### For US confirmed cases and confirmed death dataframes 
        return filter_df_US(df, deaths)

def filter_df_worldwide(df, deaths, recovered):
    filters = ['Province/State','Country/Region','Lat','Long']

    if deaths == True:
        filters.append('Population')
        df['Population'] = df['Country/Region'].map(lambda country: int(global_populations[country]*1000) , na_action='ignore') 
        filtered_df = date_manipulation(df, True, False, filters)
        rename = {  "Province/State" : "state",
                    "Country/Region": "country",
                    "Lat": "latitude",
                    "Long":  "longitude",
                    "daily_change": "daily_change_deaths",
                    "weekly_change": "weekly_change_deaths",
                    "Population": "population"
                }
    elif recovered == True: 
        filtered_df = date_manipulation(df, False, True, filters)
        rename = {  "Province/State" : "state",
                    "Country/Region": "country",
                    "Lat": "latitude",
                    "Long":  "longitude",
                    "daily_change": "daily_change_recovered",
                    "weekly_change": "weekly_change_recovered"
                }
    else: 
        filtered_df = date_manipulation(df, False, False, filters)
        rename = {  "Province/State" : "state",
                    "Country/Region": "country",
                    "Lat": "latitude",
                    "Long":  "longitude",
                    "daily_change": "daily_change_cases",
                    "weekly_change": "weekly_change_cases"
                }
    filtered_df.rename(columns=rename, inplace=True)
    filtered_df['state_abbr'] = filtered_df['state'].map(lambda state: provinces_abbrev[state], na_action='ignore')
    filtered_df['latitude'] = filtered_df['latitude'].round(7)
    filtered_df['longitude'] = filtered_df['longitude'].round(7)
    return filtered_df

def filter_df_US(df, deaths):
    filters = ['UID', 'FIPS', 'Combined_Key', 'Country_Region', 'Province_State', 'Admin2', 'Lat', 'Long_']

    if deaths == True:
        filters.append('Population')

    filtered_df = date_manipulation(df, deaths, False, filters)

    if deaths == True:
        rename = {  "UID" : "uid",
                    "FIPS": "fips",
                    "Combined_Key": "combined_key",
                    "Country_Region":  "country",
                    "Province_State": "state",
                    "Admin2": "county",
                    "Lat": "latitude",
                    "Long_": "longitude",
                    "Population": "population",
                    "daily_change": "daily_change_deaths",
                    "weekly_change": "weekly_change_deaths"
                }
    else: 
        rename = {  "UID" : "uid",
                    "FIPS": "fips",
                    "Combined_Key": "combined_key",
                    "Country_Region":  "country",
                    "Province_State": "state",
                    "Admin2": "county",
                    "Lat": "latitude",
                    "Long_": "longitude",
                    "daily_change": "daily_change_cases",
                    "weekly_change": "weekly_change_cases"
                }
    
    filtered_df.rename(columns=rename, inplace=True)

    def get_state_abbrev(state):
      try:
        return us_state_abbrev[state]
      except KeyError:
        return ""

    filtered_df['state_abbr'] = filtered_df['state'].map(get_state_abbrev, na_action='ignore')
    filtered_df['latitude'] = filtered_df['latitude'].round(7)
    filtered_df['longitude'] = filtered_df['longitude'].round(7)
    return filtered_df

def date_manipulation(df, deaths, recovered, filters):

    try:
        current_date_raw = datetime.datetime.now()
        day_before_raw = current_date_raw - datetime.timedelta(days = 1) 
        week_before_raw = current_date_raw - datetime.timedelta(days = 7) 
    
        current_date = current_date_raw.strftime("%-m/%-d/%y")
        day_before = day_before_raw.strftime("%-m/%-d/%y")
        week_before = week_before_raw.strftime("%-m/%-d/%y")

        filters_with_current = list(filters)
        filters_with_current.append(week_before)
        filters_with_current.append(day_before)
        filters_with_current.append(current_date)
        slice_df = df[filters_with_current]
        filtered_df = pd.DataFrame(slice_df)
    
        filtered_df[week_before].fillna(0.0).astype(int)
        filtered_df[day_before].fillna(0.0).astype(int)
        filtered_df[current_date].fillna(0.0).astype(int)

        filtered_df['daily_change']  = filtered_df[current_date] - filtered_df[day_before] 
        filtered_df['weekly_change'] = filtered_df[current_date] - filtered_df[week_before] 
        if deaths == True:
            filtered_df.rename(columns={current_date : 'confirmed_deaths'}, inplace = True)
        elif recovered == True: 
            filtered_df.rename(columns={current_date : 'confirmed_recovered'}, inplace = True)
        else:
            filtered_df.rename(columns={current_date : 'confirmed_cases'}, inplace = True)  
        filtered_df.drop([day_before, week_before], axis=1, inplace=True)
        
        return filtered_df
    
    except KeyError:
        yesterday = current_date_raw - datetime.timedelta(days = 1) 
        two_days_ago = current_date_raw - datetime.timedelta(days = 2) 
        week_before_raw = current_date_raw - datetime.timedelta(days = 8) 


        yesterday = yesterday.strftime("%-m/%-d/%y")
        two_days_ago = two_days_ago.strftime("%-m/%-d/%y")
        week_before = week_before_raw.strftime("%-m/%-d/%y")

        filters_with_yesterday = list(filters)
        filters_with_yesterday.append(week_before)
        filters_with_yesterday.append(two_days_ago)
        filters_with_yesterday.append(yesterday)
        slice_df = df[filters_with_yesterday]
        filtered_df = pd.DataFrame(slice_df)

        filtered_df[week_before].fillna(0.0).astype(int)
        filtered_df[two_days_ago].fillna(0.0).astype(int)
        filtered_df[yesterday].fillna(0.0).astype(int)

        filtered_df['daily_change']  = filtered_df[yesterday] - filtered_df[two_days_ago] 
        filtered_df['weekly_change'] = filtered_df[yesterday] - filtered_df[week_before]

        if deaths == True:
            filtered_df.rename(columns={yesterday : 'confirmed_deaths'}, inplace = True)
        elif recovered == True: 
            filtered_df.rename(columns={yesterday : 'confirmed_recovered'}, inplace = True)
        else:
            filtered_df.rename(columns={yesterday : 'confirmed_cases'}, inplace = True)

        filtered_df.drop([two_days_ago, week_before], axis=1, inplace=True)
        
        return filtered_df

############################################

with open('data/us_state_abbreviations.json', 'r') as file1:
    us_state_abbrev = json.load(file1)

with open('data/global_populations.json', 'r') as file2: 
    global_populations = json.load(file2)

with open('data/provinces_abbreviations.json', 'r') as file3:
    provinces_abbrev = json.load(file3)

if __name__ == '__main__':
    update()
