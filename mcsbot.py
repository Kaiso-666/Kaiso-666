import requests
import time

token = ".-"
channel_ids = ['1330359015439597701', '1330211066096910416', '1351242210967945291', '1070744683728343141']
headers = {
    'Authorization': token,
    'Content-Type': 'application/json'
}

while True:
    for channel_id in channel_ids:
        url = f'https://discord.com/api/v9/channels/{channel_id}/typing'
        requests.post(url, headers=headers)
    time.sleep(1)