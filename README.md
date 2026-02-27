# News-App
A Flutter-based mobile application that delivers real-time news headlines using the GNews API. The app is designed with a clean UI, robust connectivity handling, and smooth navigation to provide users with a professional-grade news reading experience.

✨ **1. No Internet Page**

🔹 When the device is offline, the app gracefully handles connectivity issues by displaying a custom dialog box.  

🔹 The dialog informs the user about the lack of internet connection and provides two clear options:  
   👉 **Try Again** → rechecks connectivity and reloads the app.  
   👉 **Cancel** → exits the application.  

✅ This ensures a user-friendly fallback experience instead of leaving the user with a blank screen.  


✨ **2. News List Page**

📡 When the internet is available, the app fetches real-time top headlines using the **GNews API**.  

📰 Articles are displayed in a scrollable list, with each item showing the headline and a navigation arrow for easy access.  

🔄 A refresh button is placed at the top-right corner of the AppBar, allowing users to reload the latest news instantly.  

🎯 The design emphasizes simplicity and readability, ensuring users can quickly browse through trending stories.  


✨ **3. Detailed News Page**

📌 On tapping any news item, users are navigated to a dedicated detail page.  

This page includes:  
- 🖼️ A featured image (with graceful fallback if no image is available).  
- 📖 A detailed description of the article.  
- 🔗 A link to the full article, displayed at the bottom with an interactive **"Visit"** option.  

🌐 The external link opens seamlessly using **url_launcher**, giving users direct access to the complete story in-app via WebView.  

📜 The layout is optimized with scrollable content, ensuring smooth readability even for longer articles.  


⚙️ **Packages Used:**  
- `http` → for API requests  
- `url_launcher` → for opening external article links  
- `connectivity_plus` → for real-time internet connectivity checks  

📰 **API:** GNews API for fetching top headlines  
📱 **Architecture:** Built with Flutter, leveraging **FutureBuilder** for async data handling and **Connectivity listeners** for dynamic UI updates

