## Using the rmd files for workshop communication

This folder contains rmd files that are [parameterized reports](https://bookdown.org/yihui/rmarkdown/parameterized-reports.html). That means you can change the parameters at the top and then knit to have the report update with the new information. Parameters include the following:

- contact person (generally the team member sending all these emails)
- contact email (their email)
- workshop date, including start time (duration assumed to be 5h)
- tech check date, including start time (duration assumed to be 30m)
- link to signup
- link to pre course survey
- link to post course survey
- link to course website
- link to server accounts for use during workshop

To generate the text for emails for a new workshop, you should be able to update just the parameters and knit, then copy-paste the resulting html into your email and send. 

**Note:** The text of the post-workshop email will change depending on the conversation that arises during the workshop. Update it as needed based on the chat record from zoom.

There is an R file of functions that get used in the rmd reports (communication_functions.r). 

## Additional tasks

### Check signups and move folks from wait list

After the initial workshop invite goes out, you'll need to keep checking the signup form daily for new people and add them to the invites for the workshop and tech check. If there's a wait list, then as people email to drop their registration, contact people from the wait list to offer them the spot. 

### Recruit TAs

Keep an eye on registrations to see if you recognize folks who have already taken the workshop in the past. If so, reach out to them and ask if they'd like to try TAing instead (see FAQs for workshop TAs in 01_announcement). Also post in the R User Group slack, and contact the Data Ambassadors. 

### Zoom info

In addition, you'll need to set up zoom rooms for the tech check and workshop, and then copy-paste that zoom login information into the calendar invites for each (02_workshop_invite and 03_tech_check_invite, respectively).

### Save chat record during meeting

Before the zoom call for the workshop ends, save the chat record. You'll need this to update the post-workshop email. 

### Attendance record

After the workshop, get a list of attendees who actually showed up:

* Log In to zoom
* Click My account in top right
* On lefthand side bar,  under admin, open Account Management dropdown
* Then, reports. 
* In reports, go to Active hosts. 
* Set date range meeting occurred in. 
* Participants column (may need to scroll over to see) -> click on the link! 
* Export as .csv

You can use this list to update attendance in redcap with attended vs cancelled vs no showed. 
