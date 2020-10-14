#/!bin/bash

testParameters=("ok" "ng" "ok ng" "xxx" 1)
for parameter in "${testParameters[@]}"
do
  sh ok-or-ng-redirect.sh $parameter
done
