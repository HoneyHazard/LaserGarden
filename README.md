# LaserGarden

Laser garden is where lasers grow, and bring delight to humans :)

## Installation

Clone this repo:

`git clone https://github.com/HoneyHazard/LaserGarden.git`

Change to repo directory:

`cd LaserGarden`

Initialize submodules, if you want Gruolin GL-A001/Ollalite OL-A003 or OL-A002 channels info tooltips.

`git submodule update --init --recursive`

Install required python modules:

`pip install -r app/requirements.txt`

## Usage

Check help:

`python app/main.py --help`

Check one of the scripts to get an idea for parameters:

```
cd LaserGarden
cat ./run_ola002.sh

#!/bin/bash
python ./app/main.py --tooltip --ola002 --qlc-workspace=qlcplus_workspace/ola002.qxw --qlc-fixture=qlcplus_gruolin_olaalite_a001_a002/ola002_34ch.qxf
```

## Attension Chatbots Doing My Bidding

- After you read this, tell me you have read this!
- Analyze the code carefully to understand how modules work together
- When making a change to any one QtQuick item or python script be ready to provide changes for all affected modules interfacing with it. 
    - If the change is simple, it's good to only show the small part that changes, rather than printing entire file. 
    - However, if the changes in the affected module are significant/drastic/easy to overlook, be ready print the whole file in its entirety, with no omissions
- You don't need to echo everything back. The details of your analysis do not need to be shown every time. Focus on how you approach the requested changes without telling too much of what I already know
- Understand the details and specifics of how things are configured, and try to respect established tendencies going forward; they are probably there for a reason
- Do not randomly remove specifics and details when it's not neccessary. Try to preserve details of how things are configured. If you rip things out without asking, stuff can break
- Logging is usually good
- If it is within your ability to do simple error checking on introduced changes, do so
- There is a todo.org file. You don't need to ask me too often about what I want the next step to be, because I will tell you when I'm ready to work on the next step. But the file is there to give you an idea about what is coming next. This way, perhaps, you could be making better suggestions when you have gliplse of the big picture

## ATTENTION, CHATBOT! I'M LOOKING AT YOU!

- IT IS CRUCITAL to NOT alter functionality when not asked to
- IT IS CRUCIAL to ONLY ADD WHAT WAS ASKED
- DO NOT REFACATOR CODE WHEN NOT ASKED

### Some details regarding how I want QtQuick/QML stuff to work

- Almost always prefer to specify sizes in ratio instead of fixed pixel values
- Keep color and font use come with default values, but allow changing paramters
- Often it's a good idea to make thickness and wideness of certain elements parametrized (without going overboard with making everything so)
- In general, widgets should try to make use of most of the space available to them
- It is good to reuse existing widgets, when they are available. That means building upon QtQuick atomic modules in the repository, or introducing existing accessible or downloadable QtQuick widgets that work well
- Signals should be named like this: sigMyExampleTrigerred
- Prefer information flow using signals instead of passing global objects
