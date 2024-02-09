import requests
import os

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader


year = 2022
taxi_color = "green"
file_name_template = "{taxi_color}_tripdata_{year}-{month}.parquet"
destination_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/"

@data_loader
def load_data_from_api(*args, **kwargs):
    data_folder = kwargs["data_folder"]
    files_list = []

    # Check if folder for storing the data exists
    if not os.path.exists(data_folder):
        os.makedirs(data_folder)

    for i in range(12):
        month = "0" + str(i + 1)
        month = month[-2:]
        file_name = file_name_template.format(year=year, taxi_color=taxi_color, month=month)

        #  Download the data behind the URL
        url = destination_url + file_name
        response = requests.get(url)

        file_path = data_folder + file_name

        if not os.path.exists(file_path):
            # Open the response generated into a new file in your local called image.jpg
            open(file_path, "wb").write(response.content)
            print(f"File {file_name} is uploaded.")

            files_list.append(file_name)

    return files_list
