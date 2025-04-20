import discord  
import asyncio  
import requests  
  
TOKENS = [
    ".",
    "-"
]
  
CHANNEL_ID = 1338424984749740032  
BOT_ID = 574652751745777665  
  
class SelfBot(discord.Client):  
    def __init__(self, token):  
        super().__init__(selfbot=True)  
        self.token = token  
        self.headers = {"Authorization": self.token}  
  
    async def process_last_message(self):  
        await self.wait_until_ready()  
        channel = self.get_channel(CHANNEL_ID)  
  
        while True:  
            messages = [msg async for msg in channel.history(limit=10) if msg.author.id == BOT_ID]  
  
            if messages:  
                msg = messages[0]  # Get the latest bot message  
  
                if msg.components:  
                    button = msg.components[0].children[0]  
                    custom_id = button.custom_id  
  
                    button_payload = {  
                        "type": 3,  
                        "guild_id": str(msg.guild.id),  
                        "channel_id": str(msg.channel.id),  
                        "message_id": str(msg.id),  
                        "application_id": str(msg.author.id),  
                        "session_id": "random-session-id",  
                        "data": {"component_type": 2, "custom_id": custom_id}  
                    }  
  
                    button_response = requests.post(  
                        "https://discord.com/api/v9/interactions",  
                        json=button_payload,  
                        headers=self.headers  
                    )  
  
                    if button_response.status_code == 204:  
                        print(f"({self.user}) Pressed button successfully")  
                    else:  
                        print(f"({self.user}) Button press failed: {button_response.text}")  
            await asyncio.sleep(3)  
  
    async def on_ready(self):  
        print(f"Logged in as {self.user}")  
        self.loop.create_task(self.process_last_message())  
  
async def main():  
    bots = [SelfBot(token) for token in TOKENS]  
    tasks = [bot.start(token) for bot, token in zip(bots, TOKENS)]  
    await asyncio.gather(*tasks)  
  
asyncio.run(main())