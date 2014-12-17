# Epoch

A web app for viewing and sharing timelines.

This was originally a senior class project for @pk-nb, @isaachermens, and @Jwashton. The official version is hosted at [epoch.tools](http://epoch.tools). Feel free to give it a try!

This project is currently no longer under active development. It's a largely a functional proof of concept and may be extended in future.

![screenshots](https://cloud.githubusercontent.com/assets/1911028/5472283/f86400f6-85cc-11e4-9166-f354037f2fef.png)

This project was intended to effectively visualize the immense amount of data that timelines can contain and make it consumable even on small screens.

Major features:

* Viewing and creating timelines and events
* Importing timelines from Twitter and Github
* Works as full-screen web app on iOS and Android

If you would like to see the presentation slides on the project, they are [available here](http://beisiegel.me/files/EpochPresentation.pdf).

## Project Structure

This webapp uses a Rails back end and React.js/HTML5 Canvas for the front end. The Rails app should be fairly [standard](http://guides.rubyonrails.org/getting_started.html#creating-the-blog-application) as far as where things are located. The client side code is all located in [app/assets/javascripts/ui-components](app/assets/javascripts/ui-components).

The front-end UI is organized into a tree of components, each keeping state at the appropriate level and passing down props down the tree. As illustrated in the following image, a top level app component holds the primary state (such as the current user and the timelines).

![epochtree](https://cloud.githubusercontent.com/assets/1911028/5472076/8bcd6fd8-85ca-11e4-8a59-6c2940ddb7ab.png)

The components are named according to their UI, shown in the following screenshots:

![uiandtimelineview](https://cloud.githubusercontent.com/assets/1911028/5472316/6b13d982-85cd-11e4-89e3-50c8ded31e98.png)


![shelfandpanel](https://cloud.githubusercontent.com/assets/1911028/5472317/70d6bf42-85cd-11e4-82fe-ce9b3569d89b.png)


This project uses the [react-rails 1.x gem](https://github.com/reactjs/react-rails) to pre-render the application server side.

## Thanks

Many thanks to Prof. Robert Ordóñez and Michael Dant from the [Southern Computing department](http://www1.southern.edu/academics/computing.html) for overseeing the project and acting as product owners.

Primary contributors:

* Nathanael Beisiegel [(personal site)](http://beisiegel.me)
* Isaac Hermens
* William Ashton
