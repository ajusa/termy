# Termy
A simple library for making better terminal UIs.

## Thoughts
Children
CRUD for each Item
replaceItems and newItems do different things
need a better way to draw/scroll through items
- For example if someone keeps going to the right, need to stop drawing the leftmost items at some point
- this also needs to be much more performant, can't draw everything if we only need to draw the items around the selected item.
Word wrap

For jumping around, try this:
If the jump is to something already on the screen, highlight it
If the jump is to something off screen, have it be top most if we jump up, and bottom most if we jump down
Each item can store what index it is in the parent seq. Then we just need to do index compare to see if we are jumping up or down.
