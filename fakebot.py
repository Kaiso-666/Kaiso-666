import discord  
import asyncio  
import re  
import sys  
from tboxdec import tbox  
from hta import hta, rcolor  

d_bg_d = "\033[48;2;28;29;35m"  
TEXT_COLOR = "\033[38;2;201;205;251m"  
BG_COLOR = "\033[48;2;47;50;97m"  
HIGHLIGHT_BG = "\033[48;2;46;42;37m"  

TOKEN = "."  
CHANNEL_ID = 1330211066096910416  

intents = discord.Intents.default()
client = discord.Client(intents=intents)  
input_queue = asyncio.Queue()  

# Store the last message from each user
user_last_messages = {}

@client.event  
async def on_ready():  
    print(d_bg_d)  
    print(tbox(f"Logged in as \"{client.user.name}\"."))  
    asyncio.create_task(read_terminal_input())  
    asyncio.create_task(send_terminal_input())  

async def read_terminal_input():  
    await client.wait_until_ready()  
    channel = client.get_channel(CHANNEL_ID)  
    buffer = ""  
    typing = None

    while True:  
        char = await asyncio.to_thread(sys.stdin.read, 1)  
        if not buffer and char not in ("\n", "\r"):  
            typing = channel.typing()  
            await typing.__aenter__()  
        if char in ("\n", "\r"):  
            if typing:  
                await typing.__aexit__(None, None, None)  
                typing = None  
            await input_queue.put(buffer)  
            buffer = ""  
        else:  
            buffer += char  

async def send_terminal_input():  
    await client.wait_until_ready()  
    channel = client.get_channel(CHANNEL_ID)  
    if not channel:  
        print("Invalid channel ID!")  
        return  

    while True:  
        msg_content = await input_queue.get()  
        if msg_content.strip():  
            # Check if this is a reply command
            if msg_content.startswith('.r '):
                parts = msg_content.split(' ', 2)
                if len(parts) >= 3:
                    username = parts[1]
                    reply_content = parts[2]
                    
                    # Find the target user's last message
                    target_message = None
                    for user_id, last_msg in user_last_messages.items():
                        user = await client.fetch_user(user_id)
                        if user.name.lower() == username.lower():
                            target_message = last_msg
                            break
                    
                    if target_message:
                        await target_message.reply(reply_content)
                        continue
            
            # Regular message
            await channel.send(msg_content)  

@client.event  
async def on_message(msg):  
    # Only process messages from the specified channel
    if msg.channel.id != CHANNEL_ID:
        return
        
    if msg.author == client.user:  
        return  

    # Store the last message from each user
    user_last_messages[msg.author.id] = msg

    # Check if this is a reply
    is_reply = msg.reference is not None and msg.reference.message_id is not None
    
    content = msg.content  
    mention_matches = re.findall(r"<@!?(\d+)>", content)  
    for user_id in mention_matches:  
        user = await client.fetch_user(int(user_id))  
        if user:  
            formatted_name = f"{rcolor()}{BG_COLOR}{TEXT_COLOR}{user.name}{rcolor()}{d_bg_d}"  
            content = content.replace(f"<@{user_id}>", formatted_name).replace(f"<@!{user_id}>", formatted_name)  

    content = re.sub(r"<:([a-zA-Z0-9_]+):\d+>", r":\1:", content)  

    # Handle role color (check if author is Member or User)
    if isinstance(msg.author, discord.Member):
        author_color = hta(msg.author.top_role.color) if msg.author.top_role else ""
    else:
        author_color = ""

    prefix = "[REPLY] - " if is_reply else ""
    formatted_message = f"{rcolor()}{d_bg_d}{prefix}{msg.channel.name} | {author_color}{msg.author.display_name}{rcolor()}{d_bg_d}:- {content}"  
    print(formatted_message)  

@client.event
async def on_reaction_add(reaction, user):
    # Only process reactions in the specified channel
    if reaction.message.channel.id != CHANNEL_ID:
        return
        
    # Check if the reaction is on the bot's message
    if reaction.message.author == client.user and user != client.user:
        emoji = reaction.emoji
        # Handle custom emojis
        if isinstance(emoji, discord.Emoji):
            emoji_str = f":{emoji.name}:"
        else:
            emoji_str = str(emoji)
        
        message = f"{rcolor()}{d_bg_d}{user.name} reacted to your message with {emoji_str}{rcolor()}"
        print(message)

client.run(TOKEN)