# RGV-HIE-FHIR-hackathon
Test data and instructions how to load it into Aidbox for the participants of the RGV HIE FHIR hackathon.

### Configuring authentication for your Aidbox instance

You will need to set up access policy for your account. This can be in the
`Access Control` tab in the UI. Click the `new` button and add a policy such as:

```yaml
engine: json-schema
schema:
  required:
    - client
    - uri
    - request-method
  properties:
    client:
      required:
        - id
      properties:
        id:
          const: postman
id: policy-for-postman
resourceType: AccessPolicy
```

Next, navigate to the `Auth Clients` tab and create a new client with the following configuration:

```yaml
secret: secret
grant_types:
  - basic
id: postman
resourceType: Client
```

You should now be able to log in using HTTP Basic Auth with the user name `postman` and
password `secret`.

For more information on configuring authentication for your Aidbox instance please refer to the [official documentation(https://docs.aidbox.app/tutorials/authentication-and-authorization).

### Generating Test Data

Test data can be generated using [synthea](https://github.com/synthetichealth/synthea) patient population simulator. The tool
is installed by cloning the GitHub repository and running the build
command:

```
git clone https://github.com/synthetichealth/synthea.git
cd synthea
./gradlew build
```

Once synthea is installed, you can use it to generate a set
number of sample patients as follows:

```
./run_synthea -p 50
```

it's also possible to specify a random seed using the `-s` flag:

```
./run_synthea -s 100 -p 50
```

Running the above command should generate 50 patients in the
`output/fhir` folder. The generated data will be in form of FHIR bundles
containing the patient along with allergies, lab results,
and so on randomized for each patient.

It's also possible to generate patients for a particular health organization. For example, you could generate patients for
Texas Harlingen as follows:

```
./run_synthea -p 10 Texas Harlingen
```

### Loading data into Aidbox

Once you've generated the sample data, you can load it into Aidbox by running the following
command from the synthea root folder:

```
curl -X POST -H "Content-Type: application/json" --user user:password -d @output/fhir/Garth972_Bergnaum523_c023b321-a8c1-430f-b0c1-70bb66be8a8b.json https://<your-aidbox-instance>.edge.aidbox.app/fhir
```

You can load multiple records using the [following bash script](/load-patients.sh):

```bash
#!/bin/bash
FILES=output/fhir/*
URL='https://<your-aidbox-instance>.edge.aidbox.app/fhir'
USER=<username>
PASS=<password>

for f in $FILES
do
  echo Processing $f file...
  curl -s -X POST -H "Content-Type: application/json" --user $USER:$PASS -data @$f $URL
done
```

Make sure to set the `URL`, `USER`, and `PASS` variables to the ones matching your Aidbox credentials.
Save the above script in a file called `load-patients.sh` in the synthea root foler and run it:

```
bash load-patients.sh
```


You should now be able to see the patients and their associated resources in the Aidbox web console.