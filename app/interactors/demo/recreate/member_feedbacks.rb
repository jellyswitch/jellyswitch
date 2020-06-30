class Demo::Recreate::MemberFeedbacks
  include Interactor
  include RandomTimestamps

  delegate :operator, to: :context

  def call
    puts "Creating member feedbacks... (#{operator.users.count})"
    operator.users.each do |user|
      MemberFeedback::Create.call(
        member_feedback_params: {
          anonymous: [true, false].sample,
          comment: comments.sample,
          user_id: user.id,
          operator_id: operator.id,
          created_at: temp_day,
          updated_at: temp_day
        },
        operator: operator,
        user: user
      )
    end
    puts "done."
  end

  private

  def comments
    [ "I don’t know how to use the hand dryers!",
      "Free croissants and coffee daily",
      "New app is working great for me. Nice work! 👍🏼",
      "This is a great place to work!",
      "Loud talkers in the hallways! Always on the phone and talking loud",
      "Looks good. Much better than Proximity. ",
      "I love seeing tech folks in the building! The place feels energetic recently.",
      "Loud talkers in common areas :(",
      "Men’s room needs a plunger",
      "Watched through my window as some guys pulled a handicap sign out of the ground and throw it. They’re drunk. Have photo and video to back it up. ",
      "None of the printers work.\nOut of toner. \nWhere is the replacement toner located. ",
      "I’m having trouble pushing to GitHub. WiFi problem? It’s stuck at 21 kbps.",
      "You should put an encouraging sign that also says where the beer and coffee is from. Also maybe the last refilled or next anticipated refill date.",
      "Bulbs need to be replaced in my office and mens restroom",
      "Just about to run out of TP in both restrooms. \nMy employee brought some from home.\nDo we have anyone checking this on a regular basis?",
      "We will be out of print paper today. ",
      "Idea: I would pay additional rent if it meant janitorial services to vacuum and empty trash once a week. Have tried vacuum here and it doesn't clean very well.",
      "Trying to figure out how to adjust the height on the standing desk at the very front. Also, are there spare power strips hanging out somewhere? Cheers.",
      "Just a note: I have a VC phone screen to conduct from 1:45 -2:30 and a meeting to attend from 3:00 - 3:30.  The current room reservation system requires me to tie up the room from 1:00 - 4:00 to do those, and adds the risk that I'll have to kick someone out at 1:45 because the room appears unused for the first 45 minutes.   Seems less than ideal.",
      "Men’s Restroom needs more hand soap and glade air freshener. Paper towels need to be inserted in holder. Thank you. :)",
      "Nitro coffee is out",
      "West wing door is mechanically locked / stuck shut? Just tried to enter.",
      "Could there maybe be some sort of signage about the front room being a quiet space? I think people don't know. Loud conversations and video chats almost all day. Can barely get anything done.",
      "I'd just ask everyone to be more considerate but I'd have to ask half a dozen people. Really seems like they just have no idea at all that this is a quiet space. Like I said, having access to work all day in a designated quiet space was my absolute #1 requirement.",
      "Men’s Bathroom Hand Towels Refill\nGlad Airwick replaced\nExhaust Fan Repaired\nThank you :)",
      "That new signage at the back entrance will be nice but oh my god, I can’t think with the drilling sound and vibrations all the way in my office. Please avoid heinous noise during work hours, which absolutely includes lunchtime.",
      "I don’t know how to turn the tv off. Someone left it on in the lobby. Dave P to the rescue. ",
      "Thank you for catching the OnTrac delivery guy this evening for me!",
      "God bless whoever made coffee this morning",
      "Bathrooms clogged.  Test!",
      "Ideas: move the bike rack so they are in view of a camera. Would it be possible to have a communal bike lock (similar to the dumpster)? I’d be willing to chip in.",
      "I am sitting in the area in middle of room with several desks. Some have monitors. How do I know which spaces are “open”?",
      "I left my laptop charger at brew and brew and they aren’t answering their phone 😰",
      "Alhambra Water Out",
      "I love the music today!",
      "So the men’s bathroom needs a urinal clean",
      "Great music today!",
      "I'd like to bring my dog in tomorrow for you to meet to make sure she passes the sniff test :) She is almost 9 months old and well behaved, and I will have her leashed and will bring a bed. I plan to get in around 8:15 - 8:30 tomorrow if that works for you. Please let me know if there are any other considerations for me bringing her into the office. Thanks!",
      "On second thought I will bring my dog Thursday -\nToo many meetings today :) let me know if email is better but I figured I’d test the app. Thanks!",
      "The music is awesome today!",
      "It would be really sweet if there were names on the rooms. I was in the small conference room thinking it was the phone booth :)",
      "Marijuana or smoke like smell coming from North East stairwell, reported to main lobby. Smell was coming into the office.",
      "Shea butter! Fancy!",
      "Men’s bathroom hand soap and paper towels. :)",
      "Can you please post rules somewhere visible? Folks have been taking phone calls in the back public room and I think it’s against the rules but not sure. ",
      "Is there any way that we could change rules about eating in the focus zone? I find it is very hard to work there, as the guy next to me has piles of dirty dishes. He is always scraping them for food, or chewing loudly. I am not sure I can come here to work at our designated desk if this is an all day thing. "]
  end
end