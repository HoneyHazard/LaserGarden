# LaserGarden

Laser garden is where lasers grow, and bring delight to humans :)

## Attension Chatbots Doing My Bidding

- Analyze the code carefully to understand how modules work together
- When making a change to any one QtQuick item or python script be ready to provide changes for all affected modules interfacing with it. 
    - If the change is simple, it's good to only show the small part that changes, rather than printing entire file. 
    - However, if the changes in the affected module are significant/drastic/easy to overlook, lets print the whole file in its entirety, with no omissions
- You don't need to echo everything back. The details of your analysis do not need to be shown every time. Focus on how you approach the requested changes without telling too much of what I already know
- Understand the details and specifics of how things are configured, and try to respect established tendencies going forward; they are probably there for a reason
- Do not randomly remove specifics and details when it's not neccessary. Try to preserve details of how things are configured. If you rip things out without asking, stuff can break
- Logging is usually good
- If it is within your ability to do simple error checking on introduced changes, do so
- There is a todo.org file. You don't need to ask me too often about what I want the next step to be, but the file is there to give an idea about what is coming next. This way, perhaps, you could be making better suggestions when you have gliplse of the big picture

### Some details regarding how I want QtQuick/QML stuff to work

- Almost always prefer to specify sizes in ratio instead of fixed pixel values
- In general, widgets should try to make use of most of the space available to them
- It is good to reuse existing widgets, when they are available. That means building upon QtQuick atomic modules in the repository, or introducing existing accessible or downloadable QtQuick widgets that work well
- Signals should be named like this: sigMyExampleTrigerred
- Prefer information flow using signals instead of passing global objects