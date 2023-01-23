#! /bin/bash

export PROJECT_ID=<YOUR_PROJECT_ID>
export REGION=europe-west9
export CONNECTION_NAME=$PROJECT_ID:$REGION:<DB_NAME>


gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/poll \
  --project $PROJECT_ID


gcloud run deploy poll \
--image gcr.io/$PROJECT_ID/poll \
--platform managed \
--region $REGION \
--allow-unauthenticated \
--set-env-vars=DB_USER=esgi,CLOUD_SQL_CONNECTION_NAME=$CONNECTION_NAME,DB_NAME=esgi \
--add-cloudsql-instances $CONNECTION_NAME \
--update-secrets=DB_PASS=DB_PASS:latest \ #the name of the secret stored in secret manager (here database password)
--project $PROJECT_ID \