echo "######################## RESPALDANDO ARCHIVOS #############################"
rm -rf documento
echo "######################## CARPETA DOCUMENTO ELIMINADA #############################"
cp -avr /home/deployer/apps/dtebridge/current/public/uploads/documento  ~/
echo "######################## ARCHIVOS RESPALDADOS OK!!!  #############################"
cp -avr /home/deployer/apps/dtebridge/current/app/controllers/api/v1/readmail_controller.rb  ~/documento
cp -avr /home/deployer/apps/dtebridge/current/config/environments/development.rb  ~/documento
cp -avr /home/deployer/apps/dtebridge/current/config/environments/production.rb  ~/documento
cp -avr /home/deployer/apps/dtebridge/current/comando*  ~/documento
cp -avr /home/deployer/apps/dtebridge/current/libro_*  ~/documento
cp -avr /home/deployer/apps/dtebridge/current/publicC*  ~/documento
cp -avr /home/deployer/apps/dtebridge/current/privateK*  ~/documento
echo "######################## ARCHIVOS DE CONFIGURACION OK!!!  #############################"
