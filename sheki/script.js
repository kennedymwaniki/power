document.addEventListener("DOMContentLoaded", () => {
  // Initialize the shopping cart
  const cart = {
    items: [],
    subtotal: 0,
    total: 0,
  };

  // DOM Elements
  const mobileMenuToggle = document.getElementById("mobile-menu-toggle");
  const mobileMenu = document.getElementById("mobile-menu");
  const themeToggle = document.getElementById("theme-toggle");
  const cartToggle = document.getElementById("cart-toggle");
  const cartSidebar = document.getElementById("cart-sidebar");
  const cartOverlay = document.getElementById("cart-overlay");
  const cartClose = document.getElementById("cart-close");
  const cartItems = document.getElementById("cart-items");
  const cartSubtotal = document.getElementById("cart-subtotal");
  const cartTotal = document.getElementById("cart-total");
  const cartCount = document.getElementById("cart-count");
  const checkoutBtn = document.getElementById("checkout-btn");
  const emptyCartMessage = document.getElementById("empty-cart-message");
  const addToCartButtons = document.querySelectorAll(".add-to-cart");
  const petalsContainer = document.getElementById("petals-container");

  // Check for saved theme preference in localStorage
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme === "dark") {
    document.documentElement.classList.add("dark");
    updateThemeIcon(true);
  }

  // Mobile menu toggle
  mobileMenuToggle.addEventListener("click", () => {
    mobileMenu.classList.toggle("hidden");

    // Update toggle icon
    if (mobileMenu.classList.contains("hidden")) {
      mobileMenuToggle.innerHTML = '<i class="fas fa-bars"></i>';
    } else {
      mobileMenuToggle.innerHTML = '<i class="fas fa-times"></i>';
    }
  });

  // Theme toggle
  themeToggle.addEventListener("click", () => {
    const isDarkMode = document.documentElement.classList.toggle("dark");
    localStorage.setItem("theme", isDarkMode ? "dark" : "light");
    updateThemeIcon(isDarkMode);
  });

  // Update theme toggle icon based on current theme
  function updateThemeIcon(isDarkMode) {
    themeToggle.innerHTML = isDarkMode
      ? '<i class="fas fa-sun"></i>'
      : '<i class="fas fa-moon"></i>';
  }

  // Cart toggle
  cartToggle.addEventListener("click", openCart);
  cartClose.addEventListener("click", closeCart);
  cartOverlay.addEventListener("click", closeCart);

  function openCart() {
    cartSidebar.classList.add("open");
    cartOverlay.classList.add("show");
    document.body.style.overflow = "hidden";
  }

  function closeCart() {
    cartSidebar.classList.remove("open");
    cartOverlay.classList.remove("show");
    document.body.style.overflow = "";
  }

  // Add to cart functionality
  addToCartButtons.forEach((button) => {
    button.addEventListener("click", () => {
      const name = button.getAttribute("data-name");
      const price = parseFloat(button.getAttribute("data-price"));

      // For money bouquets, show customization options
      if (button.classList.contains("customize-btn")) {
        customizeMoney(name, price);
        return;
      }

      addToCart(name, price, 1);
    });
  });

  function addToCart(name, price, quantity) {
    // Check if item already exists in cart
    const existingItem = cart.items.find((item) => item.name === name);

    if (existingItem) {
      existingItem.quantity++;
      existingItem.total = existingItem.price * existingItem.quantity;
    } else {
      cart.items.push({
        name,
        price,
        quantity,
        total: price * quantity,
      });
    }

    updateCart();

    // Show feedback
    showToast(`${name} added to your cart!`);
  }

  function customizeMoney(name, basePrice) {
    // In a real app, we would show a modal with options
    // For now we'll use a simple prompt
    const amount = prompt("Enter amount ($):", basePrice);
    if (amount && !isNaN(amount) && amount >= basePrice) {
      addToCart(name, parseFloat(amount), 1);
    } else if (amount) {
      alert(`Minimum amount for this bouquet is $${basePrice}`);
    }
  }

  function updateCart() {
    // Update subtotal and total
    cart.subtotal = cart.items.reduce((sum, item) => sum + item.total, 0);
    cart.total = cart.subtotal; // In a real app, we'd add tax, shipping, etc.

    // Update cart count
    const totalQuantity = cart.items.reduce(
      (sum, item) => sum + item.quantity,
      0
    );
    cartCount.textContent = totalQuantity;

    // Update checkout button state
    checkoutBtn.disabled = totalQuantity === 0;

    // Show/hide empty cart message
    if (totalQuantity === 0) {
      emptyCartMessage.style.display = "block";
    } else {
      emptyCartMessage.style.display = "none";
    }

    // Update cart display
    renderCartItems();

    // Update totals
    cartSubtotal.textContent = `$${cart.subtotal.toFixed(2)}`;
    cartTotal.textContent = `$${cart.total.toFixed(2)}`;
  }

  function renderCartItems() {
    // Clear existing items (except empty message)
    const cartItemElements = document.querySelectorAll(".cart-item");
    cartItemElements.forEach((item) => item.remove());

    // Add items to cart
    cart.items.forEach((item) => {
      const cartItem = document.createElement("div");
      cartItem.className = "cart-item";
      cartItem.innerHTML = `
        <div class="cart-item-info">
          <h4>${item.name}</h4>
          <p class="cart-item-price">$${item.price.toFixed(2)} × ${
        item.quantity
      }</p>
        </div>
        <div class="cart-item-action">
          <span class="cart-item-total">$${item.total.toFixed(2)}</span>
          <div class="cart-item-actions">
            <button class="decrease-item" data-name="${item.name}">
              <i class="fas fa-minus"></i>
            </button>
            <button class="increase-item" data-name="${item.name}">
              <i class="fas fa-plus"></i>
            </button>
            <button class="remove-item" data-name="${item.name}">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      `;

      // Insert before the empty cart message
      cartItems.insertBefore(cartItem, emptyCartMessage);

      // Add event listeners to the new buttons
      cartItem.querySelector(".decrease-item").addEventListener("click", () => {
        decreaseItem(item.name);
      });

      cartItem.querySelector(".increase-item").addEventListener("click", () => {
        increaseItem(item.name);
      });

      cartItem.querySelector(".remove-item").addEventListener("click", () => {
        removeItem(item.name);
      });
    });
  }

  function decreaseItem(name) {
    const item = cart.items.find((item) => item.name === name);
    if (item.quantity > 1) {
      item.quantity--;
      item.total = item.price * item.quantity;
    } else {
      removeItem(name);
    }
    updateCart();
  }

  function increaseItem(name) {
    const item = cart.items.find((item) => item.name === name);
    item.quantity++;
    item.total = item.price * item.quantity;
    updateCart();
  }

  function removeItem(name) {
    const index = cart.items.findIndex((item) => item.name === name);
    if (index !== -1) {
      cart.items.splice(index, 1);
      updateCart();
    }
  }

  // Initialize checkout button
  checkoutBtn.addEventListener("click", () => {
    if (cart.items.length > 0) {
      alert(
        "Thank you for your order! In a real app, we would process your payment here."
      );
      // Clear cart after purchase
      cart.items = [];
      updateCart();
      closeCart();
    }
  });

  // Create and show toast notification
  function showToast(message) {
    const toast = document.createElement("div");
    toast.className = "toast";
    toast.innerHTML = `
      <div class="toast-content">
        <i class="fas fa-check-circle"></i>
        <span>${message}</span>
      </div>
    `;
    document.body.appendChild(toast);

    // Show the toast
    setTimeout(() => {
      toast.classList.add("show");
    }, 10);

    // Auto-hide after 3 seconds
    setTimeout(() => {
      toast.classList.remove("show");
      setTimeout(() => {
        document.body.removeChild(toast);
      }, 300);
    }, 3000);
  }

  // Create floating petals background animation
  function createPetals() {
    const colors = [
      "https://i.imgur.com/ENhUbGq.png", // pink petal
      "https://i.imgur.com/2uLsHCs.png", // white petal
      "https://i.imgur.com/W9ZwXXC.png", // red petal
      "https://i.imgur.com/3ENJZjc.png", // purple petal
    ];

    const PETAL_COUNT = 20;

    for (let i = 0; i < PETAL_COUNT; i++) {
      createPetal(colors);
    }
  }

  function createPetal(colors) {
    const petal = document.createElement("div");
    petal.className = "petal";

    // Random properties
    const size = Math.random() * 40 + 20; // 20-60px
    const color = colors[Math.floor(Math.random() * colors.length)];
    const left = Math.random() * 100; // 0-100%
    const animationDelay = Math.random() * 10;
    const duration = Math.random() * 20 + 15; // 15-35s

    // Apply styles
    petal.style.width = `${size}px`;
    petal.style.height = `${size}px`;
    petal.style.backgroundImage = `url(${color})`;
    petal.style.left = `${left}%`;
    petal.style.top = `-${size}px`;
    petal.style.animationDelay = `${animationDelay}s`;
    petal.style.animationDuration = `${duration}s`;

    // Add falling animation with CSS
    petal.style.animation = `fall ${duration}s linear ${animationDelay}s infinite`;

    // Random rotation animation
    const rotateDir = Math.random() > 0.5 ? "clockwise" : "counterclockwise";
    petal.style.animation += `, ${rotateDir} ${
      Math.random() * 6 + 3
    }s linear infinite`;

    // Add to container
    petalsContainer.appendChild(petal);
  }

  // Add CSS for the petal animations
  function addPetalAnimationStyles() {
    const style = document.createElement("style");
    style.textContent = `
      @keyframes fall {
        0% {
          transform: translate(0, 0) rotate(0deg);
          opacity: 0;
        }
        10% {
          opacity: 1;
        }
        90% {
          opacity: 1;
        }
        100% {
          transform: translate(${
            Math.random() * 100 - 50
          }px, calc(100vh + 60px)) rotate(${Math.random() * 360}deg);
          opacity: 0;
        }
      }
      
      @keyframes clockwise {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
      
      @keyframes counterclockwise {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(-360deg); }
      }
      
      .toast {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background-color: var(--primary-color);
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        box-shadow: var(--shadow-lg);
        display: flex;
        align-items: center;
        transform: translateY(100px);
        opacity: 0;
        transition: transform 0.3s, opacity 0.3s;
        z-index: 1000;
      }
      
      .toast.show {
        transform: translateY(0);
        opacity: 1;
      }
      
      .toast-content {
        display: flex;
        align-items: center;
      }
      
      .toast-content i {
        margin-right: 0.5rem;
      }
    `;
    document.head.appendChild(style);
  }

  // Add smooth scrolling for anchor links
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault();

      // Close mobile menu if open
      if (!mobileMenu.classList.contains("hidden")) {
        mobileMenu.classList.add("hidden");
        mobileMenuToggle.innerHTML = '<i class="fas fa-bars"></i>';
      }

      const target = document.querySelector(this.getAttribute("href"));
      if (target) {
        target.scrollIntoView({
          behavior: "smooth",
        });
      }
    });
  });

  // Initialize the form submission
  const contactForm = document.querySelector(".contact-form form");
  if (contactForm) {
    contactForm.addEventListener("submit", function (e) {
      e.preventDefault();
      alert("Thank you for your message! We will get back to you soon.");
      this.reset();
    });
  }

  // Initialize the newsletter form
  const newsletterForm = document.querySelector(".newsletter-form");
  if (newsletterForm) {
    newsletterForm.addEventListener("submit", function (e) {
      e.preventDefault();
      alert("Thank you for subscribing to our newsletter!");
      this.reset();
    });
  }

  // Initialize the petal animations
  addPetalAnimationStyles();
  createPetals();

  // Initialize the cart
  updateCart();
});
