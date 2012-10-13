# sh domainset.sh <domain.name.tld> <location/of/index>

echo "Settings up domain name $1"
echo "At the location $2"

touch $1
salias=`echo $1 | cut -d'.' -f1`
echo "<VirtualHost *:80>
    ServerName $1
    ServerAlias $salias
    DocumentRoot $2

    <Directory $2/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
        Order allow,deny
        allow from all
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/$salias-error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > $1

touch hosts
echo "127.0.0.1       $1" > hosts
sudo cat /etc/hosts >> hosts

sudo mv hosts /etc/hosts
sudo mv $1 /etc/apache2/sites-available/

sudo a2dissite $1
sudo a2ensite $1

sudo service apache2 reload
