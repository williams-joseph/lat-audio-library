/**
 * Simple Loading Manager with PWA Install Support
 * Shows loading screen for 3 seconds or until Flutter is ready
 */

class LoadingManager {
  constructor() {
    this.appLoaded = false;
    this.minDisplayTime = 3000; // 3 seconds
    this.startTime = Date.now();
    this.deferredPrompt = null;
    
    this.init();
  }

  init() {
    this.setupEventListeners();
    this.setupFallbackTimeout();
    this.setupPWAInstall();
  }

  setupEventListeners() {
    // Listen for Flutter app readiness
    window.addEventListener('flutter-first-frame', () => {
      console.log('Flutter first frame detected');
      this.handleFlutterReady();
    });
    
    // Global error handling
    window.addEventListener('error', (e) => this.handleGlobalError(e));
  }

  setupPWAInstall() {
    // PWA Install Prompt Handling
    window.addEventListener('beforeinstallprompt', (e) => {
      console.log('PWA install prompt available');
      // Prevent the mini-infobar from appearing on mobile
      e.preventDefault();
      // Stash the event so it can be triggered later
      this.deferredPrompt = e;
      
      // Make the event available to Flutter
      window.pwaInstallAvailable = true;
    });

    // Listen for app installed event
    window.addEventListener('appinstalled', () => {
      console.log('PWA was installed');
      this.deferredPrompt = null;
      window.pwaInstallAvailable = false;
    });

    // Global function for Flutter to call
    window.showPWAInstallPrompt = () => {
      return this.showInstallPrompt();
    };
  }

  async showInstallPrompt() {
    if (!this.deferredPrompt) {
      console.log('No PWA install prompt available');
      return 'not_available';
    }
    
    console.log('Showing PWA install prompt');
    
    // Show the install prompt
    this.deferredPrompt.prompt();
    
    // Wait for the user to respond to the prompt
    const choiceResult = await this.deferredPrompt.userChoice;
    
    if (choiceResult.outcome === 'accepted') {
      console.log('User accepted the PWA install');
      this.deferredPrompt = null;
      window.pwaInstallAvailable = false;
      return 'accepted';
    } else {
      console.log('User dismissed the PWA install');
      return 'dismissed';
    }
  }

  handleFlutterReady() {
    const loadTime = Date.now() - this.startTime;
    const timeLeft = this.minDisplayTime - loadTime;
    
    if (timeLeft > 0) {
      // Wait remaining time to meet minimum display
      setTimeout(() => this.hideLoadingScreen(), timeLeft);
    } else {
      // Hide immediately if minimum time elapsed
      this.hideLoadingScreen();
    }
    
    this.appLoaded = true;
  }

  hideLoadingScreen() {
    const loadingElement = document.getElementById('loading');
    const flutterAppElement = document.querySelector('.flutter-app');
    
    if (loadingElement) {
      loadingElement.style.display = 'none';
    }
    
    if (flutterAppElement) {
      flutterAppElement.style.display = 'block';
    }
    
    console.log('Loading screen hidden, Flutter app displayed');
  }

  setupFallbackTimeout() {
    setTimeout(() => {
      if (!this.appLoaded) {
        console.log('Fallback timeout - hiding loading screen');
        this.hideLoadingScreen();
      }
    }, this.minDisplayTime + 2000); // 5 seconds total (3min + 2s buffer)
  }

  handleGlobalError(event) {
    console.error('Global error:', event.error);
  }
}

// Initialize loading manager when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  window.loadingManager = new LoadingManager();
});