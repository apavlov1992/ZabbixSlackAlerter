ZabbixSlackAlerter
========================


About
-----
Simple Bash script that uses the custom alert script functionality within [Zabbix](http://www.zabbix.com/) with the incoming web-hook feature of [Slack](https://slack.com/).

#### Versions
This is tested and with Zabbix 3.4.x, should also work with greater versions.

Installation
------------

### The script itself

This [`zabbix_slack_alert.sh` script](https://github.com/gek0/ZabbixSlackAlerter/blob/master/zabbix_slack_alert.sh) needs to be placed in the `AlertScriptsPath` directory that is specified within the Zabbix servers' configuration file (`zabbix_server.conf`) and must be executable:

	[root@zabbix ~]# grep AlertScriptsPath /etc/zabbix/zabbix_server.conf
	### Option: AlertScriptsPath
	AlertScriptsPath=/usr/lib/zabbix/alertscripts

	[root@zabbix ~]# ls -lah /usr/lib/zabbix/alertscriptszabbix_slack_alert.sh
	-rwxr-xr-x 1 root root 1,9K Ruj 21 12:59 /usr/lib/zabbix/alertscripts/zabbix_slack_alert.sh

If you do change `AlertScriptsPath` (or any other values) within `zabbix_server.conf`, a restart of the Zabbix server service is required.

Configuration
-------------

### Within the Zabbix web interface

When logged in to the Zabbix servers web interface with super-administrator privileges, navigate to the "Administration" tab, access the "Media Types" sub-tab, and click the "Create media type" button.

You need to create a media type as follows:

* **Name**: Slack
* **Type**: Script
* **Script name**: zabbix_slack_alert.sh

* **Script parameters**:
 `{ALERT.SENDTO}`
 `{ALERT.SUBJECT}`
 `{ALERT.MESSAGE}`

...as shown here:

![Zabbix 3.x Media Type](https://i.imgur.com/0ESIohI.png "Zabbix 3.x Media Type")

Add media to user of your choice and enable that media. Save and thats it.

More Information
----------------
* [Zabbix 3.4 custom alertscripts documentation](https://www.zabbix.com/documentation/3.0/manual/config/notifications/media/script)
* [Slack Incoming Webhooks](https://api.slack.com/incoming-webhooks)