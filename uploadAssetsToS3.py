import boto3
import os
import time
from botocore.exceptions import NoCredentialsError

ACCESS_KEY = os.environ['S3_ACCESS_KEY']
SECRET_KEY = os.environ['S3_SECRET_KEY']

print(ACCESS_KEY)

def upload_to_aws(local_file, bucket, s3_file):
    s3 = boto3.client('s3', aws_access_key_id=ACCESS_KEY,
                      aws_secret_access_key=SECRET_KEY)

    try:
        s3.upload_file(local_file, bucket, s3_file)
        print("Upload Successful")
        return True
    except FileNotFoundError:
        print("The file was not found")
        return False
    except NoCredentialsError:
        print("Credentials not available")
        return False


uploaded = upload_to_aws('/tmp/tensor/tensorflow-2.4.1-cp38-cp38-linux_aarch64.whl', 'pacman-ai-assets', 'tensorflow-2.4.1-cp38-cp38-linux_aarch64.whl')