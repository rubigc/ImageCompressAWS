#!/bin/bash
# Name: Bildverkleinerung
# Datum: 17.12.2023
# Autoren: Ruben Gonzalez Cruz, Adrian Orlamünde, Alessandro Melcher

# ------------------------------- Variablen erstellen -------------------------------
IMAGE_PATH="gbssg_logo.png"
IMAGE_NAME="gbssg_logo"
REDUCTION_RATE="2"
BUCKET_NAME_SRC="bildverkleinerungsource"
BUCKET_NAME_DST="bildverkleinerungdestination"
REGION="us-east-1"
LAMBDA_FUNCTION_NAME="LamdaBildkomprimierung"

# ------------------------------- Buckets erstellen -------------------------------
if aws s3api head-bucket --bucket "$BUCKET_NAME_SRC" 2>/dev/null; then
    echo "Bucket $bucket_name existiert bereits und wird zuerst gelöscht."
    echo "Neuer, erster Bucket wird erstellt"
    aws s3 rm s3://$BUCKET_NAME_SRC --recursive
    aws s3api delete-bucket --bucket $BUCKET_NAME_SRC --region $REGION
    aws s3api wait bucket-not-exists --bucket $BUCKET_NAME_SRC --region $REGION
    aws s3api create-bucket --bucket $BUCKET_NAME_SRC --region $REGION
    echo "Neuer, erster Bucket $BUCKET_NAME_SRC erstellt"
else
    echo "Erster Bucket wird erstellt"
    aws s3api create-bucket --bucket $BUCKET_NAME_SRC --region $REGION
    echo "Erster Bucket $BUCKET_NAME_SRC erstellt"
fi

if aws s3api head-bucket --bucket "$BUCKET_NAME_DST" 2>/dev/null; then
    echo "Bucket $bucket_name existiert bereits und wird zuerst gelöscht."
    echo "Neuer, zweiter Bucket wird erstellt"
    aws s3 rm s3://$BUCKET_NAME_DST --recursive
    aws s3api delete-bucket --bucket $BUCKET_NAME_DST --region $REGION
    aws s3api wait bucket-not-exists --bucket $BUCKET_NAME_DST --region $REGION
    aws s3api create-bucket --bucket $BUCKET_NAME_DST --region $REGION
    echo "Neuer, zweiter Bucket $BUCKET_NAME_DST erstellt"
else
    echo "Zweiter Bucket wird erstellt"
    aws s3api create-bucket --bucket $BUCKET_NAME_DST --region $REGION
    echo "Zweiter Bucket $BUCKET_NAME_DST erstellt"
fi

# ------------------------------- Lambdafunktion erstellen und ausführen / Trigger -------------------------------
ACCOUNTID=$(aws sts get-caller-identity --query "Account" --output text)
LABROLE="arn:aws:iam::$ACCOUNTID:role/LabRole"

if aws lambda get-function --function-name "$LAMBDA_FUNCTION_NAME" 2>/dev/null; then
    echo "Lambda-Function $LAMBDA_FUNCTION_NAME existiert bereits und wird zuerst gelöscht."
    aws lambda delete-function --function-name "$LAMBDA_FUNCTION_NAME"
    echo "Lambda-Funktion wird erstellt"
    aws lambda create-function --function-name "$LAMBDA_FUNCTION_NAME" --zip-file fileb://pythonfunction.zip --handler lambda_function.lambda_handler --runtime python3.8 --role $LABROLE
    echo "Lambda-Funktion erstellt"
else
    echo "Lambda-Funktion wird erstellt"
    aws lambda create-function --function-name "$LAMBDA_FUNCTION_NAME" --zip-file fileb://pythonfunction.zip --handler lambda_function.lambda_handler --runtime python3.8 --role $LABROLE
    echo "Lambda-Funktion erstellt"
fi

LAMBDA_ARN=$(aws lambda get-function-configuration --function-name "$LAMBDA_FUNCTION_NAME" --query "FunctionArn" --output text --region "$REGION")

echo "Trigger wird erstellt"
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
                "LambdaFunctionArn": "'$LAMBDA_ARN'",
                "Events": ["s3:ObjectCreated:*"]
            }
        ]
    }'
echo "Trigger erstellt"

# ------------------------------- Bild in den Source Bucket hochladen -------------------------------
echo "Bild wird in $BUCKET_NAME_SRC hochgeladen"
# Bild in den Source Bucket hochladen
aws s3 cp $IMAGE_PATH s3://$BUCKET_NAME_SRC/ --region $REGION --metadata metadata="$REDUCTION_RATE;$BUCKET_NAME_DST"
echo "Bild in $BUCKET_NAME_SRC hochgeladen"
