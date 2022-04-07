<img src="./readme/title1.svg"/>

<div align="center">

> Hello world! This is the project’s summary that describes the project plain and simple, limited to the space available.

**[PROJECT PHILOSOPHY](https://github.com/saadbadreddine/sefactory-fsw-final-project/#-project-philosophy) • [WIREFRAMES](https://github.com/saadbadreddine/sefactory-fsw-final-project#-wireframes) • [TECH STACK](https://github.com/saadbadreddine/sefactory-fsw-final-project#-tech-stack) • [IMPLEMENTATION](https://github.com/saadbadreddine/sefactory-fsw-final-project#-impplementation) • [HOW TO RUN?](https://github.com/saadbadreddine/sefactory-fsw-final-project#-how-to-run)**

</div>

<br><br>

<img src="./readme/title2.svg"/>

> Hustle is a map based LFG app aimed at sports players struggling to find teams or individuals to play with in the areas that they live in.
>
> Hustle app lets you drop a marker on the map with a sport category of your choosing, the desired time the game will be held, and an announcement message. This marker is then broadcasted and shown to all the users of the app, requests can be sent and once accepted users will be redirected to WhatsApp to further plan their game.

### User Stories

- As a user, I want to find 2 basketball players around my area, so that me and my team can have a full court game.
- As a user, Karim wants to find a team of basketball planning a game, so that he can join them.

<br><br>

<img src="./readme/title3.svg"/>

- This design was done on Figma for fine details, using [Figma Material 3 design kit](https://www.figma.com/community/file/1035203688168086460) and [Figma Material theme builder](https://www.figma.com/community/plugin/1034969338659738588/Material-Theme-Builder#:~:text=Dynamic%20color%20is%20an%20algorithmic,scheme%20that's%20accessible%20by%20default.).
- The app follows material guidelines and uses material 3 widgets which were released alongside Android 12.
- The app also uses Android 12 Material You dynamic color feature. A user-generated scheme is derived from a user’s personal wallpaper selection, then Hustle app will reflect color preferences at the individual device level. To learn more about material you please visit: [Material You dynamic color](https://m3.material.io/styles/color/dynamic-color/overview) and [Flutter material.io dynamic color package](https://pub.dev/packages/dynamic_color).

  | Login                                                                                     | Home/Map                                                                                  |
  | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
  | ![](https://drive.google.com/u/1/uc?id=1FW5DzW8rxCH9RSqww0FSdHG5e2VtW9Ql&export=download) | ![](https://drive.google.com/u/1/uc?id=16xAfmlL5PNQ8KP207y_jgyq2aLyzgX4V&export=download) |

| Posts | Requests |
| ----- | -------- |
| ![]() | ![]()    |

<br><br>

<img src="./readme/title4.svg"/>

Here's a brief high-level overview of the tech stack that Hustle app uses:

- This project uses the [Flutter app development framework](https://flutter.dev/). Flutter is a cross-platform hybrid app development platform which allows us to use a single codebase for apps on mobile, desktop, and the web.
- This project uses the [Gin web framework](https://github.com/gin-gonic/gin). Gin is a web framework written in [Golang](https://go.dev/). It features a martini-like API with performance that is up to 40 times faster thanks to httprouter.
- To query and manipulate data from MySQL database, this project uses [GORM](https://gorm.io/). GORM is an ORM library for dealing with relational databases, and is developed on top of database/sql package.
- For RDBMS, this project uses [MySQL](https://www.mysql.com/).
- For backend shipping and deployment, this project uses [Docker](https://www.docker.com/). Docker is a set of platform as a service products that use OS-level virtualization to deliver software in packages called containers.
- For realtime data streams (Requests Screen), this project uses [Firebase Cloud FireStore](https://firebase.google.com/docs/firestore). Cloud Firestore is a flexible, and scalable cloud-hosted NoSQL database for mobile, web, and server development.
- For push notifications, this project uses [Firebase Cloud Messaging](https://firebase.google.com/docs/firestore). Using FCM, you can notify a client app that new email or other data is available to sync. You can send notification messages to drive user re-engagement and retention.
- This project uses [Google Maps for Flutter](https://pub.dev/packages/google_maps_flutter) and [Google Maps Platform](https://mapsplatform.google.com/).

<br><br>
<img src="./readme/title5.svg"/>

> Using the above mentioned tech stacks and the wireframes built with figma from the user sotries we have, the implementation of the app is shown as below, these are screenshots from the real app.

| Login | Home  | Posts | Requests | Profile |
| ----- | ----- | ----- | -------- | ------- |
| ![]() | ![]() | ![]() | ![]()    | ![]()   |

<br><br>
<img src="./readme/title6.svg"/>

> This is an example of how you may give instructions on setting up your project locally.
> To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

- [Setup Flutter in your environment](https://docs.flutter.dev/get-started/install)
- Run the command below in your Flutter directory and install the missing dependencies if there are any (Android SDK)
  ```sh
  flutter doctor
  ```

### Installation

_Below is an example of how you can instruct your audience on installing and setting up your app. This template doesn't rely on any external dependencies or services._

1. Clone the repo
   ```sh
   git clone https://github.com/saadbadreddine/sefactory-fsw-final-project.git
   ```
2. ```sh

   ```

3. ```dart

   ```
