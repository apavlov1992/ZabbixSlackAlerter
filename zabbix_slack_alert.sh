#!/usr/bin/env bash
# send zabbix alerts to slack - tested on Zabbix 3.4
set -o errexit

# variables definition
slack_webhook=''
slack_username='Zabbix'
slack_avatar=''
recovery_color='#7AFF32'
problem_color='#BB1515'
declare -a problem_slack_emojis=(':hankey:' ':scream:' ':cry:' ':tired_face:' ':face_with_head_bandage:' ':sob:' ':cold_sweat:' ':fire:' )
number_of_problem_emojis=${#problem_slack_emojis[@]}

# script parameters
# to = $1 (Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "#channel")
# subject = $2 (usually either PROBLEM or RECOVERY)
# message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")
to="${1}"
subject="${2}"
message="${3:9}" # remove first 'Trigger: ' word from string for cleaner subject
message=$(echo -e "${message}" | grep -m 1 -E '*\n') # get only first line

# change message emoji and color depending on the subject
recoversub='^OK.*$'
problemsub='^PROBLEM.*$'
if [[ ${subject} =~ ${recoversub} ]]
then
	slack_emoji=':tada:'
	slack_color=${recovery_color}
	slack_status='OK:'
elif [[ ${subject} =~ ${problemsub} ]]
then
	random_emoji=$((0 + RANDOM % number_of_problem_emojis))
	slack_emoji=${problem_slack_emojis[${random_emoji}]}
	slack_color=${problem_color}
	slack_status='PROBLEM:'
else
	slack_emoji=':ghost:'
	slack_color=${problem_color}
	slack_status='UNKNOWN:'
fi

# the message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier) followed by the message that Zabbix actually sent us ($3)
slack_message="${slack_emoji} ${slack_status} ${message}"

curl -m 5 -sX POST \
    --data-urlencode 'payload={"channel": "'${to}'", "username": "'${slack_username}'", "icon_url": "'${slack_avatar}'", "attachments": [{"title": "'"${slack_message}"'", "color": "'${slack_color}'" }]}' \
    "${slack_webhook}" -A 'zabbix-alert-script | gek0 - https://github.com/gek0'

exit 0
