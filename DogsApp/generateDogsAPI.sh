MODULE="Modules/DogsAPI/Sources/DogsAPI/"

openapi-generator generate -i "dogsapi.yaml" -g swift5 -o "dogsapi"
rm -r $MODULE""*
cp -R "dogsapi/OpenAPIClient/Classes/OpenAPIs/". $MODULE
rm -r "dogsapi"
