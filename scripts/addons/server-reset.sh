#!/usr/bin/env bash
#
# Check if web server is running and if not restart it.
# In case some site setting required mount directories to be present and made it unable to start

systemctl is-active --quiet nginx.service
nginx=$?

systemctl is-active --quiet apache2.service
apache2=$?

if [ ${nginx} != "0" ] && [ ${apache2} != "0" ] && [ $1 = "true" ]
    then
        systemctl restart nginx.service
        echo "Server restarted.";
    else
        echo "Server running.";
fi