/**
 * Firebase Configuration
 * Contains all Firebase-related setup and initialization
 */

// Firebase configuration object
const FIREBASE_CONFIG = {
  apiKey: "AIzaSyDkZaHzPGrbkW5Pzy4tT651_Gs2ZSWCCJw",
  authDomain: "sermons-app-d004a.firebaseapp.com",
  projectId: "sermons-app-d004a",
  storageBucket: "sermons-app-d004a.firebasestorage.app",
  messagingSenderId: "104319985691",
  appId: "1:104319985691:web:87844858dca0f6954eb0be"
};

/**
 * Initialize Firebase application
 */
function initializeFirebase() {
  try {
    firebase.initializeApp(FIREBASE_CONFIG);
    console.log('Firebase initialized successfully');
    return true;
  } catch (error) {
    console.error('Firebase initialization error:', error);
    showError('Failed to initialize Firebase: ' + error.message);
    return false;
  }
}

/**
 * Show error message to user
 * @param {string} message - Error message to display
 */
function showError(message) {
  const errorDiv = document.getElementById('error');
  if (errorDiv) {
    errorDiv.style.display = 'block';
    errorDiv.innerHTML = message;
  }
  console.error('Application error:', message);
}

// Initialize Firebase when script loads
document.addEventListener('DOMContentLoaded', function() {
  initializeFirebase();
});