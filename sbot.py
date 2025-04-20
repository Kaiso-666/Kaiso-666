import discord
import asyncio
import datetime
import random
from discord.ext import commands

TOKEN = "."
PREFIX = "#"

bot = commands.Bot(command_prefix=PREFIX, self_bot=True)

@bot.event
async def on_ready():
    print("Selfbot Loaded.")

@bot.event
async def on_message(message):
    if message.author == bot.user:
        if message.content.startswith("•"):
            await asyncio.sleep(0.69420)
            await message.delete()
    await bot.process_commands(message)

@bot.command()
async def gcdump(ctx):
    message = ctx.message
    if isinstance(message.channel, discord.DMChannel):
        filename = "dm_dump.txt"
    else:
        filename = "gc_dump.txt"
    
    async with message.channel.typing():
        with open(filename, "w", encoding="utf-8") as f:
            f.write(f"Chat: {message.channel}")
            f.write(f"Created At: {message.channel.created_at}\n")
            f.write("=" * 50 + "\n")

            async for msg in message.channel.history(limit=None):
                timestamp = msg.created_at.strftime("[%Y-%m-%d %H:%M:%S]")
                content = msg.content if msg.content else "[Attachment/Embed]"
                f.write(f"{timestamp} {msg.author} ({msg.author.id}): {content}\n")
    
    await message.channel.send(f"Messages dumped to `{filename}`.", delete_after=5)

@bot.event
async def on_message_delete(message):
    if message.author == bot.user and message.content != "No way bro you tried to snipe? so amazing work 👏":
        msg = await message.channel.send("No way bro you tried to snipe? so amazing work 👏")
        await msg.delete()

@bot.command()
async def truthdare(ctx, *players: discord.Member):
    if not players:
        return await ctx.send("Mention at least one player to play.")
    
    game_id = ctx.channel.id
    active_games = {}
    
    if game_id in active_games:
        return await ctx.send("A game is already in progress in this channel.")
    
    active_games[game_id] = True
    
    for round_num in range(1, 6):
        chosen = random.choice(players)
        msg = await ctx.send(f"**Round {round_num}:** {chosen.mention} was chosen! React with 🇹 for Truth or 🇩 for Dare.")
        await msg.add_reaction("🇹")
        await msg.add_reaction("🇩")
        
        await asyncio.sleep(7.5)
        msg = await ctx.channel.fetch_message(msg.id)
        
        t_count = sum(reaction.count for reaction in msg.reactions if str(reaction.emoji) == "🇹")
        d_count = sum(reaction.count for reaction in msg.reactions if str(reaction.emoji) == "🇩")
        
        choice = "Truth" if t_count > d_count else "Dare" if d_count > t_count else random.choice(["Truth", "Dare"])
        
        await ctx.send(f"{chosen.mention} has to do **{choice}**!")
        
        try:
            await bot.wait_for("message", check=lambda m: m.content.lower() == "roundend" and m.author == ctx.author, timeout=60*10)
        except asyncio.TimeoutError:
            await ctx.send("Game ended due to inactivity.")
            break
    
    del active_games[game_id]
    await ctx.send("**Game over!**")

bot.run(TOKEN)