# Xamarin.Forms Gallery3 client app

We have created a Xamarin.Forms, cross platform (iOS & Android) client browsing app for the Gallery3 web app.  This app allows you to browse the albums and photos you have uploaded to your Gallery3 server.

# 1. To configure your Gallery3 instance

The REST API module needs to be enabled on your Gallery3 instance, and guest access to the REST API needs to be enabled.

To enable the REST API, log in to your Gallery3 instance as admin and select the Admin->Modules option on the menu. Scroll down until you find the entry for "REST API Module" and tick the box. Scroll right down to the bottom of the list and click "Update".

To enable guest access to the REST API, log in to your Gallery3 instance as admin, and select Admin->Settings->Advanced on the menu.  Scroll down to find the "allow_guest_access" setting in the "rest" module.  Click on the setting of "0" and change the value to "1".

# 2. To install the app for Android:

On your Android device, navigate to [Gallery3 Android release](https://install.mobile.azure.com/users/nickward-a029/apps/Gallery3.Android/releases) and follow the links to install the latest version to your device.

# 3. To connect the app to your Gallery3 instance:

Open the app on your Android device.  By default the app will attempt to access my Gallery3 instance at [http://hectagongallerydocker.azurewebsites.net](http://hectagongallerydocker.azurewebsites.net).  You can change this by tapping the button near the bottom of the screen with the URL on it.  This will open the settings page of the app where you can enter your own Gallery3 URL endpoint.
