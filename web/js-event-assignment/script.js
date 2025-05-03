// Space Explorer - Interactive JavaScript
// This file contains all event handling, interactive elements, and form validation

// Wait for DOM to fully load before running
document.addEventListener("DOMContentLoaded", function () {
  // =============================
  // 1. EVENT HANDLING SECTION
  // =============================

  // Button click event
  const launchBtn = document.getElementById("launch-btn");
  const eventOutput = document.getElementById("event-output");

  launchBtn.addEventListener("click", function () {
    // Change button appearance temporarily
    this.textContent = "🔥 Launching...";
    this.style.backgroundColor = "#ff4757";

    // Update output with random status messages
    const messages = [
      "Rocket engines ignited! Preparing for liftoff...",
      "T-minus 3... 2... 1... We have liftoff!",
      "Houston, we're on our way to the stars!",
      "Launch successful! Escape velocity reached.",
      "All systems nominal. Course set for deep space.",
    ];

    const randomMessage = messages[Math.floor(Math.random() * messages.length)];
    eventOutput.innerHTML = `<p class="success">Mission status: ${randomMessage}</p>`;

    // Reset button after delay
    setTimeout(() => {
      this.textContent = "Launch Rocket 🚀";
      this.style.backgroundColor = "";
    }, 2000);
  });

  // Hover effects
  const hoverArea = document.getElementById("hover-area");

  hoverArea.addEventListener("mouseenter", function () {
    this.innerHTML = "<p>Scanning in progress... 🔍</p>";
    eventOutput.innerHTML = "<p>Mission status: Planet scan initiated...</p>";
  });

  hoverArea.addEventListener("mouseleave", function () {
    this.innerHTML = "<p>Hover to scan planet</p>";
    eventOutput.innerHTML =
      "<p>Mission status: Planet scan complete. Data stored.</p>";
  });

  // Keypress detection
  const keyDetector = document.getElementById("key-detector");
  const keyDisplay = document.getElementById("key-display");

  keyDetector.addEventListener("keydown", function (event) {
    // Display the key pressed
    keyDisplay.textContent = event.key;

    // Update output display
    eventOutput.innerHTML = `<p>Mission status: Key "${event.key}" detected in command sequence.</p>`;

    // Easter egg for arrow keys
    if (event.key === "ArrowUp") {
      eventOutput.innerHTML =
        '<p class="success">Mission status: Spacecraft altitude increasing! ↑</p>';
    } else if (event.key === "ArrowDown") {
      eventOutput.innerHTML =
        '<p class="success">Mission status: Spacecraft descending! ↓</p>';
    } else if (event.key === "ArrowLeft") {
      eventOutput.innerHTML =
        '<p class="success">Mission status: Spacecraft turning left! ←</p>';
    } else if (event.key === "ArrowRight") {
      eventOutput.innerHTML =
        '<p class="success">Mission status: Spacecraft turning right! →</p>';
    }

    // Prevent default actions for some keys
    if (["ArrowUp", "ArrowDown", "Space"].includes(event.key)) {
      event.preventDefault();
    }
  });

  // Double-click secret (bonus)
  const secretZone = document.getElementById("secret-zone");

  secretZone.addEventListener("dblclick", function () {
    // Create an animated secret message
    this.innerHTML = '<p class="success">🌌 SECRET UNLOCKED 🌌</p>';
    eventOutput.innerHTML =
      '<p class="success">Mission status: CLASSIFIED INFORMATION ACCESSED - The truth is out there!</p>';

    // Apply secret animation
    this.style.animation = "fadeIn 1s infinite alternate";
    this.style.backgroundColor = "#5d5dff";

    // Reset after a few seconds
    setTimeout(() => {
      this.innerHTML = "<p>Double-click for secret message</p>";
      this.style.animation = "";
      this.style.backgroundColor = "";
      eventOutput.innerHTML =
        "<p>Mission status: Secret data erased from memory...</p>";
    }, 3000);
  });

  // Keyboard event for the whole document - Escape key emergency protocol
  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      eventOutput.innerHTML =
        '<p class="error">⚠️ EMERGENCY PROTOCOL ACTIVATED ⚠️</p>';

      // Flash the screen red briefly to indicate emergency
      document.body.style.backgroundColor = "#ff4757";
      setTimeout(() => {
        document.body.style.backgroundColor = "";
        eventOutput.innerHTML =
          "<p>Mission status: Emergency protocol disengaged. Systems normal.</p>";
      }, 1000);
    }
  });

  // =============================
  // 2. INTERACTIVE ELEMENTS
  // =============================

  // Tabs system
  const tabButtons = document.querySelectorAll(".tab-btn");
  const tabContents = document.querySelectorAll(".tab-content");

  tabButtons.forEach((button) => {
    button.addEventListener("click", function () {
      // Remove active class from all tabs
      tabButtons.forEach((btn) => btn.classList.remove("active"));
      tabContents.forEach((content) => content.classList.remove("active"));

      // Add active class to clicked tab and corresponding content
      this.classList.add("active");
      const tabId = this.getAttribute("data-tab");
      document.getElementById(tabId).classList.add("active");
    });
  });

  // Image gallery/slideshow
  const prevBtn = document.getElementById("prev-btn");
  const nextBtn = document.getElementById("next-btn");
  const galleryItems = document.querySelectorAll(".gallery-item");
  const dots = document.querySelectorAll(".dot");
  let currentIndex = 0;

  // Function to update gallery display
  function showGalleryItem(index) {
    // Hide all items
    galleryItems.forEach((item) => item.classList.remove("active"));
    dots.forEach((dot) => dot.classList.remove("active"));

    // Show the selected item
    galleryItems[index].classList.add("active");
    dots[index].classList.add("active");
    currentIndex = index;
  }

  // Event listeners for gallery navigation
  prevBtn.addEventListener("click", function () {
    let newIndex = currentIndex - 1;
    if (newIndex < 0) newIndex = galleryItems.length - 1;
    showGalleryItem(newIndex);
  });

  nextBtn.addEventListener("click", function () {
    let newIndex = currentIndex + 1;
    if (newIndex >= galleryItems.length) newIndex = 0;
    showGalleryItem(newIndex);
  });

  // Dots navigation
  dots.forEach((dot) => {
    dot.addEventListener("click", function () {
      const index = parseInt(this.getAttribute("data-index"));
      showGalleryItem(index);
    });
  });

  // Accordion functionality
  const accordionHeaders = document.querySelectorAll(".accordion-header");

  accordionHeaders.forEach((header) => {
    header.addEventListener("click", function () {
      const accordionItem = this.parentElement;
      const isActive = accordionItem.classList.contains("active");

      // Close all accordion items first
      document.querySelectorAll(".accordion-item").forEach((item) => {
        item.classList.remove("active");
        const icon = item.querySelector(".accordion-icon");
        icon.textContent = "+";
      });

      // Toggle the clicked item if it wasn't already active
      if (!isActive) {
        accordionItem.classList.add("active");
        const icon = accordionItem.querySelector(".accordion-icon");
        icon.textContent = "×";
      }
    });
  });

  // Color change button functionality
  const colorBtn = document.getElementById("color-btn");
  const colorDisplay = document.getElementById("color-display");

  colorBtn.addEventListener("click", function () {
    // Toggle active class for animation
    if (colorDisplay.classList.contains("active")) {
      colorDisplay.classList.remove("active");
      colorDisplay.innerHTML = "<span>?</span>";
      colorBtn.textContent = "Decode Signal";
    } else {
      colorDisplay.classList.add("active");

      // Generate a random "alien message"
      const alienMessages = [
        "👽",
        "",
        "🌌",
        "🚀",
        "💫",
        "👾",
        "⭐",
        "🔭",
        "🌠",
        "✨",
        "🌍",
        "🪐",
      ];
      const randomMessage =
        alienMessages[Math.floor(Math.random() * alienMessages.length)];
      colorDisplay.innerHTML = `<span>${randomMessage}</span>`;
      colorBtn.textContent = "Reset Decoder";

      // Add a special animation
      colorDisplay.style.animation = "rotate 2s linear";
      setTimeout(() => {
        colorDisplay.style.animation = "";
      }, 2000);
    }
  });

  // =============================
  // 3. FORM VALIDATION
  // =============================

  const spaceForm = document.getElementById("space-form");
  const nameInput = document.getElementById("name");
  const emailInput = document.getElementById("email");
  const passwordInput = document.getElementById("password");
  const formResult = document.getElementById("form-result");

  // Name validation - real-time
  nameInput.addEventListener("input", function () {
    const nameValidation = document.getElementById("name-validation");

    if (this.value.trim() === "") {
      nameValidation.textContent = "Explorer name is required";
      nameValidation.className = "validation-message error";
    } else if (this.value.trim().length < 3) {
      nameValidation.textContent = "Name must be at least 3 characters";
      nameValidation.className = "validation-message error";
    } else {
      nameValidation.textContent = "✓ Valid name";
      nameValidation.className = "validation-message success";
    }
  });

  // Email validation - real-time
  emailInput.addEventListener("input", function () {
    const emailValidation = document.getElementById("email-validation");
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (this.value.trim() === "") {
      emailValidation.textContent = "Email is required";
      emailValidation.className = "validation-message error";
    } else if (!emailRegex.test(this.value)) {
      emailValidation.textContent = "Please enter a valid email address";
      emailValidation.className = "validation-message error";
    } else {
      emailValidation.textContent = "✓ Valid email";
      emailValidation.className = "validation-message success";
    }
  });

  // Password validation - real-time
  passwordInput.addEventListener("input", function () {
    const passwordValidation = document.getElementById("password-validation");
    const password = this.value;

    if (password === "") {
      passwordValidation.textContent = "Password is required";
      passwordValidation.className = "validation-message error";
      return;
    }

    let feedback = [];

    // Check password length
    if (password.length < 8) {
      feedback.push("at least 8 characters");
    }

    // Check for uppercase
    if (!/[A-Z]/.test(password)) {
      feedback.push("one uppercase letter");
    }

    // Check for numbers
    if (!/\d/.test(password)) {
      feedback.push("one number");
    }

    // Check for special character
    if (!/[^A-Za-z0-9]/.test(password)) {
      feedback.push("one special character");
    }

    if (feedback.length > 0) {
      passwordValidation.textContent =
        "Password must contain: " + feedback.join(", ");
      passwordValidation.className = "validation-message error";
    } else {
      passwordValidation.textContent = "✓ Strong password";
      passwordValidation.className = "validation-message success";
    }
  });

  // Form submission
  spaceForm.addEventListener("submit", function (event) {
    event.preventDefault();

    // Check if all required fields are valid
    let isValid = true;

    // Name validation
    if (nameInput.value.trim() === "" || nameInput.value.trim().length < 3) {
      isValid = false;
      document.getElementById("name-validation").textContent =
        "Please enter a valid name (at least 3 characters)";
      document.getElementById("name-validation").className =
        "validation-message error";
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(emailInput.value)) {
      isValid = false;
      document.getElementById("email-validation").textContent =
        "Please enter a valid email address";
      document.getElementById("email-validation").className =
        "validation-message error";
    }

    // Password validation
    const password = passwordInput.value;
    if (
      password.length < 8 ||
      !/[A-Z]/.test(password) ||
      !/\d/.test(password) ||
      !/[^A-Za-z0-9]/.test(password)
    ) {
      isValid = false;
      document.getElementById("password-validation").textContent =
        "Please enter a valid password (at least 8 characters, one uppercase, one number, one special character)";
      document.getElementById("password-validation").className =
        "validation-message error";
    }

    if (isValid) {
      // Form is valid, show success message
      formResult.textContent =
        "🎉 Application submitted successfully! Welcome to the Space Program, " +
        nameInput.value +
        "!";
      formResult.className = "result-display success";

      // Optional: Reset form after submission
      spaceForm.reset();

      // Clear validation messages
      document.querySelectorAll(".validation-message").forEach((msg) => {
        msg.textContent = "";
        msg.className = "validation-message";
      });

      // Show an animation effect for success
      formResult.style.animation = "fadeIn 0.5s ease";

      // Scroll to result message
      formResult.scrollIntoView({ behavior: "smooth", block: "nearest" });
    } else {
      // Form is invalid, show error message
      formResult.textContent =
        "❌ Please fix the errors in the form before submitting.";
      formResult.className = "result-display error";
    }
  });

  // Initialize interactive elements
  // Open first accordion item by default
  document.querySelector(".accordion-item").classList.add("active");
  document.querySelector(".accordion-icon").textContent = "×";
});
