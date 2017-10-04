mvn deploy:deploy-file -DgroupId=org.milyn.edi.unedifact \
-DartifactId=d96b-mapping-maersk \
-Dversion=1.7.0 \
-Dpackaging=jar \
-Dfile=mapping/target/org.milyn.edi.unedifact.d96b-mapping-maersk_1.7.0.jar \
-Durl=http://10.240.6.45:8080/repository/internal/ \
-DrepositoryId=internal

mvn deploy:deploy-file -DgroupId=org.milyn.edi.unedifact \
-DartifactId=d96b-binding-maersk \
-Dversion=1.7.0 \
-Dpackaging=jar \
-Dfile=binding/target/org.milyn.edi.unedifact.d96b-binding-maersk_1.7.0.jar \
-Durl=http://10.240.6.45:8080/repository/internal/ \
-DrepositoryId=internal