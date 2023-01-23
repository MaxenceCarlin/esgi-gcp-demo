# Android vs  Apple sample

## How to build Docker container

```
export PROJECT_ID=<GCP_PROJECT_ID>
export REGION=europe-west9 # for Paris
export CONNECTION_NAME=<CLOUD_SQL_CONNECTION> # project_id:region:db_name
```
```
gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/poll \
  --project $PROJECT_ID
```
## How to Deploy
you cna also use .env variables instead of cloud run variables for development purpose, it is recommended to use secret manager to store sensitive data like passwords

```
gcloud run deploy poll \
--image gcr.io/$PROJECT_ID/poll \
--platform managed \
--region $REGION \
--allow-unauthenticated \
--set-env-vars=DB_USER=esgi,CLOUD_SQL_CONNECTION_NAME=$CONNECTION_NAME,DB_NAME=esgi \
--add-cloudsql-instances $CONNECTION_NAME \
--update-secrets=DB_PASS=DB_PASS:latest \ #the name of the secret stored in secret manager (here database password)
--project $PROJECT_ID \
```
## Migrations

Before running the application, execute these schema migration queries

```sql
CREATE TABLE IF NOT EXISTS votes
( vote_id SERIAL NOT NULL, time_cast timestamp NOT NULL,
candidate VARCHAR(6) NOT NULL, PRIMARY KEY (vote_id) );

CREATE TABLE IF NOT EXISTS totals
( total_id SERIAL NOT NULL, candidate VARCHAR(6) NOT NULL,
num_votes INT DEFAULT 0, PRIMARY KEY (total_id) );

INSERT INTO totals (candidate, num_votes) VALUES ('TABS', 0);
INSERT INTO totals (candidate, num_votes) VALUES ('SPACES', 0);

```

## Load testing


### Installing Locust
pip3 install locust

### Running the load test
start server
python3 -m locust -f locustfile.py
