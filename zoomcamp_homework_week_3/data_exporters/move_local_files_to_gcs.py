from google.cloud import storage

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


bucket_name = "terraform-demo-412521-ny-taxi-data"

@data_exporter
def export_data_to_google_cloud_storage(files_list: list, **kwargs) -> None:
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    
    for f_name in files_list:
        blob = bucket.blob(f_name)
        blob.upload_from_filename(kwargs["data_folder"] + f_name)

        print(
            "File {} uploaded to {}.".format(
                f_name, bucket_name
            )
        )