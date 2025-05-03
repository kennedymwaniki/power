// Product data
const products = {
  chocolate: {
    name: "Chocolate Dream",
    price: 24.99,
    image:
      "https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1089&q=80",
    description:
      "Indulge in layers of rich chocolate sponge cake filled with silky chocolate ganache and covered in a glossy chocolate glaze. A true chocolate lover's delight!",
    ingredients: [
      "Organic flour",
      "Belgian chocolate",
      "Free-range eggs",
      "Unsalted butter",
      "Sugar",
      "Heavy cream",
      "Vanilla extract",
    ],
  },
  velvet: {
    name: "Velvet Romance",
    price: 26.99,
    image:
      "https://images.unsplash.com/photo-1558301211-0d8c8edde3ec?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    description:
      "Our signature red velvet cake features a subtle cocoa flavor with a vibrant red color. Layered and covered with smooth cream cheese frosting for the perfect balance of flavors.",
    ingredients: [
      "Organic flour",
      "Cocoa powder",
      "Buttermilk",
      "Cream cheese",
      "Free-range eggs",
      "Unsalted butter",
      "Red food coloring (natural)",
      "Vanilla extract",
    ],
  },
  tart: {
    name: "Fruit Fantasy",
    price: 18.99,
    image:
      "https://images.unsplash.com/photo-1562440499-64c9a111f713?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1077&q=80",
    description:
      "A delicate pastry crust filled with vanilla custard and topped with an assortment of fresh seasonal fruits. Light, refreshing and beautifully arranged.",
    ingredients: [
      "Organic flour",
      "Free-range eggs",
      "Fresh seasonal fruits",
      "Vanilla beans",
      "Heavy cream",
      "Unsalted butter",
      "Sugar",
    ],
  },
};

// DOM content loaded
document.addEventListener("DOMContentLoaded", function () {
  // Initialize dark mode from local storage preference
  const darkModeSaved = localStorage.getItem("darkMode") === "true";
  if (darkModeSaved) {
    document.body.classList.add("dark-mode");
    updateDarkModeIcons(true);
  }

  // Scroll animations
  window.addEventListener("scroll", function () {
    // Back to top button
    const backToTopBtn = document.getElementById("backToTop");
    if (window.scrollY > 300) {
      backToTopBtn.classList.add("show");
    } else {
      backToTopBtn.classList.remove("show");
    }

    // Navbar shrinking on scroll
    const navbar = document.querySelector(".navbar");
    if (window.scrollY > 50) {
      navbar.style.height = "60px";
    } else {
      navbar.style.height = "70px";
    }
  });

  // Smooth scrolling for anchor links
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault();

      // Close mobile menu if open
      const mobileMenu = document.getElementById("mobileMenu");
      if (mobileMenu.classList.contains("open")) {
        toggleMobileMenu();
      }

      document.querySelector(this.getAttribute("href")).scrollIntoView({
        behavior: "smooth",
      });
    });
  });

  // Form submission
  const contactForm = document.getElementById("contactForm");
  if (contactForm) {
    contactForm.addEventListener("submit", function (e) {
      e.preventDefault();

      // Get form values
      const name = document.getElementById("name").value;
      const email = document.getElementById("email").value;
      const message = document.getElementById("message").value;

      // Simple validation
      if (!name || !email || !message) {
        alert("Please fill in all fields");
        return;
      }

      // In a real application, you would send this data to a server
      console.log("Form submitted:", { name, email, message });

      // Reset form and show success message
      contactForm.reset();
      alert("Thank you for your message! We will get back to you soon.");
    });
  }

  // Back to top button functionality
  const backToTopBtn = document.getElementById("backToTop");
  if (backToTopBtn) {
    backToTopBtn.addEventListener("click", function () {
      window.scrollTo({
        top: 0,
        behavior: "smooth",
      });
    });
  }

  // Modal quantity and price calculation
  const quantityInput = document.getElementById("quantity");
  if (quantityInput) {
    quantityInput.addEventListener("change", updateModalPrice);
  }

  const sizeSelect = document.getElementById("size");
  if (sizeSelect) {
    sizeSelect.addEventListener("change", updateModalPrice);
  }

  // Mobile menu toggle
  const mobileMenuBtn = document.getElementById("mobileMenuButton");
  if (mobileMenuBtn) {
    mobileMenuBtn.addEventListener("click", toggleMobileMenu);
  }

  // Dark mode toggle
  const darkModeToggle = document.getElementById("darkModeToggle");
  if (darkModeToggle) {
    darkModeToggle.addEventListener("click", toggleDarkMode);
  }

  const darkModeToggleMobile = document.getElementById("darkModeToggleMobile");
  if (darkModeToggleMobile) {
    darkModeToggleMobile.addEventListener("click", toggleDarkMode);
  }

  // Initialize Add to Cart buttons
  const addToCartBtns = document.querySelectorAll(".add-to-cart-btn");
  addToCartBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      const productName =
        this.closest(".cake-card").querySelector("h3").textContent;
      alert(`Added ${productName} to cart!`);
      // In a real application, you would add the product to a cart object/array
    });
  });

  // Newsletter form in footer
  const newsletterForm = document.querySelector(".newsletter-form");
  if (newsletterForm) {
    newsletterForm.addEventListener("submit", function (e) {
      e.preventDefault();
      const emailInput = this.querySelector('input[type="email"]');

      if (emailInput.value) {
        alert("Thank you for subscribing to our newsletter!");
        emailInput.value = "";
      } else {
        alert("Please enter your email address");
      }
    });
  }
});

// Mobile menu toggle function
function toggleMobileMenu() {
  const mobileMenu = document.getElementById("mobileMenu");
  mobileMenu.classList.toggle("open");

  const mobileMenuBtn = document.getElementById("mobileMenuButton");
  if (mobileMenu.classList.contains("open")) {
    mobileMenuBtn.innerHTML = '<i class="fas fa-times"></i>';
  } else {
    mobileMenuBtn.innerHTML = '<i class="fas fa-bars"></i>';
  }
}

// Dark mode toggle function
function toggleDarkMode() {
  const isDarkMode = document.body.classList.toggle("dark-mode");
  localStorage.setItem("darkMode", isDarkMode);
  updateDarkModeIcons(isDarkMode);
}

// Update dark mode icons
function updateDarkModeIcons(isDarkMode) {
  const darkModeToggle = document.getElementById("darkModeToggle");
  const darkModeToggleMobile = document.getElementById("darkModeToggleMobile");

  if (isDarkMode) {
    darkModeToggle.innerHTML = '<i class="fas fa-sun"></i>';
    darkModeToggleMobile.innerHTML =
      '<i class="fas fa-sun"></i> Toggle Light Mode';
  } else {
    darkModeToggle.innerHTML = '<i class="fas fa-moon"></i>';
    darkModeToggleMobile.innerHTML =
      '<i class="fas fa-moon"></i> Toggle Dark Mode';
  }
}

// Product modal functions
function openModal(productId) {
  const modal = document.getElementById("productModal");
  const product = products[productId];

  if (!product) return;

  // Fill modal with product data
  document.getElementById("modalImage").src = product.image;
  document.getElementById("modalImage").alt = product.name;
  document.getElementById("modalTitle").textContent = product.name;
  document.getElementById("modalPrice").textContent = `$${product.price.toFixed(
    2
  )}`;
  document.getElementById("modalDescription").textContent = product.description;

  // Reset quantity and size
  document.getElementById("quantity").value = 1;
  document.getElementById("size").selectedIndex = 0;

  // Fill ingredients list
  const ingredientsList = document.getElementById("modalIngredients");
  ingredientsList.innerHTML = "";
  product.ingredients.forEach((ingredient) => {
    const li = document.createElement("li");
    li.textContent = ingredient;
    ingredientsList.appendChild(li);
  });

  // Update initial total price
  updateModalPrice();

  // Show modal
  modal.classList.add("open");
  document.body.style.overflow = "hidden"; // Prevent background scrolling
}

function closeModal() {
  const modal = document.getElementById("productModal");
  modal.classList.remove("open");
  document.body.style.overflow = ""; // Restore scrolling
}

// Close modal if clicking outside of content
document.addEventListener("click", function (e) {
  const modal = document.getElementById("productModal");
  if (e.target === modal) {
    closeModal();
  }
});

// Close modal on escape key
document.addEventListener("keydown", function (e) {
  if (e.key === "Escape") {
    closeModal();
  }
});

// Update price in modal based on quantity and size
function updateModalPrice() {
  const modalTitle = document.getElementById("modalTitle").textContent;
  let productId;

  // Find product ID based on title
  for (const [id, product] of Object.entries(products)) {
    if (product.name === modalTitle) {
      productId = id;
      break;
    }
  }

  if (!productId) return;

  const product = products[productId];
  const basePrice = product.price;
  const quantity = parseInt(document.getElementById("quantity").value) || 1;
  const size = document.getElementById("size").value;

  // Size multipliers
  let sizeMultiplier = 1;
  if (size === "Medium") sizeMultiplier = 1.5;
  if (size === "Large") sizeMultiplier = 2;

  const totalPrice = basePrice * quantity * sizeMultiplier;
  document.getElementById(
    "modalTotalPrice"
  ).textContent = `$${totalPrice.toFixed(2)}`;
}
