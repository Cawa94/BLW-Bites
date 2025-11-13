
<img width="1920" height="1080" alt="Untitled design" src="https://github.com/user-attachments/assets/3bca575c-c4f6-4521-a6a8-a9987f7472b6" />

# BLW Bites

**BLW Bites** is a production-ready iOS app that helps parents introduce solid foods to their babies using the Baby Led Weaning (BLW) method.  
The app provides a curated food database, safe preparation guidelines, family-friendly recipes, and subscription-based access to premium content.

---

## 👨‍💻 My Role

I designed and developed the entire iOS application end-to-end, including:

- Application architecture (UIKit + MVC / MVVM hybrid)
- All UI implementation and custom components
- Local and remote data models
- Firebase integration (Auth, Firestore, Storage, Analytics, Crashlytics, App Check)
- RevenueCat subscription and paywall system
- App Tracking Transparency flow and analytics gating
- Custom image viewer with zoom & fullscreen support
- Vimeo video extraction and playback integration
- Internationalization & localization
- Build setup, dependency management, and release pipeline

Additionally, I **coordinated and mentored a junior Android developer** to recreate the same application for Android.  
I provided architectural guidance, code reviews, and UI/UX supervision to ensure a faithful cross-platform implementation and full feature parity between platforms.

---

## 🧰 Tech Stack

### **Mobile**
- **iOS (native)**
- **Swift**
- **UIKit**
- **CocoaPods**
- **iOS 16+ target**

### **Backend & Services**
- **Firebase**
  - Authentication  
  - Firestore  
  - Storage  
  - App Check  
  - Crashlytics  
  - Analytics (only after ATT consent)  
- **RevenueCat** (subscriptions & entitlements)

### **Media & UI**
- Vimeo video extractor  
- Custom full-screen image viewer (zoom, pinch, scroll)
- High-resolution image loading + caching  
- Real-time filtering UI

### **Architecture**
- UIKit navigation structure  
- MVC with lightweight MVVM  
- Clean separation between models, services, and UI layers  
- Firebase-powered dynamic content  

---

## ✨ Features

- **80+ safe-to-offer foods**
- **100+ BLW-friendly recipes**
- **Meal plans (First 30 Days + 7–12 Months Seasonal)**
- **Favorites, filtering, discovery**
- **Subscription paywall**
- **Telegram support channel**
- **Multi-language support**

---

## 🧩 Key Technical Challenges I Solved

### **1. Scalable data model for complex food structures**
Foods contain multiple age segments, safety warnings, preparation styles, and metadata.

### **2. Custom full-screen image viewer**
Built from scratch with pinch-to-zoom, double-tap, and high-resolution photos.

### **3. ATT-compliant Firebase Analytics**
Dynamic enabling of analytics only after user permission.

### **4. Firebase + RevenueCat integration**
Secure handling of Pro entitlements, subscription restore, and gated content.

### **5. Vimeo video extraction**
Automatic retrieval of playable video URLs and smooth playback.

### **6. Efficient media loading**
Async image loading, caching, and memory-safe scrolling.

### **7. Maintainable UIKit structure**
Avoiding Massive View Controllers with a clean separation of concerns.

### **8. Full localization**
Multiple languages + dynamic text sizing.

### **9. Subscription UX**
Custom paywall, free trial onboarding, entitlement refresh, and failure handling.

### **10. End-to-end production delivery**
Architecture → implementation → backend → analytics → compliance → release.

---

## 🔗 Contact

Yuri Cavallin — Senior iOS Developer

Email: [yuricavallin.developer@gmail.com]

LinkedIn: [https://www.linkedin.com/in/yuri-cavallin/]

---

## 📱 App Preview

![1113-video-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/ad8521cb-a503-40e6-bcdb-bbaa450cc46e)
