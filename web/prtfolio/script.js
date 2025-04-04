// DOM Elements
const sideNavItems = document.querySelectorAll(".side-nav li");
const sections = document.querySelectorAll(".section");

document.addEventListener("DOMContentLoaded", () => {
  setActiveSection("home");

  // Add event listeners to navigation items
  sideNavItems.forEach((item) => {
    item.addEventListener("click", function (e) {
      e.preventDefault();
      const sectionId = this.getAttribute("data-section");
      setActiveSection(sectionId);
    });
  });

  // Handle hash changes in URL
  window.addEventListener("hashchange", handleHashChange);

  // Check for hash in URL on page load
  if (window.location.hash) {
    const sectionId = window.location.hash.substring(1);
    setActiveSection(sectionId);
  }

  // Handle form submission
  const contactForm = document.querySelector(".contact-form");
  if (contactForm) {
    contactForm.addEventListener("submit", handleFormSubmit);
  }

  // Initialize skill bar animations
  initSkillBars();
});

// Set active section
function setActiveSection(sectionId) {
  // Update navigation
  sideNavItems.forEach((item) => {
    if (item.getAttribute("data-section") === sectionId) {
      item.classList.add("active");
    } else {
      item.classList.remove("active");
    }
  });

  // Update sections
  sections.forEach((section) => {
    if (section.id === sectionId) {
      section.classList.add("active");
    } else {
      section.classList.remove("active");
    }
  });

  // Update URL hash
  window.location.hash = sectionId;

  // Scroll to top of section on mobile
  if (window.innerWidth <= 768) {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  }
}

// Handle URL hash changes
function handleHashChange() {
  const sectionId = window.location.hash.substring(1);
  if (sectionId) {
    setActiveSection(sectionId);
  }
}

// Handle form submission
function handleFormSubmit(e) {
  e.preventDefault();

  // Get form values
  const name = document.getElementById("name").value;
  const email = document.getElementById("email").value;
  const subject = document.getElementById("subject").value;
  const message = document.getElementById("message").value;

  // Simple validation
  if (!name || !email || !message) {
    alert("Please fill all required fields");
    return;
  }

  // In a real application, you would send this data to a server
  console.log("Form submitted:", { name, email, subject, message });

  // Reset form
  e.target.reset();

  // Show success message
  alert("Message sent successfully!");
}

// Initialize skill bar animations
function initSkillBars() {
  const skillBars = document.querySelectorAll(".skill-progress");

  // Initially set all skill bars to 0 width
  skillBars.forEach((bar) => {
    const originalWidth = bar.style.width;
    bar.style.width = "0";

    // Store the target width as a data attribute
    bar.dataset.width = originalWidth;
  });

  // Add intersection observer to animate skills when they come into view
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          // Animate the skill bar to its target width
          const skillBar = entry.target;
          skillBar.style.width = skillBar.dataset.width;
          skillBar.style.transition = "width 1s ease-in-out";

          // Unobserve after animation
          observer.unobserve(skillBar);
        }
      });
    },
    { threshold: 0.5 }
  );

  // Observe all skill bars
  skillBars.forEach((bar) => {
    observer.observe(bar);
  });
}

// Helper function to check if an element is in viewport
function isInViewport(element) {
  const rect = element.getBoundingClientRect();
  return (
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <=
      (window.innerHeight || document.documentElement.clientHeight) &&
    rect.right <= (window.innerWidth || document.documentElement.clientWidth)
  );
}

// Add resize event listener for responsive adjustments
window.addEventListener("resize", () => {
  // Adjust layout based on screen size
  if (window.innerWidth <= 768) {
    // Mobile layout adjustments
    document.querySelector(".side-nav").classList.remove("active");
  }
});
