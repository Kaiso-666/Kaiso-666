import discord
import asyncio

TOKENS = [
"2",
"23"
]

class Selfbot(discord.Client):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        

    async def on_ready(self):
        print(f"Logged in as {self.user}")
        activity = discord.Activity(type=discord.ActivityType.watching, name="Finding The 1/3", state="2/3 is Complete", details="DC TOKEN Reversing", instance=True)
        await self.change_presence(status=discord.Status.invisible, activity=activity)
       

    async def on_message(self, message):
        if message.author.id != self.user.id:
            return
        
        if message.content.startswith(".setact"):
            args = message.content.split(maxsplit=4)
            if len(args) < 2:
                await message.channel.send("Usage: `.setact <activity_type> <name> <state> <details>`")
                return

            activity_type = args[1].lower() if len(args) > 1 else "playing"
            name = args[2] if len(args) > 2 else "❄️ Frostware V3.6 ❄️"
            state = args[3] if len(args) > 3 else "Get It Now At discord.gg/getfrost"
            details = args[4] if len(args) > 4 else "FW V3.6 Is Now Released"

            types = {
                "playing": discord.ActivityType.playing,
                "streaming": discord.ActivityType.streaming,
                "listening": discord.ActivityType.listening,
                "watching": discord.ActivityType.watching,
                "competing": discord.ActivityType.competing,
            }

            activity = discord.Activity(
                type=types.get(activity_type, discord.ActivityType.playing),
                name=name,
                state=state,
                details=details,
                timestamps={"start": 1742404260},
                instance=True
            )

            await self.change_presence(activity=activity)
            await message.channel.send(f"Activity set to **{activity_type.capitalize()}** '{name}'.")

        elif message.content.startswith(".actex"):
            examples = (
                "**Playing:** `.setact playing \"Minecraft\" \"Building a new world\" \"Survival mode\"`\n"
                "**Streaming:** `.setact streaming \"Twitch\" \"Live Now!\" \"Streaming Apex Legends\"`\n"
                "**Listening:** `.setact listening \"Spotify\" \"Lo-Fi Beats\" \"Relaxing music session\"`\n"
                "**Watching:** `.setact watching \"YouTube\" \"New Videos Daily\" \"Checking out trending content\"`\n"
                "**Competing:** `.setact competing \"Valorant Tournament\" \"Ranked Mode\" \"Final Match\"`"
            )
            await message.channel.send(f"**Examples of Activity Types:**\n{examples}")

async def start_client(token):
    client = Selfbot(intents=discord.Intents.default())
    await client.start(token, bot=False)

async def main():
    await asyncio.gather(*(start_client(token) for token in TOKENS))

asyncio.run(main())