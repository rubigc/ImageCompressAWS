#!/bin/bash
# Name: Bildverkleinerung
# Datum: 17.12.2023
# Autoren: Adrian Orlamünde, Alessandro Melcher

# ------------------------------- Variablen erstellen -------------------------------
IMAGE_PATH="gbssg_logo.png"
IMAGE_NAME="gbssg_logo"


# ------------------------------- Buckets erstellen -------------------------------
BUCKET_NAME_SRC="bildverkleinerungsource"
BUCKET_NAME_DST="bildverkleinerungdestination"

REGION="us-east-1"

echo "Erster Bucket wird erstellt"
aws s3 rm s3://$BUCKET_NAME_SRC --recursive
aws s3api delete-bucket --bucket $BUCKET_NAME_SRC --region $REGION
aws s3api wait bucket-not-exists --bucket $BUCKET_NAME_SRC --region $REGION
aws s3api create-bucket --bucket $BUCKET_NAME_SRC --region $REGION
echo "Erster Bucket erstellt"


echo "Zweiter Bucket wird erstellt"
aws s3 rm s3://$BUCKET_NAME_DST --recursive
aws s3api delete-bucket --bucket $BUCKET_NAME_DST --region $REGION
aws s3api wait bucket-not-exists --bucket $BUCKET_NAME_DST --region $REGION
aws s3api create-bucket --bucket $BUCKET_NAME_DST --region $REGION
echo "Zweiter Bucket erstellt"











# ------------------------------- Lambdafunktion erstellen und ausführen / Trigger -------------------------------
ACCOUNTID=$(aws sts get-caller-identity --query "Account" --output text)
LABROLE="arn:aws:iam::$ACCOUNTID:role/LabRole"

LAMBDA_FUNCTION_NAME="LamdaBildkomprimierung"

echo "Lambda-Funktion wird erstellt"
aws lambda delete-function --function-name "$LAMBDA_FUNCTION_NAME"
aws lambda create-function --function-name "$LAMBDA_FUNCTION_NAME" --zip-file fileb://lambda_function.zip --handler lambda_function.lambda_handler --runtime python3.11 --role $LABROLE
echo "Lambda-Funktion erstellt"

echo "Trigger wird erstellt"
LAMBDA_FUNCTION_ARN=$(aws lambda get-function --function-name "$LAMBDA_FUNCTION_NAME" --query "Configuration.FunctionArn" --output text)

aws lambda add-permission \
    --function-name $LAMBDA_FUNCTION_NAME \
    --action lambda:InvokeFunction \
    --principal s3.amazonaws.com \
    --source-arn arn:aws:s3:::$BUCKET_NAME_SRC \
    --statement-id s3invoke

aws s3api put-bucket-notification-configuration \
    --bucket $BUCKET_NAME_SRC \
    --notification-configuration '{
        "LambdaFunctionConfigurations": [
            {
                "LambdaFunctionArn": "'$LAMBDA_FUNCTION_ARN'",
                "Events": ["s3:ObjectCreated:*"]
            }
        ]
    }'
echo "Trigger erstellt"





# ------------------------------- Bild in den Source Bucket hochladen -------------------------------
echo -n "Bildverkleinerungsrate eingeben: "
read reductionrate

# Bild in den Source Bucket hochladen
echo "Bild wird hochgeladen"
aws s3 cp $IMAGE_PATH s3://$BUCKET_NAME_SRC/ --region $REGION --metadata reduction_rate=$reductionrate --metadata output_bucket="s3://$BUCKET_NAME_DST/$IMAGE_NAME""_resized.png"
echo "Bild hochgeladen"