# ElPlatform
<p align="center">
<img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/ac2dfb16-d286-46e9-980a-d7ba6b4dce60" alt="drawing" width="400"/>
</p>
In this project, we are implementing a social media platform for the GUC community. The name "ElPlatform" references the platform area on the campus which is an area that involves lots of social activities, similar to our application. The main features of that app are the following:

- News feed, where authorized users can post announcements or news, while all the other users can interact like these posts or leave comments on them.
- Confessions, where users can post anything while having the option to hide or show their identity.
- Academic Q&A, which includes discussion forums for every faculty.
- Lost & Found, where users can post their lost items to find them or post the items they found to return them to their owners.
- Ratings & Reviews, where users can search for courses or instructors, review them, and read other people’s reviews about them.
- Offices & Outlets, where users can search for specific locations on the campus and the application will help them navigate their way to these locations.
- Important phone numbers, like the clinic, the hotline, etc. Users can call these numbers with one click on the app.

In addition to these features, there are features related to the administrators of the app, who can:
- Add courses or instructors.
- Approve or disapprove publish requests from users to allow them to post in the feed.
- Add phone numbers to the list of important phone numbers.
In the next sections, we will discuss the details of every component of the app, and how
it was implemented.

## Database
In this app, we used Firebase Cloud Firestore to host our database.

## UI/UX

### News Feed
<div align= "center">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/51d617b1-316c-40ce-a753-d6f9ac5de83c" alt="Image 1" width="200">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/cf759010-c236-491e-b3ca-0682eea7d93c" alt="Image 2" width="200">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/9304c18e-d2c3-4f81-adf8-472a4cfcd4ea" alt="Image 3" width="200">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/bd2fbdf9-6580-49d4-a93a-d20e732c107f" alt="Image 4" width="200">
</div>

After the user signs in, they will be redirected to the home page, which displays the news feed. The news feed contains announcements and news posted by users who are allowed by admins to publish. If a non-publisher tries to post in the feed, a dialog opens telling them that they need to send a request to be publishers. The admin will review the request and the user will receive a notification when the request is approved or rejected. After the request is accepted, the user can publish posts on the news feed. Any user (publisher or not) can like or add comments to any post, and the owner of the post will be notified about it. In the home page, there is a drawer where the user can access some other pages like:
- GUC contacts
- Navigation
- Courses
- Instructors
- My profile
In addition, the user can navigate to some other pages using the bottom navigation bar like Confessions, Q&A, Lost & Found, and Notifications. The news feed is implemented using the StreamBuilder widget, so if a new post is added while scrolling, a toast will appear to the user telling them that new posts are available. The same thing is available in confessions, Q&A, and Lost & Founds.

### Confessions
<div align= "center">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/b657e0d3-3f37-4f61-aded-148e4bd19e5e" alt="Image 1" width="200">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/7a92b9a1-2962-4821-97e8-90a75bbb6e8b" alt="Image 2" width="200">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/bc60340a-23db-42ed-a7af-fe7fae7bde4a" alt="Image 3" width="200">
</div>
The confessions page is very similar to the news feed. The only difference is that all users can post confessions without the need to request permissions and users can choose to post anonymously.

### Q&A
<div align= "center">
  <img src="https://github.com/mokhallid80/guc-swiss-knife/assets/68449722/1f9f5d82-612b-4251-b70b-2c9ca93c0450" alt="Image 1" width="200">
</div>
On the Questions and Answers page, users can ask academic questions and receive answers to them. Questions can be categorized by faculty to make it easier for the users to filter questions. If the user who asked the question received an answer to their question, they can mark their question as ’Answered’. This makes it easier to filter unanswered questions to make it easier for other users who are asking the same question to find the answer.


