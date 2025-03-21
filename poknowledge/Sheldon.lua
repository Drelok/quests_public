function event_say(e)
    if(e.message:findi("hail")) then
        e.self:Say("Greetings, hero! Grand Librarian Maelin has tasked me to assist adventurers with a way to hastily reach him. Please let me know if you would like to be [" .. eq.say_link("translocated") .. "] up to him.")
    elseif(e.message:findi("translocate")) then
        e.other:MovePC(Zone.poknowledge, 908.10, 19, 389.13, 129);
    end
end