#!/bin/bash

FILES=output/fhir/*
URL='https://<your-aidbox-instance>.edge.aidbox.app/fhir'
USER=<username>
PASS=<password>

for f in $FILES
do
  echo Processing $f file...
  curl -s -X POST -H "Content-Type: application/json" --user $USER:$PASS -d @$f $URL
done
