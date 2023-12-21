#Author: Ruben Gonzalez Cruz
#Datum: 17/12/2023
#Quellen: PIL Dokumentation und boto3 Dokumentation

import boto3
from PIL import Image
import io

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # Get bucket name and object key from the event
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']
    
    # Get metadata
    response = s3_client.head_object(Bucket=source_bucket, Key=object_key)
    metadata = response['Metadata']

    metadata_str = metadata.get('metadata')
    metadata_array = metadata_str.split(';')

    # Parse metadata
    reduction_rate = metadata_array[0]
    output_bucket = metadata_array[1]

    # Download the image from S3
    image_content = s3_client.get_object(Bucket=source_bucket, Key=object_key)['Body'].read()
    image = Image.open(io.BytesIO(image_content))

    #Adjust reduction rate
    reduction_rate = int(reduction_rate)
    reduction_rate = 1/reduction_rate
    desired_width = image.width * reduction_rate
    desired_height = image.height * reduction_rate

    # Resize the image
    resized_image = image.resize((int(desired_width), int(desired_height)))

    # Save the image to a buffer
    buffer = io.BytesIO()
    resized_image.save(buffer, format=image.format)
    buffer.seek(0)

    print(object_key)
    # Upload the image to the output bucket
    s3_client.put_object(Bucket=output_bucket, Key=object_key, Body=buffer)

    #Return that the function was successful
    return {
        'statusCode': 200,
        'body': 'Image processed and uploaded successfully'
    }
