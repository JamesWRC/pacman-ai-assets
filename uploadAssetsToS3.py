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


import zipfile
    
def zipdir(path, ziph):
    # ziph is zipfile handle
    for root, dirs, files in os.walk(path):
        for file in files:
            ziph.write(os.path.join(root, file), 
                       os.path.relpath(os.path.join(root, file), 
                                       os.path.join(path, '..')))
      


#testing

os.chdir('/bazel_3_1_0/tensorflow')



zipf = zipfile.ZipFile('tensor.zip', 'w', zipfile.ZIP_DEFLATED)
zipdir('.', zipf)
zipf.close()

uploaded = upload_to_aws('tensor.zip', 'pacman-ai-assets', 'tensor-assets.zip')
