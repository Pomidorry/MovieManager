# Salesforce Bootcamp tasks review
Here I'll write brief report about completed tasks with screenshots from my org every week to simplify my project repo review.

## First Week

### Data model
> **Script object fields and relationships**
![alt text](<tasks-screenshots/ScriptFields.png>)

> **Contact object fields and relationships**
![alt text](tasks-screenshots/ContactFields.png)

> **Account object fields and relationships**
![alt text](tasks-screenshots/AccountFields.png)

> **Movie object fields and relationships**<br></br>
![alt text](tasks-screenshots/MovieFields.png)

> **Cast object fields and relationships**<br></br>
![alt text](tasks-screenshots/CastFields.png)

> **Movie Roll-up fields (Estimated Actor Costs & Actual Actors Costs)**
![alt text](tasks-screenshots/EstimatedActorsCosts.png)
![alt text](tasks-screenshots/ActualActorsCosts.png)

### Permission task
> **Permission Set Group for Edit**
![alt text](tasks-screenshots/EditGroup.png)

> **Permission Set Group for View**
![alt text](tasks-screenshots/ViewGroup.png)

> **Community User with its Permission Set Group Assignment**
![alt text](tasks-screenshots/CommunityUser.png)
![alt text](tasks-screenshots/PermissionSetGroupAssignment.png)

### Declarative Customisation

#### Lists View

> **Account List View**
![alt text](tasks-screenshots/AccountListView.png)

> **Script List View**<br>
> _Recently_
> ![alt text](tasks-screenshots/ScriptListViewRec.png)
> _All_
> ![alt text](tasks-screenshots/ScriptListViewAll.png)

> **Movie List View**<br>
> _Recently_
> ![alt text](tasks-screenshots/MovieListViewRec.png)
> _All_
> ![alt text](tasks-screenshots/MovieListViewAll.png)

> **Cast List View**<br>
> _Recently_
> ![alt text](tasks-screenshots/CastListViewRec.png)
> _All_
> ![alt text](tasks-screenshots/CastListViewAll.png)

#### Recod pages
##### Account
> **Full page including** _Details Tab_
> ![alt text](tasks-screenshots/AccountRecordPage.png)
> _Related Tab_
> ![alt text](tasks-screenshots/AccountRelated.png)
> _Conversation Tab_
> ![alt text](tasks-screenshots/AccountConversation.png)

##### Contact
>**Full page including** _Details Tab_
> ![alt text](tasks-screenshots/ContactDetails.png)
> _Movies Tab_
> ![alt text](tasks-screenshots/ContactMovies.png)

##### Cast
>**Full page including** _Details Tab_
> ![alt text](tasks-screenshots/CastRecordPage.png)

##### Script
>**Full page including** _Details Tab_
> ![alt text](tasks-screenshots/ScriptDetails.png)
> _Related Tab_
>  ![alt text](tasks-screenshots/ScriptRelated.png)

##### Movie
>**Full page including** _Details Tab_
> ![alt text](tasks-screenshots/MovieDetails.png)

> _Actors Tab_ <br>
> ![alt text](tasks-screenshots/MovieActorsTab.png)

> _Poster Tab_ <br>
> ![alt text](tasks-screenshots/MoviePoster.png)

> _Chatter Tab_ <br>
> ![alt text](tasks-screenshots/MovieChatter.png)

> _Activity Tab_ <br>
> ![alt text](tasks-screenshots/MovieActivity.png)

### Flows
> **Refactored Movie Cast Preparation flow**
<br>![alt text](tasks-screenshots/MainFlow.png)</br>

> **Activated Flow**<br>
> _Start Screen if not enough actors_
> ![alt text](tasks-screenshots/FlowActivatedNotEnough.png)<br>
> _Start Screen if not enough actors_
> ![alt text](tasks-screenshots/FlowEnoughActors.png)<br>
> _Pick from available actors with appropraite skills_
>![alt text](tasks-screenshots/FlowPickActors.png)<br>
> _Enter Character name for each selected actor_
> ![alt text](tasks-screenshots/FlowCharacterName.png)<br>

## Second Week

### Apex classes
> Trigger (in combination with trigger handler) allow us to retrive movie deta<br>
> ![alt text](tasks-screenshots/RecordScreenshot.png)
<br></br>

> Batchable Apex class is launched by Scheduable Apex class every business day at 18:00<br>
> ![alt text](tasks-screenshots/ScheduledJob.png)
<br></br>

> It is possible to load records data both with json string and json from static resourse<br>
> ![alt text](tasks-screenshots/StaticRes.png)
<br></br>

> Added global variable to turn on/off trigger<br>
> ![alt text](tasks-screenshots/CustomSettings.png)
<br></br>

### Tests for classes
> Implemented tests for different test scenario (gonna add more) and all tests passed <br>
> ![alt text](tasks-screenshots/TestsPassed.png)
<br></br>

> Test coverage<br>
> ![alt text](tasks-screenshots/TestsCoverage.png)
<br></br>
### LWC

> **Movie List** page. 20 records are shown. But is able to show more<br>
> ![alt text](tasks-screenshots/MovieList.png)
<br></br>

> **Movie Search** page. **ToDo: add styles**<br>
> ![alt text](tasks-screenshots/MovieSearch.png)
<br></br>

> **Movie Loader** page. It is possible to load more than 100 records with poster retrieving<br>
> ![alt text](tasks-screenshots/MovieLoader.png)

## Third Week

### Web application short overview
> **Homepage with movies from Org records**<br>
> ![alt text](gifs/home.gif)

> **Search movies from tmdb integration**<br>
> ![alt text](gifs/search.gif)

> **Movie Uploader**<br>
> ![alt text](tasks-screenshots/Uploader.png)

> **Adding casts automatically with trigger**<br>
> ![alt text](tasks-screenshots/Casts.png)

> **Casts in my org** <br>
> ![alt text](tasks-screenshots/CastsInOrg.png)

> **Trailer**<br>
> ![alt text](tasks-screenshots/Trailer.png)

> **Reviews from TMDB integration**<br>
> ![alt text](tasks-screenshots/Reviews.png)

> **More detailed review reading**<br>
> ![alt text](tasks-screenshots/ReviewModal.png)

> **New Record By Title - Quick Action on Movie record page (only in my org)** <br>
> ![alt text](tasks-screenshots/QuickAction.png)
## Final results 

> You can find my project here: https://wise-raccoon-lb0p6q-dev-ed.trailblaze.my.site.com/MovieManager/s/

> ⚠️ **Please, don't upload files from Experince Cloud Site: to do it, I need to turn on trigger checkbox in Custom Settings in purpose to reduce count of callouts!** 

> Experince Cloud Site credentials<br>
> **Username:** ideaport_user@exp.cloud<br>
> **Password:** i12345678 <br>
(to find smth in search you need to click enter after input)