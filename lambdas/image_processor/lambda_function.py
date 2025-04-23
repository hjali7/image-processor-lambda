import boto3
import os
from PIL import Image
import io
from dotenv import load_dotenv

load_dotenv()

aws_endpoint_url=os.getenv("AWS_ENDPOINT_URL")

def lambda_handler(event , context ) :
    print("Event received:", event)
    s3 = boto3.client("s3", endpoit_url=aws_endpoint_url)
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['object']['key']
    destination_bucket = 'image-processor'

    # download image
    image_object = s3.get_object(Bucket=source_bucket , key=key)
    image_content= image_object['Body'].read()

    image = Image.open(io.BytesIO(image_content)).convert("L")  # "L" یعنی سیاه و سفید
    buffer = io.BytesIO()
    image.save(buffer, format='PNG')
    buffer.seek(0)

    s3.put_object(Bucket=destination_bucket , key = f'processed-{key}',Body=buffer)

    print("✅ Image processed and uploaded.")
    return {
        'statusCode': 200,
        'body': 'Image processed successfully!'
    }